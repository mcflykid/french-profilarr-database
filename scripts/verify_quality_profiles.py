#!/usr/bin/env python3
"""Audit des dix profils dans la base compilée, avant synchronisation Arr."""

from __future__ import annotations

import re
import sqlite3
from collections import Counter


PROFILE_TARGETS = {
    **{f"FR-{kind}-4K": (2160, 1080, 720) for kind in ("Films", "Series", "Anime")},
    **{f"FR-{kind}-1080p": (1080, 720) for kind in ("Films", "Series", "Anime")},
    **{f"FR-{kind}-720p": (720,) for kind in ("Films", "Series", "Anime")},
    "FR-Films-Any": (2160, 1080, 720, 480),
}


def resolution(quality: str) -> int | None:
    """SD et Unknown partagent le dernier palier du profil de secours Any."""
    if quality in ("Unknown", "SDTV", "DVD"):
        return 480
    match = re.search(r"-(480|576|720|1080|2160)p$", quality)
    if not match:
        return None
    value = int(match.group(1))
    return 480 if value <= 576 else value


def audit_quality_profiles(conn: sqlite3.Connection, *, verbose: bool = True) -> list[str]:
    errors = []
    profiles = conn.execute(
        "SELECT name, upgrades_allowed, minimum_custom_format_score, "
        "upgrade_until_score, upgrade_score_increment FROM quality_profiles ORDER BY name"
    ).fetchall()
    names = {row[0] for row in profiles}
    if names != set(PROFILE_TARGETS):
        errors.append(f"profils absents/inattendus: {sorted(names ^ set(PROFILE_TARGETS))}")

    for name, upgrades, minimum, score_cutoff, increment in profiles:
        if name not in PROFILE_TARGETS:
            continue
        expected = PROFILE_TARGETS[name]
        arr_type = "radarr" if name.startswith("FR-Films-") else "sonarr"
        if upgrades != 1:
            errors.append(f"{name}: mises à niveau désactivées")
        expected_minimum = 500 if name.endswith('-4K') else 400 if name == 'FR-Films-1080p' else 0
        if minimum != expected_minimum or score_cutoff != 60000 or increment != 1400:
            errors.append(f"{name}: seuils CF incohérents ({minimum}, {score_cutoff}, {increment})")

        # PCD : position croissante = meilleur vers moins bon. Profilarr inverse
        # cette liste pour les API Arr (transformer.ts, transformQualityProfile).
        rows = conn.execute(
            "SELECT quality_name, quality_group_name, position, enabled, upgrade_until "
            "FROM quality_profile_qualities WHERE quality_profile_name = ? ORDER BY position",
            (name,),
        ).fetchall()
        if [row[2] for row in rows] != list(range(len(expected))):
            errors.append(f"{name}: positions dupliquées, manquantes ou groupes inattendus")
        if [row[3] for row in rows] != [1] * len(expected):
            errors.append(f"{name}: qualité cible ou fallback désactivé/absent")
        if [row[4] for row in rows] != [1] + [0] * (len(expected) - 1):
            errors.append(f"{name}: cutoff absent, multiple ou situé sur un fallback")

        actual = []
        all_members = []
        for quality, group, position, enabled, cutoff in rows:
            members = [quality] if quality else [
                row[0] for row in conn.execute(
                    "SELECT quality_name FROM quality_group_members "
                    "WHERE quality_profile_name = ? AND quality_group_name = ? ORDER BY position",
                    (name, group),
                ).fetchall()
            ]
            levels = {resolution(member) for member in members}
            if len(levels) != 1 or None in levels:
                errors.append(f"{name}/{group}: groupe vide, résolutions mélangées ou inconnues {members}")
                actual.append(None)
            else:
                actual.append(next(iter(levels)))
            all_members.extend(members)
            for member in members:
                mapping = conn.execute(
                    "SELECT api_name FROM quality_api_mappings WHERE quality_name = ? AND arr_type = ?",
                    (member, arr_type),
                ).fetchone()
                if not mapping:
                    errors.append(f"{name}: qualité {member} indisponible dans {arr_type}")
                if member.startswith("Remux-") or member in ("BR-DISK", "Raw-HD"):
                    errors.append(f"{name}: qualité hors objectif activée: {member}")
        duplicates = [member for member, count in Counter(all_members).items() if count > 1]
        if duplicates:
            errors.append(f"{name}: qualités présentes plusieurs fois: {duplicates}")
        if tuple(actual) != expected:
            errors.append(f"{name}: priorité réelle {actual}, attendue {list(expected)}")
        if verbose:
            order = " > ".join("SD" if level == 480 else str(level) for level in actual)
            print(f"  {name} ({arr_type}): {order}; cutoff={expected[0]}p")

    return errors

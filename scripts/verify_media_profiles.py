#!/usr/bin/env python3
"""Vérifie les presets media compilés et les bornes des qualités autorisées."""

from __future__ import annotations

import math
import re
import sqlite3


# Politique compacte documentée dans docs/installer/tailles.md, Mo/min.
PRESETS = {
    "FR-Media-Radarr": ("radarr", "FR-Films-", {720: 60, 1080: 150, 2160: 250}),
    "FR-Media-Sonarr": ("sonarr", "FR-Series-", {720: 50, 1080: 120, 2160: 150}),
    "FR-Media-Anime-Sonarr": ("sonarr", "FR-Anime-", {720: 40, 1080: 80, 2160: 120}),
}


def audit_media_profiles(conn: sqlite3.Connection, *, verbose: bool = True) -> list[str]:
    errors: list[str] = []
    for preset, (arr, prefix, caps) in PRESETS.items():
        settings = conn.execute(
            f"SELECT propers_repacks, enable_media_info FROM {arr}_media_settings WHERE name = ?",
            (preset,),
        ).fetchone()
        if not settings or tuple(settings) != ("doNotPrefer", 1):
            errors.append(f"{preset}: media settings absents ou repacks/MediaInfo incohérents")
        naming = conn.execute(
            f"SELECT rename, colon_replacement_format FROM {arr}_naming WHERE name = ?",
            (preset,),
        ).fetchone()
        # SQLite accepte 'smart' dans une colonne INTEGER ; Profilarr/Sonarr
        # attend 4, sinon son conversion helper retombe silencieusement à delete.
        expected_colon = "smart" if arr == "radarr" else 4
        if not naming or tuple(naming) != (0, expected_colon):
            errors.append(f"{preset}: naming absent ou rename/smart incorrect pour {arr}")
        if arr == "sonarr":
            style = conn.execute(
                "SELECT multi_episode_style FROM sonarr_naming WHERE name = ?", (preset,)
            ).fetchone()
            if not style or style[0] != 5:
                errors.append(f"{preset}: multi_episode_style doit encoder prefixedRange (5)")

        rows = conn.execute(
            f"SELECT quality_name, min_size, preferred_size, max_size "
            f"FROM {arr}_quality_definitions WHERE name = ?",
            (preset,),
        ).fetchall()
        definitions = {quality: (minimum, preferred, maximum) for quality, minimum, preferred, maximum in rows}
        api_qualities = {
            row[0] for row in conn.execute(
                "SELECT quality_name FROM quality_api_mappings WHERE arr_type = ?", (arr,)
            )
        }
        if set(definitions) != api_qualities:
            errors.append(
                f"{preset}: définitions manquantes/inconnues "
                f"{sorted(set(definitions) ^ api_qualities)}"
            )
        valid_definitions = set()
        api_limit = 2000 if arr == "radarr" else 1000
        for quality, minimum, preferred, maximum in rows:
            if not all(isinstance(value, (int, float)) and math.isfinite(value)
                       for value in (minimum, preferred, maximum)):
                errors.append(f"{preset}/{quality}: tailles non numériques")
                continue
            if not 0 <= minimum <= preferred <= maximum <= api_limit or maximum == 0:
                errors.append(f"{preset}/{quality}: bornes invalides {minimum}/{preferred}/{maximum}")
                continue
            valid_definitions.add(quality)

        profiles = [row[0] for row in conn.execute(
            "SELECT name FROM quality_profiles WHERE name LIKE ? ORDER BY name", (prefix + "%",)
        )]
        for profile in profiles:
            enabled_qualities = {
                row[0] for row in conn.execute(
                    "SELECT quality_name FROM quality_profile_qualities "
                    "WHERE quality_profile_name = ? AND enabled = 1 AND quality_name IS NOT NULL "
                    "UNION SELECT m.quality_name FROM quality_group_members m "
                    "JOIN quality_profile_qualities p ON p.quality_profile_name = m.quality_profile_name "
                    "AND p.quality_group_name = m.quality_group_name "
                    "WHERE p.quality_profile_name = ? AND p.enabled = 1",
                    (profile, profile),
                )
            }
            for quality in sorted(enabled_qualities):
                if quality not in valid_definitions:
                    errors.append(f"{profile}: qualité {quality} sans bornes valides dans {preset}")
                    continue
                match = re.search(r"-(720|1080|2160)p$", quality)
                if not match:
                    continue  # SD/Unknown : repli explicite de Films-Any.
                resolution = int(match.group(1))
                minimum, preferred, maximum = definitions[quality]
                cap = caps[resolution]
                if preset == "FR-Media-Sonarr" and resolution == 1080 and quality != "Bluray-1080p":
                    cap = 100
                if maximum > cap or preferred >= cap:
                    errors.append(
                        f"{profile}/{quality}: cible/plafond hors politique compacte "
                        f"({preferred}/{maximum}, plafond {cap})"
                    )
                # Empêche une borne valide pour l'API mais assez haute pour
                # rejeter les encodes compacts (ancienne régression min=900).
                min_limit = {720: 5, 1080: 8, 2160: 17}[resolution]
                if preset == "FR-Media-Anime-Sonarr" and not (
                    resolution == 2160 and quality != "Bluray-2160p"
                ):
                    min_limit = 5
                if minimum > min_limit:
                    errors.append(f"{profile}/{quality}: minimum {minimum} dépasse l'anti-junk {min_limit}")
        if verbose:
            print(f"  {preset}: {len(rows)} définitions, {len(profiles)} profils, naming et media settings")

    delays = conn.execute(
        "SELECT name, preferred_protocol, torrent_delay, bypass_if_highest_quality, "
        "bypass_if_above_custom_format_score FROM delay_profiles"
    ).fetchall()
    if {row[0] for row in delays} != {"FR-Delay-Radarr", "FR-Delay-Sonarr"}:
        errors.append("presets délai Radarr/Sonarr absents ou inattendus")
    for name, protocol, delay, highest, score_bypass in delays:
        if (protocol, delay, highest, score_bypass) != ("only_torrent", 0, 1, 0):
            errors.append(f"{name}: délai incohérent avec les trackers torrent et le délai nul")
    return errors

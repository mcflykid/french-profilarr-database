#!/usr/bin/env python3
"""Compare un export API Arr sans secrets au SQL, sans contacter ni modifier Arr.

JSON attendu : {"radarr": {"profiles": [...], "qualitydefinitions": [...],
"naming": {...}, "media": {...}}, "sonarr": {...}}. Les listes proviennent des
GET qualityprofile/qualitydefinition et les réglages de config/naming et
config/mediamanagement. L'ordre API est du moins bon vers le meilleur.
Ce contrôle ne simule ni recherche, ni téléchargement, ni import.
"""
from __future__ import annotations

import argparse
import json
from pathlib import Path

from parser_audit import database


def audit_arr_snapshot(conn, snapshot, *, sonarr_preset="FR-Media-Sonarr"):
    errors = []
    profiles_checked = 0
    for arr, preset in (("radarr", "FR-Media-Radarr"), ("sonarr", sonarr_preset)):
        entry = snapshot.get(arr)
        if not isinstance(entry, dict):
            errors.append(f"{arr}: export absent")
            continue
        expected_names = {row[0] for row in conn.execute(
            "SELECT name FROM quality_profiles WHERE name LIKE ?",
            ("FR-Films-%" if arr == "radarr" else "FR-Series-%",)
        )}
        if arr == "sonarr":
            expected_names.update(row[0] for row in conn.execute(
                "SELECT name FROM quality_profiles WHERE name LIKE 'FR-Anime-%'"))
        profiles = entry.get("profiles", [])
        names = [p["name"] for p in profiles]
        for name in sorted(expected_names):
            candidates = [p for p in profiles if p["name"] == name]
            if len(candidates) != 1:
                errors.append(f"{arr}/{name}: attendu un profil, obtenu {len(candidates)}")
                continue
            p = candidates[0]
            row = conn.execute(
                "SELECT upgrades_allowed, minimum_custom_format_score, upgrade_until_score, "
                "upgrade_score_increment FROM quality_profiles WHERE name=?", (name,)
            ).fetchone()
            actual = (p.get("upgradeAllowed"), p.get("minFormatScore"),
                      p.get("cutoffFormatScore"), p.get("minUpgradeFormatScore"))
            if actual != tuple(row):
                errors.append(f"{arr}/{name}: seuils/upgrade différents : {actual} != {tuple(row)}")
            expected_groups = []
            cutoff_name = None
            for quality, group, cutoff in conn.execute(
                "SELECT quality_name, quality_group_name, upgrade_until "
                "FROM quality_profile_qualities WHERE quality_profile_name=? AND enabled=1 ORDER BY position DESC", (name,)
            ):
                members = [quality] if quality else [r[0] for r in conn.execute(
                    "SELECT quality_name FROM quality_group_members WHERE quality_profile_name=? "
                    "AND quality_group_name=? ORDER BY position", (name, group))]
                mapped = [conn.execute(
                    "SELECT api_name FROM quality_api_mappings WHERE quality_name=? AND arr_type=?",
                    (q, arr)).fetchone()[0] for q in members]
                expected_groups.append((group or mapped[0], tuple(sorted(mapped))))
                if cutoff:
                    cutoff_name = group or mapped[0]
            actual_groups = []
            actual_cutoff = None
            for item in p.get("items", []):
                if not item.get("allowed"):
                    continue
                children = item.get("items") or [item]
                label = item.get("name") or item.get("quality", {}).get("name")
                members = tuple(sorted(c["quality"]["name"] for c in children if c.get("allowed")))
                actual_groups.append((label, members))
                if (item.get("id") if item.get("items") else item.get("quality", {}).get("id")) == p.get("cutoff"):
                    actual_cutoff = label
            if actual_groups != expected_groups:
                errors.append(f"{arr}/{name}: ordre ou sources différents : {actual_groups} != {expected_groups}")
            if actual_cutoff != cutoff_name:
                errors.append(f"{arr}/{name}: cutoff {actual_cutoff!r} != {cutoff_name!r}")
            expected_scores = dict(conn.execute(
                "SELECT custom_format_name, score FROM quality_profile_custom_formats "
                "WHERE quality_profile_name=? AND arr_type IN ('all', ?)", (name, arr)))
            formats = p.get("formatItems", [])
            actual_scores = {f["name"]: f["score"] for f in formats}
            if len(actual_scores) != len(formats):
                errors.append(f"{arr}/{name}: Custom Formats homonymes")
            diffs = {cf: (actual_scores.get(cf), score) for cf,score in expected_scores.items()
                     if actual_scores.get(cf) != score}
            extra = {cf: score for cf,score in actual_scores.items() if cf not in expected_scores and score != 0}
            if diffs or extra:
                errors.append(f"{arr}/{name}: scores différents {diffs}, bonus/malus supplémentaires {extra}")
            profiles_checked += 1
        unexpected = sorted(n for n in names if n.startswith("FR-") and n not in expected_names)
        if unexpected:
            errors.append(f"{arr}: profils FR inattendus {unexpected}")
        defs = {d["quality"]["name"]: (d.get("minSize"),d.get("maxSize"),d.get("preferredSize"))
                for d in entry.get("qualitydefinitions", [])}
        for quality, minimum, maximum, preferred in conn.execute(
            f"SELECT quality_name,min_size,max_size,preferred_size FROM {arr}_quality_definitions WHERE name=?", (preset,)
        ):
            mapped = conn.execute("SELECT api_name FROM quality_api_mappings WHERE quality_name=? AND arr_type=?", (quality,arr)).fetchone()[0]
            if defs.get(mapped) != (minimum,maximum,preferred):
                errors.append(f"{arr}/{mapped}: bornes différentes {defs.get(mapped)} != {(minimum,maximum,preferred)}")
        settings = conn.execute(f"SELECT propers_repacks,enable_media_info FROM {arr}_media_settings WHERE name=?", (preset,)).fetchone()
        media = entry.get("media", {})
        if settings is None or (media.get("downloadPropersAndRepacks"),media.get("enableMediaInfo")) != tuple(settings):
            errors.append(f"{arr}: réglages media différents de {preset}")
        naming = conn.execute(f"SELECT rename FROM {arr}_naming WHERE name=?", (preset,)).fetchone()
        if naming is None or entry.get("naming", {}).get("renameMovies" if arr=="radarr" else "renameEpisodes") != bool(naming[0]):
            errors.append(f"{arr}: activation renommage différente de {preset}")
    return profiles_checked, errors


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("snapshot", type=Path)
    parser.add_argument("--sonarr-preset", choices=("FR-Media-Sonarr", "FR-Media-Anime-Sonarr"), default="FR-Media-Sonarr")
    args = parser.parse_args()
    conn = database()
    try:
        checked, errors = audit_arr_snapshot(conn, json.loads(args.snapshot.read_text()), sonarr_preset=args.sonarr_preset)
    finally:
        conn.close()
    for error in errors:
        print("FAIL:", error)
    print(f"Snapshot Arr : {checked} profils examinés, {len(errors)} écart(s)")
    return int(bool(errors))


if __name__ == "__main__":
    raise SystemExit(main())

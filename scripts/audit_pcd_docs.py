#!/usr/bin/env python3
"""
Vérifie le dépôt par rapport à Profilarr v2 + schema PCD 1.1.0.

Références :
- https://v2.dictionarry.dev (PCD, Pull → Compile → Sync, media = nom profil)
- https://github.com/Dictionarry-Hub/schema (1.1.0)
- docs/PROFILARR-V2.md (ce dépôt)
"""

from __future__ import annotations

import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
OPS = ROOT / "ops"
PCD = ROOT / "pcd.json"

ALL_PROFILES = (
    "FR-Films-4K",
    "FR-Films-1080p",
    "FR-Films-720p",
    "FR-Films-Any",
    "FR-Series-4K",
    "FR-Series-1080p",
    "FR-Series-720p",
    "FR-Anime-4K",
    "FR-Anime-1080p",
    "FR-Anime-720p",
)
BLOCK_CF = ("Remux", "Full Disc", "AV1", "Upscaled", "FR-Blockers")
EXPECTED_OPS = (
    "01-tags.sql",
    "02-regex.sql",
    "03-custom-formats.sql",
    "04-custom-format-conditions.sql",
    "05-custom-format-tags.sql",
    "06-quality-profiles.sql",
    "07-media-management.sql",
    "09-profile-media-bundles.sql",
    "10-profile-ui-tags.sql",
)
OPTIONAL_OPS = (
    "11-custom-format-tests.sql",
    "12-quality-profile-tests.sql",
)


def load(name: str) -> str:
    return (OPS / name).read_text(encoding="utf-8")


def main() -> int:
    errors: list[str] = []
    warnings: list[str] = []

    # --- pcd.json ---
    meta = json.loads(PCD.read_text(encoding="utf-8"))
    if meta.get("dependencies", {}).get("https://github.com/Dictionarry-Hub/schema") != "1.1.0":
        errors.append("pcd.json: schema 1.1.0 requis")
    if meta.get("profilarr", {}).get("minimum_version", "") < "2.0.0":
        errors.append("pcd.json: profilarr.minimum_version >= 2.0.0")
    for arr in ("radarr", "sonarr"):
        if arr not in meta.get("arr_types", []):
            errors.append(f"pcd.json: arr_types doit contenir {arr}")

    present = sorted(p.name for p in OPS.glob("*.sql"))
    missing = set(EXPECTED_OPS) - set(present)
    extra = set(present) - set(EXPECTED_OPS) - set(OPTIONAL_OPS)
    if missing:
        errors.append(f"ops/: fichiers manquants: {sorted(missing)}")
    if extra:
        warnings.append(f"ops/: fichiers inattendus: {sorted(extra)}")
    for opt in OPTIONAL_OPS:
        if opt not in present:
            warnings.append(f"ops/{opt}: absent (optionnel parser)")
    if "08" in "".join(present):
        warnings.append("ops/: pas de 08 dans la convention Dictionarry (OK si absent)")

    # --- 01 ---
    tags_01 = set(re.findall(r"INSERT OR IGNORE INTO tags \(name\) VALUES \('([^']+)'\)", load("01-tags.sql")))

    # --- 02 ---
    regex_names = set(
        re.findall(
            r"INSERT INTO regular_expressions \(name, pattern, description\) VALUES \('([^']+)'",
            load("02-regex.sql"),
        )
    )
    from validate_regex_ops import iter_regex_rows

    for name, _pat, desc in iter_regex_rows(load("02-regex.sql")):
        if "*" in desc:
            errors.append(f"02-regex.sql: astérisque dans description ({name})")

    used_in_04 = set(re.findall(r"re\.name = '([^']+)'", load("04-custom-format-conditions.sql")))
    orphan = sorted(regex_names - used_in_04)
    if orphan:
        warnings.append(f"02-regex.sql: regex non référencées dans 04: {orphan}")

    # --- 03 ---
    t03 = load("03-custom-formats.sql")
    if "**" in t03 or "`" in t03:
        errors.append("03-custom-formats.sql: markdown interdit (sync / lisibilité UI)")
    if re.search(r"include_in_rename\) VALUES \([^)]+,\s*1\)", t03):
        errors.append("03-custom-formats.sql: include_in_rename doit rester 0 (doc dépôt)")

    cf_names = set(
        re.findall(
            r"INSERT INTO custom_formats \(name, description, include_in_rename\) VALUES \('([^']+)'",
            t03,
        )
    )

    # --- 04 / 05 ---
    cf_04 = set(
        re.findall(
            r"INSERT INTO custom_format_conditions \(custom_format_name, name, type, arr_type, negate, required\)\s+"
            r"SELECT '([^']+)'",
            load("04-custom-format-conditions.sql"),
        )
    )
    if cf_04 != cf_names:
        errors.append(
            f"04: {len(cf_names - cf_04)} CF sans condition, {len(cf_04 - cf_names)} CF inconnus"
        )

    for tag in re.findall(
        r"INSERT(?: OR IGNORE)? INTO custom_format_tags.*?SELECT '[^']+', '([^']+)' FROM tags",
        load("05-custom-format-tags.sql"),
    ):
        if tag not in tags_01:
            errors.append(f"05: tag '{tag}' absent de 01-tags.sql")

    # --- 06 ---
    t06 = load("06-quality-profiles.sql")
    profiles = set(
        re.findall(
            r"INSERT INTO quality_profiles \(name, description, upgrades_allowed, "
            r"minimum_custom_format_score, upgrade_until_score, upgrade_score_increment\) "
            r"VALUES \('([^']+)'",
            t06,
        )
    )
    if profiles != set(ALL_PROFILES):
        errors.append(f"06: profils attendus: {set(ALL_PROFILES) ^ profiles}")

    for cf in BLOCK_CF:
        for p in ALL_PROFILES:
            m = re.search(
                rf"SELECT '{re.escape(p)}', '{re.escape(cf)}', 'all', (-?\d+)",
                t06,
            )
            if not m or int(m.group(1)) != -999999:
                errors.append(f"06: {p} / {cf} doit être -999999")

    for tag in re.findall(
        r"INSERT OR IGNORE INTO quality_profile_tags \(quality_profile_name, tag_name\)\s+"
        r"SELECT '[^']+', '([^']+)' FROM tags",
        t06,
    ):
        if tag not in tags_01:
            errors.append(f"06: tag profil '{tag}' absent de 01")

    # --- 07 ---
    t07 = load("07-media-management.sql")
    if "preferAndUpgrade" in t07:
        errors.append("07: preferAndUpgrade interdit (v2 → doNotPrefer + FR-Repack*)")
    if "FR-Media-Base" not in t07 or "FR-Delay-Radarr" not in t07:
        errors.append("07: FR-Media-Base ou FR-Delay-Radarr manquant")
    if "FR-Delay-Sonarr" in [
        n for line in t07.splitlines()
        if line.strip().startswith("INSERT")
        for n in re.findall(r"'(FR-Delay-[^']+)'", line)
    ]:
        errors.append("07: FR-Delay-Sonarr doit être dans 09 uniquement")
    if not re.search(
        r"INSERT INTO radarr_naming \(name, rename,.*?VALUES \('FR-Media-Base', 0,",
        t07,
        re.DOTALL,
    ):
        errors.append("07: radarr rename=0 manquant sur FR-Media-Base")
    if not re.search(
        r"INSERT INTO sonarr_naming \(name, rename,.*?VALUES \('FR-Media-Base', 0,",
        t07,
        re.DOTALL,
    ):
        errors.append("07: sonarr rename=0 manquant sur FR-Media-Base")

    # --- 09 ---
    t09 = load("09-profile-media-bundles.sql")
    radarr = set(
        re.findall(
            r"INSERT INTO radarr_media_settings \(name, propers_repacks, enable_media_info\)\s+"
            r"VALUES \('([^']+)'",
            t09,
        )
    )
    sonarr = set(
        re.findall(
            r"INSERT INTO sonarr_media_settings \(name, propers_repacks, enable_media_info\)\s+"
            r"VALUES \('([^']+)'",
            t09,
        )
    )
    if radarr != set(ALL_PROFILES) - {"FR-Series-4K", "FR-Series-1080p", "FR-Series-720p", "FR-Anime-4K", "FR-Anime-1080p", "FR-Anime-720p"}:
        if radarr != {"FR-Films-4K", "FR-Films-1080p", "FR-Films-720p", "FR-Films-Any"}:
            errors.append(f"09: radarr media inattendu: {radarr}")
    expected_radarr = {"FR-Films-4K", "FR-Films-1080p", "FR-Films-720p", "FR-Films-Any"}
    expected_sonarr = set(ALL_PROFILES) - expected_radarr
    if radarr != expected_radarr:
        errors.append(f"09: radarr {radarr ^ expected_radarr}")
    if sonarr != expected_sonarr:
        errors.append(f"09: sonarr {sonarr ^ expected_sonarr}")
    delays_09 = [
        n
        for line in t09.splitlines()
        if line.strip().startswith("INSERT") and "delay_profiles" in line
        for n in re.findall(r"'(FR-Delay-[^']+)'", line)
    ]
    if "FR-Delay-Radarr" in delays_09:
        errors.append("09: FR-Delay-Radarr ne doit pas être ici")
    if "FR-Delay-Sonarr" not in t09:
        errors.append("09: FR-Delay-Sonarr manquant")

    # --- 10 ---
    t10 = load("10-profile-ui-tags.sql").strip()
    if "INSERT" in t10 and "quality_profile_tags" in t10:
        errors.append("10: pas de quality_profile_tags (doublon compile avec 06)")

    # --- 11 / 12 optionnels (parser Profilarr) ---
    for opt in OPTIONAL_OPS:
        if opt not in present:
            warnings.append(f"{opt}: absent (optionnel sans conteneur parser)")

    print("=== Audit documentation Profilarr v2 / PCD 1.1.0 ===\n")
    print(f"pcd.json: schema 1.1.0, version {meta.get('version')}")
    print(f"ops/: {len(present)} fichiers\n")

    for w in warnings:
        print(f"WARN: {w}")
    for e in errors:
        print(f"ERROR: {e}")

    if errors:
        print(f"\nÉCHEC ({len(errors)} erreur(s))")
        return 1
    print(f"\nOK — conformité doc ({len(warnings)} avertissement(s))")
    return 0


if __name__ == "__main__":
    sys.exit(main())

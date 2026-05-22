#!/usr/bin/env python3
"""Validate PCD v2 layout for french-profilarr-database (not YAML v1 parity)."""

from __future__ import annotations

import json
import re
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
OPS = ROOT / "ops"

RADARR_PROFILES = (
    "FR-Films-4K",
    "FR-Films-1080p",
    "FR-Films-720p",
    "FR-Films-Any",
)
SONARR_PROFILES = (
    "FR-Series-4K",
    "FR-Series-1080p",
    "FR-Series-720p",
    "FR-Anime-4K",
    "FR-Anime-1080p",
    "FR-Anime-720p",
)
ALL_PROFILES = RADARR_PROFILES + SONARR_PROFILES

REQUIRED_OPS = (
    "01-tags.sql",
    "02-regex.sql",
    "03-custom-formats.sql",
    "04-custom-format-conditions.sql",
    "05-custom-format-tags.sql",
    "06-quality-profiles.sql",
    "07-media-management.sql",
    "09-profile-media-bundles.sql",
    "10-profile-ui-tags.sql",
    "11-custom-format-tests.sql",
    "12-quality-profile-tests.sql",
)


def read_ops(name: str) -> str:
    return (OPS / name).read_text(encoding="utf-8")


def check_fr_metadata(errors: list[str], warnings: list[str]) -> None:
    """Descriptions + annotations en français (lisibilité Profilarr v2)."""
    print("\n=== Métadonnées FR (descriptions / annotations) ===")

    cf_text = read_ops("03-custom-formats.sql")
    for name, desc in re.findall(
        r"INSERT INTO custom_formats \(name, description, include_in_rename\) "
        r"VALUES \('([^']+)', '((?:''|[^'])*)', \d\);",
        cf_text,
    ):
        plain = desc.replace("''", "'")
        if len(plain.strip()) < 20:
            errors.append(f"custom format description vide ou trop courte: {name}")
        if "Score dans les profils" in plain:
            errors.append(f"description CF non documentée (générique): {name}")

    empty_cf = re.findall(
        r"VALUES \('([^']+)', '', \d\)",
        cf_text,
    )
    for name in empty_cf:
        errors.append(f"custom format sans description: {name}")

    cond_text = read_ops("04-custom-format-conditions.sql")
    if re.search(r"'Not [^']+'", cond_text):
        errors.append("ops/04: annotations anglaises « Not … » encore présentes")
    if "Exclure :" not in cond_text:
        warnings.append("ops/04: aucune annotation « Exclure : » (attendu pour négations)")

    tests_text = read_ops("11-custom-format-tests.sql")
    if "via regex_patterns" in tests_text:
        errors.append("ops/11: libellés tests encore en anglais (via regex_patterns)")
    yaml_refs = len(re.findall(r"custom_formats/[^']+\.yml", tests_text))
    if yaml_refs:
        warnings.append(f"ops/11: {yaml_refs} descriptions pointent encore vers des chemins .yml")

    if not (OPS / "12-quality-profile-tests.sql").exists():
        errors.append("missing ops/12-quality-profile-tests.sql")
    elif "test_entities" not in read_ops("12-quality-profile-tests.sql"):
        warnings.append("ops/12: aucune entité test_entities")

    qtext = read_ops("06-quality-profiles.sql")
    for name, desc in re.findall(
        r"INSERT INTO quality_profiles \(name, description, upgrades_allowed, "
        r"minimum_custom_format_score, upgrade_until_score, upgrade_score_increment\) "
        r"VALUES \('([^']+)', '((?:''|[^'])*)',",
        qtext,
    ):
        plain = desc.replace("''", "'")
        if "Objectif" not in plain and "objectif" not in plain:
            warnings.append(f"profil qualité sans « Objectif » explicite: {name}")
        if len(plain) < 60:
            errors.append(f"description profil trop courte: {name}")

    regex_text = read_ops("02-regex.sql")
    short = [
        n
        for n, d in re.findall(
            r"INSERT INTO regular_expressions \(name, pattern, description\) "
            r"VALUES \('([^']+)', '[^']*', '((?:''|[^'])*)'\);",
            regex_text,
        )
        if len(d.replace("''", "'")) < 25
    ]
    if short:
        warnings.append(f"regex descriptions très courtes: {short[:5]}")

    if errors:
        print("  FAIL     métadonnées FR")
    else:
        print("  OK       métadonnées FR")


def main() -> int:
    errors: list[str] = []
    warnings: list[str] = []

    # --- Manifest ---
    manifest = json.loads((ROOT / "pcd.json").read_text(encoding="utf-8"))
    if manifest.get("profilarr", {}).get("minimum_version", "0") < "2.0.0":
        errors.append("pcd.json: profilarr.minimum_version must be >= 2.0.0")
    deps = manifest.get("dependencies") or {}
    if "https://github.com/Dictionarry-Hub/schema" not in deps:
        errors.append("pcd.json: missing schema dependency URL")

    # --- Ops files ---
    print("=== PCD v2 structure ===")
    for name in REQUIRED_OPS:
        if not (OPS / name).exists():
            errors.append(f"missing ops/{name}")
            print(f"  MISSING  ops/{name}")
        else:
            print(f"  OK       ops/{name}")

    # --- Quality profiles ---
    qtext = read_ops("06-quality-profiles.sql")
    profiles_sql = set(
        re.findall(
            r"INSERT INTO quality_profiles \(name, description, upgrades_allowed, minimum_custom_format_score, upgrade_until_score, upgrade_score_increment\) VALUES \('([^']+)'",
            qtext,
        )
    )
    print(f"\n=== Quality profiles ({len(profiles_sql)}) ===")
    for p in ALL_PROFILES:
        if p not in profiles_sql:
            errors.append(f"quality profile missing: {p}")
            print(f"  MISSING  {p}")
        else:
            print(f"  OK       {p}")

    extra = profiles_sql - set(ALL_PROFILES)
    if extra:
        warnings.append(f"extra quality profiles: {sorted(extra)}")

    # --- Media bundles (v2: name = profile name) ---
    ops09 = read_ops("09-profile-media-bundles.sql")
    radarr_naming_names = set(
        re.findall(
            r"SELECT '([^']+)', rename, movie_format",
            ops09,
        )
    )
    sonarr_media = set(
        re.findall(
            r"INSERT INTO sonarr_media_settings \(name, propers_repacks, enable_media_info\)\s+VALUES \('([^']+)'",
            ops09,
        )
    ) | {"FR-Media-Base"}
    sonarr_naming_names = set(
        re.findall(
            r"SELECT '([^']+)', rename, standard_episode_format",
            ops09,
        )
    )

    print("\n=== Media bundles (profil = nom du bundle, logique v2) ===")
    radarr_media = set(
        re.findall(
            r"INSERT INTO radarr_media_settings \(name, propers_repacks, enable_media_info\)\s+VALUES \('([^']+)'",
            ops09,
        )
    ) | {"FR-Media-Base"}

    for p in RADARR_PROFILES:
        if p not in radarr_naming_names:
            errors.append(f"Radarr naming bundle missing for profile: {p}")
        if p not in radarr_media:
            errors.append(f"Radarr media settings missing for profile: {p}")
        status = "OK" if p in radarr_naming_names else "FAIL"
        print(f"  {status:4}     {p} (Radarr)")

    for p in SONARR_PROFILES:
        if p not in sonarr_naming_names:
            errors.append(f"Sonarr naming bundle missing for profile: {p}")
        if p not in sonarr_media:
            errors.append(f"Sonarr media settings missing for profile: {p}")
        status = "OK" if p in sonarr_naming_names else "FAIL"
        print(f"  {status:4}     {p} (Sonarr)")

    if "FR-Media-Base" not in read_ops("07-media-management.sql"):
        errors.append("FR-Media-Base missing in ops/07")

    # --- Delay profiles (v2: per instance, not per quality profile) ---
    ops07 = read_ops("07-media-management.sql")
    print("\n=== Delay profiles (instance Radarr/Sonarr) ===")
    for name in ("FR-Delay-Radarr", "FR-Delay-Sonarr"):
        found = name in ops07 or name in ops09
        print(f"  {'OK' if found else 'MISSING':4}     {name}")
        if not found:
            errors.append(f"delay profile missing: {name}")

    # --- Repack: v2 uses CF, not native preferAndUpgrade ---
    if "preferAndUpgrade" in ops07:
        errors.append("ops/07: preferAndUpgrade is v1-style; use doNotPrefer (repack via FR-Repack* CF)")

    # --- Custom format tests (v2 parser) ---
    tests = len(
        re.findall(
            r"\('([^']+)', '[^']+', '(?:movie|series)', [01],",
            read_ops("11-custom-format-tests.sql"),
        )
    )
    print(f"\n=== CF tests (parser v2) ===")
    print(f"  {tests} rows in ops/11")
    if tests < 100:
        warnings.append(f"only {tests} custom_format_tests rows")

    check_fr_metadata(errors, warnings)

    # --- Summary ---
    print("\n=== Result ===")
    if warnings:
        for w in warnings:
            print(f"  WARN: {w}")
    if errors:
        for e in errors:
            print(f"  ERROR: {e}")
        return 1
    print("  PCD v2 checks passed.")
    return 0


if __name__ == "__main__":
    sys.exit(main())

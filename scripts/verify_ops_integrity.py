#!/usr/bin/env python3
"""Contrôles statiques ops/*.sql — évite les échecs Compile Profilarr (UNIQUE, FK, schéma)."""

from __future__ import annotations

import re
import sys
from collections import Counter, defaultdict
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
OPS = ROOT / "ops"

CANONICAL_QUALITIES = {
    "Unknown",
    "WORKPRINT",
    "CAM",
    "TELESYNC",
    "TELECINE",
    "DVDSCR",
    "REGIONAL",
    "SDTV",
    "DVD",
    "DVD-R",
    "HDTV-480p",
    "HDTV-720p",
    "HDTV-1080p",
    "HDTV-2160p",
    "WEBDL-480p",
    "WEBDL-720p",
    "WEBDL-1080p",
    "WEBDL-2160p",
    "WEBRip-480p",
    "WEBRip-720p",
    "WEBRip-1080p",
    "WEBRip-2160p",
    "Bluray-480p",
    "Bluray-576p",
    "Bluray-720p",
    "Bluray-1080p",
    "Bluray-2160p",
    "Remux-1080p",
    "Remux-2160p",
    "BR-DISK",
    "Raw-HD",
}

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

RE_CF_TEST = re.compile(
    r"\(\s*'([^']+)',\s*'((?:''|[^'])*)',\s*'(movie|series)',\s*([01]),"
)
RE_QPT = re.compile(
    r"INSERT(?: OR IGNORE)? INTO quality_profile_tags \(quality_profile_name, tag_name\)\s+"
    r"SELECT '([^']+)', '([^']+)'",
)
RE_TAG_INSERT = re.compile(
    r"INSERT(?: OR IGNORE)? INTO tags \(name\) VALUES \('([^']+)'\)"
)
RE_CF = re.compile(
    r"INSERT INTO custom_formats \(name, description, include_in_rename\) "
    r"VALUES \('([^']+)'"
)
RE_REGEX = re.compile(
    r"INSERT INTO regular_expressions \(name, pattern, description\) "
    r"VALUES \('([^']+)'"
)
RE_QDEF = re.compile(
    r"FROM qualities q WHERE q\.name = '([^']+)'"
)
# Radarr API: min/preferred/max size must be <= 2000 (Mo/h in UI)
RE_RADARR_QDEF_SIZES = re.compile(
    r"INSERT INTO radarr_quality_definitions \(name, quality_name, min_size, max_size, preferred_size\)\s+"
    r"SELECT 'FR-Media-Radarr', q\.name, ([\d.]+), ([\d.]+), ([\d.]+)",
    re.MULTILINE,
)
RADARR_SIZE_LIMIT = 2000
RE_DELAY_NAME = re.compile(r"'(FR-Delay-[^']+)'")
RE_RADARR_MEDIA = re.compile(
    r"INSERT INTO radarr_media_settings \(name, propers_repacks, enable_media_info\)\s+"
    r"VALUES \('([^']+)'"
)
RE_SONARR_MEDIA = re.compile(
    r"INSERT INTO sonarr_media_settings \(name, propers_repacks, enable_media_info\)\s+"
    r"VALUES \('([^']+)'"
)
RE_RADARR_NAMING = re.compile(
    r"INSERT INTO radarr_naming \(name,"
)
RE_RADARR_NAMING_SELECT = re.compile(
    r"SELECT '([^']+)', rename, movie_format"
)
RE_ENTITY = re.compile(
    r"INSERT INTO test_entities \(type, tmdb_id, title, year\)\s+"
    r"VALUES \('([^']+)', (\d+),"
)


def read(name: str) -> str:
    return (OPS / name).read_text(encoding="utf-8")


def unesc(s: str) -> str:
    return s.replace("''", "'")


def main() -> int:
    errors: list[str] = []
    warnings: list[str] = []

    file_status: dict[str, str] = {}

    def ok(name: str) -> None:
        file_status[name] = "OK"

    def fail(name: str, msg: str) -> None:
        file_status[name] = "FAIL"
        errors.append(f"{name}: {msg}")

    print("=== Audit ops/ (fichier par fichier) ===\n")

    # --- 01-tags.sql ---
    t01 = read("01-tags.sql")
    tags_01 = RE_TAG_INSERT.findall(t01)
    print("01-tags.sql")
    dup_tags = [n for n, c in Counter(tags_01).items() if c > 1]
    if dup_tags:
        fail("01-tags.sql", f"tags dupliqués: {dup_tags}")
    else:
        ok("01-tags.sql")
    print(f"  {len(tags_01)} tags, doublons: {len(dup_tags)}")

    # --- 02-regex.sql ---
    t02 = read("02-regex.sql")
    regex_names = set(RE_REGEX.findall(t02))
    print(f"\n02-regex.sql\n  {len(regex_names)} regex")
    if len(regex_names) != len(RE_REGEX.findall(t02)):
        fail("02-regex.sql", "noms de regex dupliqués")
    else:
        ok("02-regex.sql")

    # --- 03-custom-formats.sql ---
    t03 = read("03-custom-formats.sql")
    cf_names = set(RE_CF.findall(t03))
    print(f"\n03-custom-formats.sql\n  {len(cf_names)} custom formats")
    if len(cf_names) != len(RE_CF.findall(t03)):
        fail("03-custom-formats.sql", "noms CF dupliqués")
    else:
        ok("03-custom-formats.sql")

    # --- 04 / 05 références ---
    t04 = read("04-custom-format-conditions.sql")
    t05 = read("05-custom-format-tags.sql")
    cf_in_04 = set(re.findall(r"SELECT '([^']+)'", t04))  # too broad
    cf_cond = set(re.findall(r"custom_format_name, name, type", t04))
    cf_04 = set(
        re.findall(
            r"INSERT INTO custom_format_conditions \(custom_format_name, name, type",
            t04,
        )
    )
    cf_04_names = set(
        re.findall(
            r"INSERT INTO custom_format_conditions \(custom_format_name, name, type, arr_type, negate, required\)\s+"
            r"SELECT '([^']+)'",
            t04,
        )
    )
    pat_04 = set(
        re.findall(
            r"INSERT INTO condition_patterns \(custom_format_name, condition_name, regular_expression_name\)\s+"
            r"SELECT '[^']+', '[^']+', re\.name FROM regular_expressions re WHERE re\.name = '([^']+)'",
            t04,
        )
    )
    missing_regex = pat_04 - regex_names
    missing_cf_04 = cf_04_names - cf_names
    if missing_regex:
        fail("04-custom-format-conditions.sql", f"regex absentes de 02: {sorted(missing_regex)[:5]}")
    elif missing_cf_04:
        fail("04-custom-format-conditions.sql", f"CF absents de 03: {sorted(missing_cf_04)[:5]}")
    else:
        ok("04-custom-format-conditions.sql")
    cf_05 = set(
        re.findall(
            r"INSERT INTO custom_format_tags \(custom_format_name, tag_name\)\s+SELECT '([^']+)'",
            t05,
        )
    )
    missing_cf_05 = cf_05 - cf_names
    if missing_cf_05:
        fail("05-custom-format-tags.sql", f"CF absents de 03: {sorted(missing_cf_05)[:5]}")
    else:
        ok("05-custom-format-tags.sql")
    print(f"\n04-custom-format-conditions.sql\n  {len(cf_04_names)} CF, regex manquantes: {len(missing_regex)}")
    print(f"\n05-custom-format-tags.sql\n  {len(cf_05)} CF liés")

    # --- 06 quality profiles + tags ---
    t06 = read("06-quality-profiles.sql")
    qpt_06 = [(p, t) for p, t in RE_QPT.findall(t06)]
    profiles_06 = set(
        re.findall(
            r"INSERT INTO quality_profiles \(name, description, upgrades_allowed, "
            r"minimum_custom_format_score, upgrade_until_score, upgrade_score_increment\) "
            r"VALUES \('([^']+)'",
            t06,
        )
    )
    dup_qpt_06 = [k for k, c in Counter(qpt_06).items() if c > 1]
    missing_prof = set(ALL_PROFILES) - profiles_06
    extra_prof = profiles_06 - set(ALL_PROFILES)
    scores_cf = set(
        re.findall(
            r"SELECT '(FR-[^']+)', '([^']+)', 'all', (-?\d+)",
            t06,
        )
    )
    bad_cf_scores = {cf for _, cf, _ in scores_cf if cf not in cf_names}
    if dup_qpt_06:
        fail("06-quality-profiles.sql", f"quality_profile_tags dupliqués: {dup_qpt_06[:3]}")
    elif missing_prof:
        fail("06-quality-profiles.sql", f"profils manquants: {missing_prof}")
    elif bad_cf_scores:
        fail("06-quality-profiles.sql", f"scores CF inconnus: {sorted(bad_cf_scores)[:5]}")
    else:
        ok("06-quality-profiles.sql")
    if extra_prof:
        warnings.append(f"06: profils extra: {extra_prof}")
    print(f"\n06-quality-profiles.sql\n  {len(profiles_06)} profils, {len(qpt_06)} tags profil, dup: {len(dup_qpt_06)}")
    print(f"  scores CF: {len(scores_cf)}, CF inconnus: {len(bad_cf_scores)}")

    # --- 07 media ---
    t07 = read("07-media-management.sql")
    q_bad = set(RE_QDEF.findall(t07)) - CANONICAL_QUALITIES
    delays_07 = [n for n in RE_DELAY_NAME.findall(t07) if n.startswith("FR-Delay-")]
    if q_bad:
        fail("07-media-management.sql", f"qualités invalides: {sorted(q_bad)}")
    elif "FR-Delay-Radarr" not in delays_07:
        fail("07-media-management.sql", "FR-Delay-Radarr manquant")
    elif "FR-Media-Radarr" not in t07:
        fail("07-media-management.sql", "preset FR-Media-Radarr manquant")
    elif "FR-Media-Sonarr" not in t07:
        fail("07-media-management.sql", "preset FR-Media-Sonarr manquant")
    elif "FR-Media-Anime-Sonarr" not in t07:
        fail("07-media-management.sql", "preset FR-Media-Anime-Sonarr manquant")
    elif "FR-Media-Base" in t07:
        fail("07-media-management.sql", "FR-Media-Base ne doit plus exister (utiliser FR-Media-Radarr/Sonarr)")
    else:
        over_radarr = [
            (mn, mx, pr)
            for mn, mx, pr in RE_RADARR_QDEF_SIZES.findall(t07)
            if float(mn) > RADARR_SIZE_LIMIT
            or float(mx) > RADARR_SIZE_LIMIT
            or float(pr) > RADARR_SIZE_LIMIT
        ]
        if over_radarr:
            fail(
                "07-media-management.sql",
                f"radarr_quality_definitions > {RADARR_SIZE_LIMIT}: {over_radarr[:3]}",
            )
        else:
            ok("07-media-management.sql")
    print(f"\n07-media-management.sql\n  qualités invalides: {len(q_bad)}, delays: {len(delays_07)}")

    # --- 09 delay Sonarr (media instance = FR-Media-Radarr/Sonarr dans ops/07) ---
    t09 = read("09-profile-media-bundles.sql")
    radarr_media_09 = set(RE_RADARR_MEDIA.findall(t09))
    sonarr_media_09 = set(RE_SONARR_MEDIA.findall(t09))
    delays_09 = [n for n in RE_DELAY_NAME.findall(t09) if n.startswith("FR-Delay-")]
    if radarr_media_09 or sonarr_media_09:
        fail(
            "09-profile-media-bundles.sql",
            "pas de bundle media par profil (utiliser FR-Media-Radarr/Sonarr dans ops/07)",
        )
    elif "FR-Delay-Radarr" in delays_09:
        fail("09-profile-media-bundles.sql", "FR-Delay-Radarr doit être dans ops/07 seulement")
    elif "FR-Delay-Sonarr" not in delays_09:
        fail("09-profile-media-bundles.sql", "FR-Delay-Sonarr manquant")
    else:
        ok("09-profile-media-bundles.sql")
    print(f"\n09-profile-media-bundles.sql\n  delays: {delays_09}")

    # --- 10 UI tags (cross 06) ---
    t10 = read("10-profile-ui-tags.sql")
    tags_10_new = RE_TAG_INSERT.findall(t10)
    dup_10_tags = [n for n, c in Counter(tags_10_new).items() if c > 1]
    qpt_10 = RE_QPT.findall(t10)
    all_qpt: list[tuple[str, str, str]] = [
        ("06", p, t) for p, t in qpt_06
    ] + [("10", p, t) for p, t in qpt_10]
    cross_dupes = [k for k, c in Counter((p, t) for _, p, t in all_qpt).items() if c > 1]
    if cross_dupes:
        fail("10-profile-ui-tags.sql", f"quality_profile_tags en double avec ops/06: {cross_dupes}")
    elif dup_10_tags:
        fail("10-profile-ui-tags.sql", f"tags INSERT dupliqués: {dup_10_tags}")
    else:
        ok("10-profile-ui-tags.sql")
    tags_all = set(tags_01) | set(tags_10_new)
    for p, t in qpt_10:
        if t not in tags_all and t not in {x for _, x in qpt_06}:
            # tag may exist from 06's other inserts
            if t not in {tag for _, tag in qpt_06} and t not in tags_10_new and t not in tags_01:
                warnings.append(f"10: tag '{t}' pas dans 01 ni créé dans 10")
    print(f"\n10-profile-ui-tags.sql\n  nouveaux tags: {len(tags_10_new)}, conflits 06+10: {len(cross_dupes)}")

    # --- 11 tests ---
    t11 = read("11-custom-format-tests.sql")
    tests = [
        (unesc(cf), unesc(title), typ, int(sm))
        for cf, title, typ, sm in RE_CF_TEST.findall(t11)
    ]
    dup_tests = [k for k, c in Counter((a, b, c) for a, b, c, _ in tests).items() if c > 1]
    bad_cf_test = {cf for cf, _, _, _ in tests if cf not in cf_names}
    if dup_tests:
        fail("11-custom-format-tests.sql", f"{len(dup_tests)} doublons (cf,title,type)")
    elif bad_cf_test:
        fail("11-custom-format-tests.sql", f"CF inconnus: {sorted(bad_cf_test)[:5]}")
    else:
        ok("11-custom-format-tests.sql")
    print(f"\n11-custom-format-tests.sql\n  {len(tests)} tests, doublons: {len(dup_tests)}, CF invalides: {len(bad_cf_test)}")

    # --- 12 profile tests ---
    t12 = read("12-quality-profile-tests.sql")
    entities = RE_ENTITY.findall(t12)
    dup_ent = [k for k, c in Counter((a, int(b)) for a, b in entities).items() if c > 1]
    if dup_ent:
        fail("12-quality-profile-tests.sql", f"test_entities dupliqués: {dup_ent}")
    else:
        ok("12-quality-profile-tests.sql")
    print(f"\n12-quality-profile-tests.sql\n  entités: {len(entities)}, doublons: {len(dup_ent)}")

    # --- Ordre fichiers ---
    expected_order = sorted(OPS.glob("*.sql"))
    print(f"\n=== Ordre ops/ ({len(expected_order)} fichiers) ===")
    for p in expected_order:
        print(f"  {p.name}")

    print("\n=== Synthèse par fichier ===")
    for fname in sorted(file_status):
        print(f"  {file_status[fname]:4}  {fname}")

    print("\n=== Résultat ===")
    for w in warnings:
        print(f"  WARN: {w}")
    if errors:
        for e in errors:
            print(f"  ERROR: {e}")
        return 1
    print("  Intégrité ops/ OK (contrôles statiques).")
    return 0


if __name__ == "__main__":
    sys.exit(main())

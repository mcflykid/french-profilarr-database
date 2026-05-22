#!/usr/bin/env python3
"""
Vérifie que chaque fichier du dépôt est fonctionnel après compile PCD,
selon Profilarr v2 (Pull → Compile → Sync) et schema 1.1.0.
"""

from __future__ import annotations

import json
import sqlite3
import sys
import tempfile
import urllib.request
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
OPS = ROOT / "ops"
SCHEMA_BASE = "https://raw.githubusercontent.com/Dictionarry-Hub/schema/1.1.0/ops"
SCHEMA_FILES = (
    "0.schema.sql",
    "1.languages.sql",
    "2.qualities.sql",
    "3.quality-group-member-position.sql",
)
PROFILES = (
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
RADARR = frozenset(
    {"FR-Films-4K", "FR-Films-1080p", "FR-Films-720p", "FR-Films-Any"}
)
SONARR = frozenset(PROFILES) - RADARR


def fetch_schema(name: str) -> str:
    with urllib.request.urlopen(f"{SCHEMA_BASE}/{name}", timeout=60) as resp:
        return resp.read().decode("utf-8")


def compile_conn() -> sqlite3.Connection:
    conn = sqlite3.connect(":memory:")
    for name in SCHEMA_FILES:
        conn.executescript(fetch_schema(name))
    for path in sorted(OPS.glob("*.sql")):
        conn.executescript(path.read_text(encoding="utf-8"))
    conn.commit()
    return conn


def main() -> int:
    errors: list[str] = []
    lines: list[str] = []

    def ok(file: str, msg: str) -> None:
        lines.append(f"  OK   {file:42} {msg}")

    def fail(file: str, msg: str) -> None:
        lines.append(f"  FAIL {file:42} {msg}")
        errors.append(f"{file}: {msg}")

    # --- pcd.json (link + compile Profilarr) ---
    meta = json.loads((ROOT / "pcd.json").read_text(encoding="utf-8"))
    if meta.get("dependencies", {}).get("https://github.com/Dictionarry-Hub/schema") != "1.1.0":
        fail("pcd.json", "dépendance schema 1.1.0 requise")
    elif meta.get("profilarr", {}).get("minimum_version", "") < "2.0.0":
        fail("pcd.json", "profilarr.minimum_version >= 2.0.0")
    elif not {"radarr", "sonarr"} <= set(meta.get("arr_types", [])):
        fail("pcd.json", "arr_types radarr + sonarr")
    else:
        ok("pcd.json", "manifeste PCD — lien dépôt + compile schema")

    conn = compile_conn()

    # --- 01 ---
    n_tags = conn.execute("SELECT COUNT(*) FROM tags").fetchone()[0]
    if n_tags < 20:
        fail("01-tags.sql", f"seulement {n_tags} tags")
    else:
        ok("01-tags.sql", f"{n_tags} tags — prérequis FK 05/06")

    # --- 02 (sync *arr : regex reliées aux CF) ---
    orphan = [
        r[0]
        for r in conn.execute(
            """
            SELECT re.name FROM regular_expressions re
            WHERE NOT EXISTS (
              SELECT 1 FROM condition_patterns cp
              WHERE cp.regular_expression_name = re.name
            )
            """
        ).fetchall()
    ]
    n_re = conn.execute("SELECT COUNT(*) FROM regular_expressions").fetchone()[0]
    if orphan:
        fail("02-regex.sql", f"regex sans condition: {orphan}")
    else:
        ok("02-regex.sql", f"{n_re} regex — utilisables au sync Sonarr/Radarr")

    # --- 03 ---
    n_cf = conn.execute("SELECT COUNT(*) FROM custom_formats").fetchone()[0]
    bad = conn.execute(
        "SELECT COUNT(*) FROM custom_formats WHERE include_in_rename != 0"
    ).fetchone()[0]
    if bad:
        fail("03-custom-formats.sql", "include_in_rename doit être 0")
    else:
        ok("03-custom-formats.sql", f"{n_cf} CF — export sync sans renommage CF")

    # --- 04 ---
    missing = conn.execute(
        """
        SELECT cf.name FROM custom_formats cf
        WHERE NOT EXISTS (
          SELECT 1 FROM custom_format_conditions c
          WHERE c.custom_format_name = cf.name
        )
        """
    ).fetchall()
    if missing:
        fail("04-custom-format-conditions.sql", f"CF sans condition: {missing[:3]}")
    else:
        ok("04-custom-format-conditions.sql", "chaque CF a des conditions actives")

    # --- 05 ---
    no_tag = conn.execute(
        """
        SELECT cf.name FROM custom_formats cf
        WHERE NOT EXISTS (
          SELECT 1 FROM custom_format_tags t WHERE t.custom_format_name = cf.name
        )
        """
    ).fetchall()
    if no_tag:
        fail("05-custom-format-tags.sql", f"CF sans tag UI: {no_tag[:3]}")
    else:
        ok("05-custom-format-tags.sql", "tags CF — filtres dans l’UI Profilarr")

    # --- 06 ---
    for p in PROFILES:
        if not conn.execute(
            "SELECT 1 FROM quality_profiles WHERE name=?", (p,)
        ).fetchone():
            fail("06-quality-profiles.sql", f"profil absent: {p}")
            break
        qg = conn.execute(
            "SELECT COUNT(*) FROM quality_groups WHERE quality_profile_name=?",
            (p,),
        ).fetchone()[0]
        qm = conn.execute(
            "SELECT COUNT(*) FROM quality_group_members WHERE quality_profile_name=?",
            (p,),
        ).fetchone()[0]
        sc = conn.execute(
            "SELECT COUNT(*) FROM quality_profile_custom_formats WHERE quality_profile_name=?",
            (p,),
        ).fetchone()[0]
        if not (qg and qm and sc):
            fail(
                "06-quality-profiles.sql",
                f"{p}: groupes={qg} membres={qm} scores={sc}",
            )
            break
    else:
        remux_n = conn.execute(
            """
            SELECT COUNT(DISTINCT quality_profile_name)
            FROM quality_profile_custom_formats
            WHERE custom_format_name='Remux' AND score=-999999
            """
        ).fetchone()[0]
        if remux_n != len(PROFILES):
            fail("06-quality-profiles.sql", f"Remux -999999 sur {remux_n}/10 profils")
        else:
            ok(
                "06-quality-profiles.sql",
                "10 profils + scores — assignables bibliothèques *arr",
            )

    # --- 07 ---
    for tbl in ("radarr_naming", "sonarr_naming"):
        r = conn.execute(
            f"SELECT rename FROM {tbl} WHERE name='FR-Media-Base'"
        ).fetchone()
        if not r or r[0] != 0:
            fail("07-media-management.sql", f"{tbl} rename != 0")
            break
    else:
        if "FR-Delay-Radarr" not in (OPS / "07-media-management.sql").read_text():
            fail("07-media-management.sql", "INSERT FR-Delay-Radarr manquant")
        elif not conn.execute(
            "SELECT 1 FROM delay_profiles WHERE name='FR-Delay-Radarr'"
        ).fetchone():
            fail("07-media-management.sql", "FR-Delay-Radarr absent après compile")
        elif not conn.execute(
            "SELECT 1 FROM radarr_media_settings WHERE name='FR-Media-Base'"
        ).fetchone():
            fail("07-media-management.sql", "FR-Media-Base manquant")
        else:
            ok(
                "07-media-management.sql",
                "modèle FR-Media-Base + delay Radarr — instance Radarr",
            )

    # --- 09 ---
    t09 = (OPS / "09-profile-media-bundles.sql").read_text(encoding="utf-8")
    radarr_delay_in_09 = any(
        "FR-Delay-Radarr" in line
        and "INSERT" in line
        and "delay_profiles" in line
        for line in t09.splitlines()
        if line.strip() and not line.strip().startswith("--")
    )
    if radarr_delay_in_09:
        fail(
            "09-profile-media-bundles.sql",
            "FR-Delay-Radarr doit rester dans 07 uniquement",
        )
    elif "FR-Delay-Sonarr" not in t09:
        fail("09-profile-media-bundles.sql", "FR-Delay-Sonarr manquant")
    for p in RADARR:
        if not conn.execute(
            "SELECT 1 FROM radarr_media_settings WHERE name=?", (p,)
        ).fetchone():
            fail("09-profile-media-bundles.sql", f"bundle Radarr manquant: {p}")
            break
        if not conn.execute(
            "SELECT 1 FROM radarr_naming WHERE name=?", (p,)
        ).fetchone():
            fail("09-profile-media-bundles.sql", f"naming Radarr manquant: {p}")
            break
    else:
        for p in SONARR:
            if not conn.execute(
                "SELECT 1 FROM sonarr_media_settings WHERE name=?", (p,)
            ).fetchone():
                fail("09-profile-media-bundles.sql", f"bundle Sonarr manquant: {p}")
                break
            if not conn.execute(
                "SELECT 1 FROM sonarr_naming WHERE name=?", (p,)
            ).fetchone():
                fail("09-profile-media-bundles.sql", f"naming Sonarr manquant: {p}")
                break
        else:
            ok(
                "09-profile-media-bundles.sql",
                "10 presets media = noms profils + delay Sonarr",
            )

    # --- 10 ---
    t10 = (OPS / "10-profile-ui-tags.sql").read_text(encoding="utf-8")
    if "quality_profile_tags" in t10 and "INSERT" in t10:
        fail("10-profile-ui-tags.sql", "doublon compile avec 06")
    else:
        ok("10-profile-ui-tags.sql", "vide — compile stable")

    # --- 11 (parser optionnel) ---
    if (OPS / "11-custom-format-tests.sql").is_file():
        bad_t = conn.execute(
            """
            SELECT COUNT(*) FROM custom_format_tests t
            WHERE NOT EXISTS (
              SELECT 1 FROM custom_formats cf WHERE cf.name = t.custom_format_name
            )
            """
        ).fetchone()[0]
        nt = conn.execute("SELECT COUNT(*) FROM custom_format_tests").fetchone()[0]
        if bad_t:
            fail("11-custom-format-tests.sql", f"{bad_t} tests CF invalides")
        else:
            ok(
                "11-custom-format-tests.sql",
                f"{nt} tests — onglet parser Profilarr (si service actif)",
            )

    # --- 12 ---
    if (OPS / "12-quality-profile-tests.sql").is_file():
        ne = conn.execute("SELECT COUNT(*) FROM test_entities").fetchone()[0]
        nr = conn.execute("SELECT COUNT(*) FROM test_releases").fetchone()[0]
        if ne < 1 or nr < 1:
            fail("12-quality-profile-tests.sql", "entités/releases vides")
        else:
            ok(
                "12-quality-profile-tests.sql",
                f"{ne} films/séries simulés — preview profil UI",
            )

    # --- Workflow Sync (doc §7) ---
    for p in PROFILES:
        if p in RADARR:
            if not conn.execute(
                "SELECT 1 FROM radarr_media_settings WHERE name=?", (p,)
            ).fetchone():
                fail("(Sync Radarr)", f"profil {p} sans media management")
                break
        elif not conn.execute(
            "SELECT 1 FROM sonarr_media_settings WHERE name=?", (p,)
        ).fetchone():
            fail("(Sync Sonarr)", f"profil {p} sans media management")
            break
    else:
        ok(
            "(workflow)",
            "profil qualité + delay + media — pas d’erreur « require media »",
        )

    conn.close()

    print("=== Fonctionnel par fichier (Profilarr v2) ===\n")
    for line in lines:
        print(line)
    print()
    if errors:
        for e in errors:
            print(f"ERROR: {e}")
        return 1
    print("OK: chaque fichier est fonctionnel après compile PCD.")
    return 0


if __name__ == "__main__":
    sys.exit(main())

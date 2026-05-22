#!/usr/bin/env python3
"""Simule la compilation PCD (schema 1.1.0 + ops/*.sql) comme Profilarr v2."""

from __future__ import annotations

import sqlite3
import sys
import tempfile
import urllib.request
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
OPS = ROOT / "ops"
SCHEMA_TAG = "1.1.0"
SCHEMA_BASE = (
    f"https://raw.githubusercontent.com/Dictionarry-Hub/schema/{SCHEMA_TAG}/ops"
)
SCHEMA_FILES = (
    "0.schema.sql",
    "1.languages.sql",
    "2.qualities.sql",
    "3.quality-group-member-position.sql",
)


def fetch_schema_sql(name: str) -> str:
    url = f"{SCHEMA_BASE}/{name}"
    with urllib.request.urlopen(url, timeout=60) as resp:
        return resp.read().decode("utf-8")


def main() -> int:
    ops_files = sorted(OPS.glob("*.sql"))
    if not ops_files:
        print("ERROR: no ops/*.sql")
        return 1

    with tempfile.TemporaryDirectory() as tmp:
        db_path = Path(tmp) / "compile-test.db"
        conn = sqlite3.connect(db_path)
        try:
            for name in SCHEMA_FILES:
                print(f"  schema  {name}")
                conn.executescript(fetch_schema_sql(name))

            for path in ops_files:
                print(f"  ops     {path.name}")
                conn.executescript(path.read_text(encoding="utf-8"))

            conn.commit()
            # Idempotence tags (doublon ops/06 + ops/10 ne doit plus planter)
            tag_probe = """
            INSERT OR IGNORE INTO quality_profile_tags (quality_profile_name, tag_name)
            SELECT 'FR-Films-4K', 'Radarr' FROM tags t WHERE t.name = 'Radarr';
            """
            conn.executescript(tag_probe)
            conn.executescript(tag_probe)
            conn.executescript((OPS / "01-tags.sql").read_text(encoding="utf-8"))
            conn.executescript((OPS / "10-profile-ui-tags.sql").read_text(encoding="utf-8"))
            conn.commit()

            row = conn.execute(
                "SELECT COUNT(*) FROM sonarr_quality_definitions "
                "WHERE name = 'FR-Media-Base' AND quality_name IN ('Remux-1080p', 'Remux-2160p')"
            ).fetchone()
            if row[0] != 2:
                print(
                    f"ERROR: FR-Media-Base Sonarr remux defs expected 2, got {row[0]}"
                )
                return 1

            dup = conn.execute(
                """
                SELECT quality_profile_name, tag_name, COUNT(*) AS n
                FROM quality_profile_tags
                GROUP BY quality_profile_name, tag_name
                HAVING n > 1
                """
            ).fetchall()
            if dup:
                print(f"ERROR: duplicate quality_profile_tags: {dup[:5]}")
                return 1

            media = conn.execute(
                "SELECT name FROM radarr_media_settings WHERE name LIKE 'FR-Films-%'"
            ).fetchall()
            if len(media) < 4:
                print(f"ERROR: expected 4 FR-Films-* media bundles, got {len(media)}")
                return 1
        except sqlite3.Error as e:
            print(f"ERROR: compile failed: {e}")
            return 1
        finally:
            conn.close()

    print("OK: PCD compile simulation passed (schema + ops)")
    return 0


if __name__ == "__main__":
    sys.exit(main())

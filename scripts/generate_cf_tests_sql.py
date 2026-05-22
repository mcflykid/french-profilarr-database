#!/usr/bin/env python3
"""Regénère ops/11-custom-format-tests.sql depuis le fichier actuel + SCENE_EXTRAS."""

from __future__ import annotations

import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "ops" / "11-custom-format-tests.sql"
SRC = OUT

LINE_TEST_RE = re.compile(
    r"\s*\('([^']+)', '((?:[^']|'')*)', '(movie|series)', ([01]), '([^']*(?:''[^']*)*)'\),?"
)

SCENE_EXTRAS: list[tuple[str, str, str, int, str]] = [
    (
        "FR-MULTI-VFF",
        "La.Momie.1999.MULTI.VFF.2160p.WEB.DV.HDR10PLUS.AC3.5.1.H265-Slay3R",
        "movie",
        1,
        "Capture — Momie tags complets",
    ),
    (
        "FR-MULTI-VFF",
        "La.Momie.1999.MULTI.TRUEFRENCH.2160p.WEB.DV.HDR.DV.WEB-DL.H265-Slay3R",
        "movie",
        1,
        "Capture — Momie TRUEFRENCH",
    ),
    (
        "FR-MULTI-VFF",
        "Person.Of.Interest.S05.MULTI.FRENCH.1080p.WEBRip.x265-DELIRIUS",
        "series",
        1,
        "qBit cross-seed POI S05",
    ),
    (
        "FR-MULTI-VF2",
        "Incendies.2010.VOQ.2160p.BluRay.DDP.x265-QTZ",
        "movie",
        0,
        "VOQ seul sans MULTI — ne doit pas matcher FR-MULTI-VF2",
    ),
    (
        "FR-MULTI-VF2",
        "Incendies.2010.MULTI.VOQ.2160p.BluRay.DDP.x265-QTZ",
        "movie",
        1,
        "MULTI + VOQ — doit matcher FR-MULTI-VF2",
    ),
    (
        "FR-VF2",
        "Incendies.2010.VOQ.2160p.BluRay.DDP.x265-QTZ",
        "movie",
        1,
        "VOQ seul — doit matcher FR-VF2 (pas FR-MULTI-VF2)",
    ),
    (
        "FR-Team-QTZ",
        "1917.2019.MULTI.VFF.2160p.BluRay.4KLight.HDR10Plus.TrueHD.7.1.Atmos.x265-QTZ",
        "movie",
        1,
        "Slot 4KLight QTZ",
    ),
    (
        "FR-Team-TyHD",
        "La.Momie.1999.MULTI.VFF.2160p.WEB.DV.HDR10PLUS.AC3.5.1.H265-TyHD",
        "movie",
        1,
        "Capture — Momie TyHD 2160p",
    ),
    (
        "FR-Team-TyHD",
        "Nightmare.Island.2020.MULTI.VFQ.2160p.WEB.SDR.AC3.5.1.H265-TyHD",
        "movie",
        1,
        "TyHD WEB 2160p VFQ",
    ),
    (
        "FR-Team-Slay3R",
        "Caught.Stealing.2025.MULTI.VF2.2160p.WEB.DV.HDR10Plus.AC3.5.1.H265-Slay3R",
        "movie",
        1,
        "Capture Slay3R DV",
    ),
    (
        "AV1",
        "Destins.croises.2026.MULTI.VFF.2160p.WEBRiP.DV.HDR.EAC3.5.1.AV1-THESYNDiCATE",
        "movie",
        1,
        "THESYNDiCATE AV1",
    ),
]


def sql_escape(value: str) -> str:
    return value.replace("'", "''")


def load_existing() -> list[tuple[str, str, str, int, str]]:
    if not SRC.exists():
        return []
    rows: list[tuple[str, str, str, int, str]] = []
    for line in SRC.read_text(encoding="utf-8").splitlines():
        m = LINE_TEST_RE.match(line.rstrip())
        if m:
            rows.append((m.group(1), m.group(2), m.group(3), int(m.group(4)), m.group(5)))
    return rows


def merge_rows(
    *sources: list[tuple[str, str, str, int, str]],
) -> list[tuple[str, str, str, int, str]]:
    # Clé PCD / Profilarr : (cf, title, type) UNIQUE — dernier should_match gagne
    by_key: dict[tuple[str, str, str], tuple[str, str, str, int, str]] = {}
    for source in sources:
        for cf, title, typ, sm, desc in source:
            by_key[(cf, title, typ)] = (cf, title, typ, sm, desc)
    out: list[tuple[str, str, str, int, str]] = list(by_key.values())
    out.sort(key=lambda x: (x[0], x[1]))
    return out


def write_sql(rows: list[tuple[str, str, str, int, str]]) -> None:
    lines = [
        "-- Profilarr v2 — tests custom formats (parser UI)",
        "-- French Profilarr Database — PCD v2 uniquement (ops/11)",
        f"-- {len(rows)} titres de release réels",
        "-- Regenerate: python3 scripts/generate_cf_tests_sql.py",
        "",
        "INSERT INTO custom_format_tests (custom_format_name, title, type, should_match, description)",
        "VALUES",
    ]
    vals = [
        f"    ('{sql_escape(cf)}', '{sql_escape(inp)}', '{typ}', {exp}, '{sql_escape(desc)}')"
        for cf, inp, typ, exp, desc in rows
    ]
    lines.append(",\n".join(vals) + ";")
    lines.append("")
    OUT.write_text("\n".join(lines), encoding="utf-8")


def main() -> int:
    rows = merge_rows(load_existing(), SCENE_EXTRAS)
    write_sql(rows)
    print(f"Wrote {OUT.relative_to(ROOT)} ({len(rows)} tests)")
    return 0


if __name__ == "__main__":
    sys.exit(main())

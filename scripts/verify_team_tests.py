#!/usr/bin/env python3
"""Chaque FR-Team-* doit avoir au moins un test parser positif (should_match=1)."""

from __future__ import annotations

import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
OPS03 = ROOT / "ops" / "03-custom-formats.sql"
OPS11 = ROOT / "ops" / "11-custom-format-tests.sql"

LINE_TEST_RE = re.compile(
    r"\s*\('([^']+)', '((?:[^']|'')*)', '(movie|series)', ([01]), '([^']*(?:''[^']*)*)'\),?"
)


def team_names_from_ops03() -> list[str]:
    return sorted(
        re.findall(
            r"INSERT INTO custom_formats \(name, description, include_in_rename\) "
            r"VALUES \('(FR-Team-[^']+)'",
            OPS03.read_text(encoding="utf-8"),
        )
    )


def positive_tests_by_cf() -> dict[str, int]:
    counts: dict[str, int] = {}
    for line in OPS11.read_text(encoding="utf-8").splitlines():
        m = LINE_TEST_RE.match(line.rstrip())
        if m and int(m.group(4)) == 1:
            counts[m.group(1)] = counts.get(m.group(1), 0) + 1
    return counts


def main() -> int:
    teams = team_names_from_ops03()
    positives = positive_tests_by_cf()
    errors: list[str] = []

    print("=== Tests équipes (FR-Team-*) ===")
    for team in teams:
        n = positives.get(team, 0)
        status = "OK" if n else "MANQUE"
        print(f"  {status:6}   {team} ({n} test positif)")
        if n == 0:
            errors.append(f"{team}: aucun test should_match=1 dans ops/11")

    print("\n=== Result ===")
    if errors:
        for e in errors:
            print(f"  ERROR: {e}")
        return 1
    print(f"  {len(teams)} équipes couvertes par au moins un test positif.")
    return 0


if __name__ == "__main__":
    sys.exit(main())

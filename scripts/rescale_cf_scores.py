#!/usr/bin/env python3
"""Rescale custom format scores in ops/06 for /50000 grid (factor 0.5)."""
from __future__ import annotations

import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
OPS06 = ROOT / "ops" / "06-quality-profiles.sql"
# Top release ~333k → ~50k ; langue 100k → 15k (hiérarchie conservée).
FACTOR = 0.15
UPGRADE_UNTIL = 50000


def scale_score(n: int) -> int:
    if n <= -99999:
        return n
    if n < 0:
        return int(round(n * FACTOR))
    if n == 0:
        return 0
    return max(1, int(round(n * FACTOR)))


def main() -> int:
    text = OPS06.read_text(encoding="utf-8")

    def repl_score(m: re.Match[str]) -> str:
        return f"{m.group(1)}{scale_score(int(m.group(2)))}{m.group(3)}"

    text, n_scores = re.subn(
        r"(SELECT '[^']+', '[^']+', 'all', )(-?\d+)(\s*\n)",
        repl_score,
        text,
    )

    text = re.sub(r", 999999, 1\)", f", {UPGRADE_UNTIL}, 1)", text)

    def repl_profile(m: re.Match[str]) -> str:
        mn = int(m.group(4))
        mn2 = scale_score(mn) if mn > 0 else mn
        return (
            f"INSERT INTO quality_profiles (name, description, upgrades_allowed, "
            f"minimum_custom_format_score, upgrade_until_score, upgrade_score_increment) "
            f"VALUES ('{m.group(1)}', '{m.group(2)}', {m.group(3)}, {mn2}, {UPGRADE_UNTIL}, 1);"
        )

    text, n_prof = re.subn(
        r"INSERT INTO quality_profiles \(name, description, upgrades_allowed, "
        r"minimum_custom_format_score, upgrade_until_score, upgrade_score_increment\) "
        r"VALUES \('([^']+)', '([^']*(?:''[^']*)*)', (\d), (\d+), \d+, 1\);",
        repl_profile,
        text,
    )

    header = (
        "-- Seuils profil : minimum 115/150/0 (×0.15) ; upgrade_until 50000 — grille CF /50000 (×0.15, 2026-05).\n"
    )
    text = re.sub(
        r"-- Seuils profil:.*\n",
        header,
        text,
        count=1,
    )

    OPS06.write_text(text, encoding="utf-8")
    pat = re.compile(r"SELECT '[^']+', '([^']+)', 'all', (-?\d+)")
    pos = [int(s) for _, s in pat.findall(text) if int(s) > 0]
    print(f"Scaled {n_scores} score lines, {n_prof} profile rows")
    print(f"max positive CF score: {max(pos)}")
    print(f"FR-MULTI-VF2: {pat.findall(text)[0] if pat.findall(text) else 'n/a'}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

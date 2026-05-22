#!/usr/bin/env python3
"""Compare les scores entre profils FR (écarts documentés vs oublis)."""

from __future__ import annotations

import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
OPS06 = ROOT / "ops" / "06-quality-profiles.sql"

# Écarts volontaires (ne pas alerter)
ALLOWED_DIFFS: dict[frozenset[str], set[str]] = {
    frozenset({"FR-Films-4K", "FR-Series-4K", "FR-Anime-4K"}): set(),  # comparés plus bas
}

# CF attendus identiques entre films 4K et séries 4K sauf :
FILMS_SERIES_4K_ONLY_SERIES = {"Season Pack"}
FILMS_SERIES_4K_ONLY_FILMS = {"x264 (2160p)", "Theatrical"}  # selon dépôt


def load_scores() -> dict[str, dict[str, int]]:
    text = OPS06.read_text(encoding="utf-8")
    by_profile: dict[str, dict[str, int]] = {}
    for m in re.finditer(
        r"SELECT '(FR-[^']+)', '([^']+)', 'all', (-?\d+)",
        text,
    ):
        pname, cf, score = m.group(1), m.group(2), int(m.group(3))
        by_profile.setdefault(pname, {})[cf] = score
    return by_profile


def diff(a: dict[str, int], b: dict[str, int], ignore: set[str]) -> tuple[set[str], set[str], set[tuple[str, int, int]]]:
    keys = (set(a) | set(b)) - ignore
    only_a = {k for k in keys if k not in b}
    only_b = {k for k in keys if k not in a}
    val_diff = {k for k in keys if k in a and k in b and a[k] != b[k]}
    details = [(k, a[k], b[k]) for k in sorted(val_diff)]
    return only_a, only_b, details


def main() -> int:
    scores = load_scores()
    warnings: list[str] = []

    print("=== Parité scores (référence) ===")

    pairs = [
        ("FR-Films-4K", "FR-Series-4K", FILMS_SERIES_4K_ONLY_SERIES | FILMS_SERIES_4K_ONLY_FILMS),
        ("FR-Films-1080p", "FR-Series-1080p", {"Season Pack"}),
        ("FR-Films-720p", "FR-Series-720p", {"Season Pack"}),
        ("FR-Anime-4K", "FR-Series-4K", {"Season Pack", "x264 (2160p)", "Theatrical"}),
    ]

    for left, right, ignore in pairs:
        if left not in scores or right not in scores:
            warnings.append(f"profil manquant: {left} ou {right}")
            continue
        only_l, only_r, val_diff = diff(scores[left], scores[right], ignore)
        if only_l or only_r or val_diff:
            print(f"\n  {left} vs {right}:")
            if only_l:
                print(f"    seulement {left}: {sorted(only_l)[:8]}")
            if only_r:
                print(f"    seulement {right}: {sorted(only_r)[:8]}")
            for k, va, vb in val_diff[:5]:
                print(f"    score différent: {k} {va} vs {vb}")
            if len(val_diff) > 5:
                print(f"    … +{len(val_diff) - 5} autres")
        else:
            print(f"  OK       {left} ≈ {right} (hors {sorted(ignore) or 'rien'})")

    print("\n=== Comptes par profil ===")
    for p in sorted(scores):
        print(f"  {len(scores[p]):3} scores  {p}")

    print("\n=== Result ===")
    if warnings:
        for w in warnings:
            print(f"  WARN: {w}")
    print("  Analyse terminée (écarts Season Pack / x264@2160p = normaux).")
    return 0


if __name__ == "__main__":
    sys.exit(main())

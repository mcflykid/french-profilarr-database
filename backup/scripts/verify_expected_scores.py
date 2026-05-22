#!/usr/bin/env python3
"""Vérifie la politique de scores FR (blocages Remux, AV1, etc.)."""

from __future__ import annotations

import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
OPS06 = ROOT / "ops" / "06-quality-profiles.sql"

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

# Tous les profils : pas de remux (demande projet)
BLOCK_999999 = ("Remux", "Full Disc", "AV1")
BLOCK_UPSCALE = ("Upscaled",)

# Profils 4K : x264@2160p via CF dédié — vérifier présence du score négatif si CF existe
KICK_4K = ("x264 (2160p)",)


def profile_scores(text: str, profile: str) -> dict[str, int]:
    scores: dict[str, int] = {}
    for m in re.finditer(
        r"SELECT '([^']+)', '([^']+)', 'all', (-?\d+)",
        text,
    ):
        if m.group(1) == profile:
            scores[m.group(2)] = int(m.group(3))
    return scores


def main() -> int:
    text = OPS06.read_text(encoding="utf-8")
    errors: list[str] = []

    print("=== Politique scores FR ===")
    for profile in ALL_PROFILES:
        scores = profile_scores(text, profile)
        for cf in BLOCK_999999:
            if scores.get(cf) != -999999:
                errors.append(f"{profile}: {cf} doit être -999999 (actuel {scores.get(cf, 'ABSENT')})")
        if not any(scores.get(c) == -999999 for c in BLOCK_UPSCALE):
            errors.append(f"{profile}: Upscaled doit être -999999")
        if profile.endswith("-4K") or profile == "FR-Anime-4K":
            for cf in KICK_4K:
                if cf in scores and scores[cf] != -999999:
                    errors.append(f"{profile}: {cf} devrait être -999999")
        status = "OK" if profile not in [e.split(":")[0] for e in errors] else "…"
        print(f"  {status:4}     {profile} ({len(scores)} scores)")

    print("\n=== Result ===")
    if errors:
        for e in errors:
            print(f"  ERROR: {e}")
        return 1
    print("  Politique Remux / blocages respectée sur les 10 profils.")
    return 0


if __name__ == "__main__":
    sys.exit(main())

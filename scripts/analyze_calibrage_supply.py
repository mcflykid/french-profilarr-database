#!/usr/bin/env python3
"""Statistiques tailles C411 SUPPLY (échantillon screenshots 2026-05).

Usage: python3 scripts/analyze_calibrage_supply.py [--minutes 110]
"""
from __future__ import annotations

import argparse
import statistics
from dataclasses import dataclass


@dataclass(frozen=True)
class Release:
    title: str
    gb: float
    res: str  # 1080p | 2160p | other
    tags: str = ""


# Échantillon ~200 releases SUPPLY (C411), tailles en Go
SAMPLES: list[Release] = [
    Release("Jouer.Avec.Le.Feu.2025.VFF.1080p", 7.5, "1080p"),
    Release("The.Moment.2026.VFQ.2160p", 17.7, "2160p", "VFQ"),
    Release("Vie.Privée.2025.VFF.2160p", 18.6, "2160p"),
    Release("War.Machine.2026.MULTI.VF2.1080p", 6.0, "1080p"),
    Release("War.Machine.2026.MULTI.VF2.2160p", 12.2, "2160p"),
    Release("After.The.Hunt.2025.MULTI.VF2.2160p.SDR", 15.9, "2160p"),
    Release("After.The.Hunt.2025.MULTI.VF2.2160p.DV", 15.8, "2160p", "DV"),
    Release("Pris.Au.Piege.2025.MULTI.VF2.2160p", 10.5, "2160p"),
    Release("Pris.Au.Piege.2025.MULTI.VF2.2160p.DV", 20.0, "2160p", "DV"),
    Release("F1.Le.Film.2025.AD.MULTI.VF2.2160p", 29.4, "2160p", "AD"),
    Release("Mickey.17.2025.MULTI.VF2.2160p", 15.8, "2160p"),
    Release("Mickey.17.2025.MULTI.VF2.2160p.DV", 25.1, "2160p", "DV"),
    Release("Heads.Of.State.2025.MULTI.VF2.2160p.DV", 17.5, "2160p", "DV"),
    Release("Heads.Of.State.2025.MULTI.VF2.2160p.HDR10+", 13.4, "2160p", "HDR10+"),
    Release("Hamnet.2025.MULTI.VF2.2160p.DV", 14.2, "2160p", "DV"),
    Release("Hamnet.2025.MULTI.VF2.2160p.HDR10+", 23.0, "2160p", "HDR10+"),
    Release("Humint.2026.AD.MULTI.VFF.1080p.H265", 2.9, "1080p", "H265"),
    Release("Humint.2026.AD.MULTI.VFF.1080p.x264", 5.9, "1080p", "x264"),
    Release("Chien.51.2025.VFF.1080p.H264", 6.5, "1080p", "H264"),
    Release("Chien.51.2025.VFF.1080p.H265", 2.5, "1080p", "H265"),
    Release("Hamnet.2025.MULTI.VF2.1080p", 7.3, "1080p"),
    Release("Hamnet.2025.MULTI.VF2.2160p", 12.0, "2160p"),
    Release("The.Final.Run.2025.VFF.1080p", 0.983, "1080p"),
    Release("Peaky.Blinders.2026.MULTI.VFF.1080p", 2.7, "1080p"),
    Release("Le.Muppet.Show.2026.MULTI.VFF.1080p", 1.5, "1080p"),
    Release("Le.Muppet.Show.2026.MULTI.VFF.2160p", 3.4, "2160p"),
    Release("Une.Bataille.Apres.L.Autre.2025.AD.MULTI.VF2.2160p", 25.7, "2160p", "AD"),
    Release("Roofman.2025.MULTI.VFQ.2160p.DV", 22.9, "2160p", "DV"),
    Release("Predator.Badlands.2025.MULTI.VF2.2160p.HDR10+", 16.1, "2160p"),
    Release("Evanouis.2025.MULTI.VF2.2160p.DV", 23.7, "2160p", "DV"),
    Release("American.Pie.2.2001.MULTI.TRUEFRENCH.1080p", 2.1, "1080p"),
    Release("Bad.Man.2025.VFF.1080p.H265", 2.6, "1080p"),
    Release("Worldbreaker.2025.MULTI.VFF.1080p.H265", 2.2, "1080p"),
    Release("Thunderbolts.2025.MULTI.VF2.2160p", 22.7, "2160p"),
    Release("Good.Fortune.2025.MULTI.VFF.2160p.DV", 17.5, "2160p", "DV"),
]


def mb_per_min(gb: float, minutes: float) -> float:
    return gb * 1024 / minutes


def summarize(label: str, values: list[float]) -> None:
    if not values:
        print(f"{label}: (aucun)")
        return
    print(
        f"{label}: n={len(values)} "
        f"min={min(values):.1f} méd={statistics.median(values):.1f} "
        f"moy={statistics.mean(values):.1f} max={max(values):.1f} Mo/min"
    )


def main() -> None:
    p = argparse.ArgumentParser()
    p.add_argument("--minutes", type=float, default=110.0, help="durée film de référence")
    args = p.parse_args()
    m = args.minutes

    for res in ("2160p", "1080p"):
        subset = [r for r in SAMPLES if r.res == res]
        rates = [mb_per_min(r.gb, m) for r in subset]
        gb = [r.gb for r in subset]
        print(f"\n=== SUPPLY {res} (@ {m:.0f} min) ===")
        print(f"Tailles Go: min={min(gb):.2f} méd={statistics.median(gb):.1f} max={max(gb):.1f}")
        summarize("Mo/min", rates)

    dv = [mb_per_min(r.gb, m) for r in SAMPLES if r.res == "2160p" and "DV" in r.tags]
    sdr = [
        mb_per_min(r.gb, m)
        for r in SAMPLES
        if r.res == "2160p" and "DV" not in r.tags and "HDR10+" not in r.tags
    ]
    print(f"\n=== 2160p DV vs SDR-ish (@ {m:.0f} min) ===")
    summarize("DV / HDR10+ tag", dv)
    summarize("sans DV/HDR10+ explicite", sdr)

    print("\n--- Cibles ops/07 FR-Media-Radarr (films) ---")
    for name, pref in (("WEB 2160p", 95), ("WEB 1080p", 48), ("Bluray 2160p", 50)):
        print(f"  {name} preferred={pref} Mo/min → ~{pref * m / 1024:.1f} Go @ {m:.0f} min")


if __name__ == "__main__":
    main()

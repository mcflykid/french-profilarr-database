#!/usr/bin/env python3
"""Rééquilibre ops/06 : langue = 1er tri (modéré), qualité FR = dominant."""
from __future__ import annotations

import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
OPS06 = ROOT / "ops" / "06-quality-profiles.sql"
UPGRADE_UNTIL = 60000

LANG = {
    "FR-MULTI-VF2": 8000,
    "FR-MULTI-VFF": 7000,
    "FR-VF2": 6000,
    "FR-MULTI-ambig": 5500,
    "FR-VFF": 5000,
    "FR-MULTI-VFQ": 4500,
    "FR-VFQ": 4000,
    "FR-VOSTFR": 1500,
}

TEAMS = {
    "FR-Team-QTZ": 5500,
    "FR-Team-AMEN": 5200,
    "FR-Team-BONBON": 5000,
    "FR-Team-TyHD": 4900,
    "FR-Team-THESYNDiCATE": 4500,
    "FR-Team-SUPPLY": 4800,
    "FR-Team-BOUC": 4300,
    "FR-Team-TFA": 4200,
    "FR-Team-FW": 4000,
    "FR-Team-Winks": 3600,
    "FR-Team-PopHD": 3500,
    "FR-Team-TOXIC": 3400,
    "FR-Team-ENIGMA": 3300,
    "FR-Team-Slay3R": 3200,
    "FR-Team-OZEF": 800,
    "FR-Team-HYPERION": 800,
    "FR-Tier-01": 800,
    "FR-Tier-02": 400,
}

BLOCKERS = {
    "FR-Blockers",
    "Remux",
    "Full Disc",
    "AV1",
    "Upscaled",
    "x264 (2160p)",
}

TECH_4K = {
    "Dolby Vision": 3500,
    "Dolby Vision (Without Fallback)": -50,
    "HDR10+": 2200,
    "HDR10": 1300,
    "HDR": 1300,
    "Atmos": 2500,
    "TrueHD": 1800,
    "DTS-X": 2500,
    "DTS-HD MA": 1400,
    "DTS-HD HRA": 900,
    "DTS-ES": 750,
    "DTS": 450,
    "Dolby Digital +": 500,
    "Dolby Digital": 120,
    "AAC": 60,
    "FLAC": 600,
    "PCM": 750,
    "Opus": 120,
    "x265": 1200,
    "h265": 1000,
    "VP9": -40,
    "VVC": 80,
    "Xvid": -100,
    "UHD Bluray": 800,
    "IMAX": 1000,
    "IMAX Enhanced": 1300,
    "Theatrical": 120,
    "3D": -100,
    "FR-4KLight": 2000,
    "FR-Hybrid": 1200,
    "FR-Streamer-Premium": 400,
    "FR-Streamer-Standard": 250,
    "FR-HDLight": 300,
    "FR-Repack": 150,
    "FR-Repack-2": 220,
    "FR-Repack-3": 330,
    "Season Pack": 150,
}

TECH_1080 = {
    "Dolby Vision": 1200,
    "Dolby Vision (Without Fallback)": -30,
    "HDR10+": 1000,
    "HDR10": 600,
    "HDR": 400,
    "Atmos": 800,
    "TrueHD": 600,
    "DTS-X": 800,
    "DTS-HD MA": 500,
    "DTS-HD HRA": 350,
    "DTS-ES": 280,
    "DTS": 180,
    "Dolby Digital +": 350,
    "Dolby Digital": 80,
    "AAC": 50,
    "FLAC": 350,
    "PCM": 400,
    "Opus": 90,
    "x265": 1000,
    "h265": 850,
    "VP9": -25,
    "VVC": 60,
    "Xvid": -80,
    "UHD Bluray": 0,
    "IMAX": 700,
    "IMAX Enhanced": 900,
    "Theatrical": 100,
    "3D": -50,
    "FR-4KLight": 0,
    "FR-Hybrid": 500,
    "FR-Streamer-Premium": 300,
    "FR-Streamer-Standard": 180,
    "FR-HDLight": 250,
    "FR-Repack": 120,
    "FR-Repack-2": 180,
    "FR-Repack-3": 270,
    "Season Pack": 120,
}

TECH_720 = {
    **{k: max(1, int(v * 0.65)) if v > 0 else v for k, v in TECH_1080.items()},
    "FR-HDLight": 200,
    "x265": 700,
    "h265": 600,
}


def profile_tier(profile: str) -> str:
    if profile.endswith("-4K"):
        return "4k"
    if profile.endswith("-720p"):
        return "720"
    return "1080"


def score_for(profile: str, cf: str) -> int:
    if cf in BLOCKERS:
        return -999999
    if cf in LANG:
        return LANG[cf]
    if cf in TEAMS:
        return TEAMS[cf]
    tier = profile_tier(profile)
    tech = {"4k": TECH_4K, "720": TECH_720, "1080": TECH_1080}[tier]
    if cf in tech:
        return tech[cf]
    return 0


def main() -> int:
    text = OPS06.read_text(encoding="utf-8")

    def repl(m: re.Match[str]) -> str:
        prof, cf = m.group(1), m.group(2)
        return f"SELECT '{prof}', '{cf}', 'all', {score_for(prof, cf)}"

    text = re.sub(
        r"SELECT '([^']+)', '([^']+)', 'all', -?\d+",
        repl,
        text,
    )

    text = re.sub(r", 100000, 1\)", f", {UPGRADE_UNTIL}, 1)", text)
    text = re.sub(
        r"(minimum_custom_format_score, upgrade_until_score, upgrade_score_increment\) VALUES \('FR-Films-1080p',[^,]+, \d+, )(\d+)(, 1\);)",
        r"\g<1>400\2",
        text,
    )
    # Fix minimums explicitly
    text = re.sub(
        r"(VALUES \('FR-Films-1080p', '[^']+', 1, )\d+(, 60000, 1\);)",
        r"\g<1>400\2",
        text,
    )
    text = re.sub(
        r"(VALUES \('FR-Films-4K', '[^']+', 1, )\d+(, 60000, 1\);)",
        r"\g<1>500\2",
        text,
    )
    text = re.sub(
        r"(VALUES \('FR-Anime-4K', '[^']+', 1, )\d+(, 60000, 1\);)",
        r"\g<1>500\2",
        text,
    )
    text = re.sub(
        r"(VALUES \('FR-Series-4K', '[^']+', 1, )\d+(, 60000, 1\);)",
        r"\g<1>500\2",
        text,
    )

    header = (
        "-- Seuils : minimum 400/500 ; upgrade_until 60000. "
        "Scores : langue 1er tri (8k max), qualité/équipe/HDR dominant (2026-05).\n"
    )
    text = re.sub(r"-- Seuils profil:.*\n", header, text, count=1)

    OPS06.write_text(text, encoding="utf-8")

    pat = re.compile(r"SELECT '[^']+', '([^']+)', 'all', (-?\d+)")
    pos = [int(s) for _, s in pat.findall(text) if int(s) > 0]
    print(f"max CF score single: {max(pos)}")
    print(f"upgrade_until: {UPGRADE_UNTIL}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

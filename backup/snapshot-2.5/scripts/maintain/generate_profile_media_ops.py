#!/usr/bin/env python3
"""Generate ops/09-profile-media-bundles.sql — one media bundle per FR-* quality profile."""

from __future__ import annotations

from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
OUT = ROOT / "ops" / "09-profile-media-bundles.sql"

# Modèle cloné depuis ops/07 (ne pas assigner manuellement dans l’UI)
MEDIA_BASE = "FR-Media-Base"

RADARR_FILMS = ("FR-Films-4K", "FR-Films-1080p", "FR-Films-720p", "FR-Films-Any")
SONARR_SHOWS = (
    "FR-Series-4K",
    "FR-Series-1080p",
    "FR-Series-720p",
    "FR-Anime-4K",
    "FR-Anime-1080p",
    "FR-Anime-720p",
)


def tier_from_profile(name: str) -> str:
    if "4K" in name:
        return "4k"
    if "1080p" in name:
        return "1080p"
    if "720p" in name:
        return "720p"
    return "any"


RADARR_PREF: dict[str, dict[str, int]] = {
    "4k": {
        "Bluray-2160p": 55,
        "WEBDL-2160p": 60,
        "WEBRip-2160p": 60,
        "HDTV-2160p": 55,
    },
    "1080p": {
        "WEBDL-1080p": 400,
        "WEBRip-1080p": 400,
        "Bluray-1080p": 900,
        "HDTV-1080p": 400,
    },
    "720p": {
        "WEBDL-720p": 300,
        "WEBRip-720p": 300,
        "Bluray-720p": 450,
        "HDTV-720p": 200,
    },
    "any": {},
}

SONARR_PREF: dict[str, dict[str, int]] = {
    "4k": {
        "Bluray-2160p": 55,
        "WEBDL-2160p": 60,
        "WEBRip-2160p": 60,
        "HDTV-2160p": 55,
    },
    "1080p": {
        "WEBDL-1080p": 350,
        "WEBRip-1080p": 350,
        "Bluray-1080p": 800,
        "HDTV-1080p": 350,
    },
    "720p": {
        "WEBDL-720p": 300,
        "WEBRip-720p": 300,
        "Bluray-720p": 450,
        "HDTV-720p": 200,
    },
    "any": {},
}


def preferred_case(tier: str, pref_map: dict[str, dict[str, int]]) -> str:
    overrides = pref_map.get(tier) or {}
    if not overrides:
        return "preferred_size"
    whens = " ".join(f"WHEN quality_name = '{q}' THEN {v}" for q, v in sorted(overrides.items()))
    return f"CASE {whens} ELSE preferred_size END"


def radarr_bundle(profile: str) -> list[str]:
    tier = tier_from_profile(profile)
    pref = preferred_case(tier, RADARR_PREF)
    return [
        f"-- {profile} (Radarr — profil qualité = ce nom dans Media Management)",
        "INSERT INTO radarr_media_settings (name, propers_repacks, enable_media_info)",
        f"VALUES ('{profile}', 'doNotPrefer', 1);",
        "",
        "INSERT INTO radarr_naming (name, rename, movie_format, movie_folder_format, "
        "replace_illegal_characters, colon_replacement_format)",
        f"SELECT '{profile}', rename, movie_format, movie_folder_format, "
        "replace_illegal_characters, colon_replacement_format",
        f"FROM radarr_naming WHERE name = '{MEDIA_BASE}';",
        "",
        "INSERT INTO radarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)",
        f"SELECT '{profile}', quality_name, min_size, max_size, {pref}",
        f"FROM radarr_quality_definitions WHERE name = '{MEDIA_BASE}';",
        "",
    ]


def sonarr_bundle(profile: str) -> list[str]:
    tier = tier_from_profile(profile)
    pref = preferred_case(tier, SONARR_PREF)
    return [
        f"-- {profile} (Sonarr — profil qualité = ce nom dans Media Management)",
        "INSERT INTO sonarr_media_settings (name, propers_repacks, enable_media_info)",
        f"VALUES ('{profile}', 'doNotPrefer', 1);",
        "",
        "INSERT INTO sonarr_naming (name, rename, standard_episode_format, daily_episode_format, "
        "anime_episode_format, series_folder_format, season_folder_format, "
        "replace_illegal_characters, colon_replacement_format, custom_colon_replacement_format, "
        "multi_episode_style)",
        f"SELECT '{profile}', rename, standard_episode_format, daily_episode_format, "
        "anime_episode_format, series_folder_format, season_folder_format, "
        "replace_illegal_characters, colon_replacement_format, custom_colon_replacement_format, "
        "multi_episode_style",
        f"FROM sonarr_naming WHERE name = '{MEDIA_BASE}';",
        "",
        "INSERT INTO sonarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)",
        f"SELECT '{profile}', quality_name, min_size, max_size, {pref}",
        f"FROM sonarr_quality_definitions WHERE name = '{MEDIA_BASE}';",
        "",
    ]


def main() -> int:
    lines = [
        "-- Profilarr v2 — bundles media (nom = profil qualité FR-*)",
        "-- Convention : FR-Films-* / FR-Series-* / FR-Anime-* | FR-Delay-* | FR-Media-Base",
        "-- Regenerate: python3 scripts/generate_profile_media_ops.py",
        "",
        f"UPDATE radarr_media_settings SET propers_repacks = 'doNotPrefer' WHERE name = '{MEDIA_BASE}';",
        f"UPDATE sonarr_media_settings SET propers_repacks = 'doNotPrefer' WHERE name = '{MEDIA_BASE}';",
        "",
        "-- Delay Sonarr (Radarr : FR-Delay-Radarr dans ops/07)",
        "INSERT INTO delay_profiles (",
        "    name, preferred_protocol, usenet_delay, torrent_delay,",
        "    bypass_if_highest_quality, bypass_if_above_custom_format_score, minimum_custom_format_score",
        ") VALUES ('FR-Delay-Sonarr', 'only_torrent', NULL, 0, 1, 0, NULL);",
        "",
    ]
    for profile in RADARR_FILMS:
        lines.extend(radarr_bundle(profile))
    for profile in SONARR_SHOWS:
        lines.extend(sonarr_bundle(profile))

    OUT.write_text("\n".join(lines), encoding="utf-8")
    print(f"Wrote {OUT.relative_to(ROOT)}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

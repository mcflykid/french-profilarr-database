-- french-profilarr-database — ops/07
-- Media instance : FR-Media-Radarr (films) / FR-Media-Sonarr (séries) / FR-Media-Anime-Sonarr (animé).
-- Unité Radarr/Sonarr : Mo par minute × durée (film ou épisode). Calibrage scène FR (README).
-- Profilarr v2 : les 3 menus Media Management de l'instance pointent vers UN preset par type de contenu.

INSERT INTO radarr_media_settings (name, propers_repacks, enable_media_info)
VALUES ('FR-Media-Radarr', 'doNotPrefer', 1);

INSERT INTO sonarr_media_settings (name, propers_repacks, enable_media_info)
VALUES ('FR-Media-Sonarr', 'doNotPrefer', 1);

INSERT INTO sonarr_media_settings (name, propers_repacks, enable_media_info)
VALUES ('FR-Media-Anime-Sonarr', 'doNotPrefer', 1);

INSERT INTO delay_profiles (
    name, preferred_protocol, usenet_delay, torrent_delay,
    bypass_if_highest_quality, bypass_if_above_custom_format_score, minimum_custom_format_score
) VALUES (
    'FR-Delay-Radarr', 'only_torrent', NULL, 0, 1, 0, NULL
);

-- =============================================================================
-- FR-Media-Radarr — films (~90–150 min). Cibles : Winks ~4–5,5 Go, Slay3R WEB ~4–5 Go,
-- 4KLight ~2,5–8 Go, gros WEB 4K ~15–23 Go (max 2000 Mo/min).
-- =============================================================================

INSERT INTO radarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Radarr', q.name, 0, 2000, 1990
FROM qualities q WHERE q.name = 'BR-DISK';
INSERT INTO radarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Radarr', q.name, 12.5, 2000, 42
FROM qualities q WHERE q.name = 'Bluray-1080p';
INSERT INTO radarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Radarr', q.name, 17, 2000, 55
FROM qualities q WHERE q.name = 'Bluray-2160p';
INSERT INTO radarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Radarr', q.name, 0, 2000, 1990
FROM qualities q WHERE q.name = 'Bluray-480p';
INSERT INTO radarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Radarr', q.name, 0, 2000, 1990
FROM qualities q WHERE q.name = 'Bluray-576p';
INSERT INTO radarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Radarr', q.name, 12.5, 2000, 35
FROM qualities q WHERE q.name = 'Bluray-720p';
INSERT INTO radarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Radarr', q.name, 0, 2000, 1990
FROM qualities q WHERE q.name = 'CAM';
INSERT INTO radarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Radarr', q.name, 0, 2000, 1990
FROM qualities q WHERE q.name = 'DVD';
INSERT INTO radarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Radarr', q.name, 0, 2000, 1990
FROM qualities q WHERE q.name = 'DVD-R';
INSERT INTO radarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Radarr', q.name, 0, 2000, 1990
FROM qualities q WHERE q.name = 'DVDSCR';
INSERT INTO radarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Radarr', q.name, 0, 2000, 1990
FROM qualities q WHERE q.name = 'HDTV-1080p';
INSERT INTO radarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Radarr', q.name, 0, 2000, 1990
FROM qualities q WHERE q.name = 'HDTV-2160p';
INSERT INTO radarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Radarr', q.name, 0, 2000, 1990
FROM qualities q WHERE q.name = 'HDTV-720p';
INSERT INTO radarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Radarr', q.name, 0, 2000, 1990
FROM qualities q WHERE q.name = 'REGIONAL';
INSERT INTO radarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Radarr', q.name, 0, 2000, 1990
FROM qualities q WHERE q.name = 'Raw-HD';
INSERT INTO radarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Radarr', q.name, 0, 2000, 2000
FROM qualities q WHERE q.name = 'Remux-1080p';
INSERT INTO radarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Radarr', q.name, 0, 2000, 2000
FROM qualities q WHERE q.name = 'Remux-2160p';
INSERT INTO radarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Radarr', q.name, 0, 2000, 1990
FROM qualities q WHERE q.name = 'SDTV';
INSERT INTO radarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Radarr', q.name, 0, 2000, 1990
FROM qualities q WHERE q.name = 'TELECINE';
INSERT INTO radarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Radarr', q.name, 0, 2000, 1990
FROM qualities q WHERE q.name = 'TELESYNC';
INSERT INTO radarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Radarr', q.name, 0, 2000, 1990
FROM qualities q WHERE q.name = 'Unknown';
INSERT INTO radarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Radarr', q.name, 12.5, 2000, 42
FROM qualities q WHERE q.name = 'WEBDL-1080p';
INSERT INTO radarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Radarr', q.name, 34.5, 2000, 70
FROM qualities q WHERE q.name = 'WEBDL-2160p';
INSERT INTO radarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Radarr', q.name, 0, 2000, 1990
FROM qualities q WHERE q.name = 'WEBDL-480p';
INSERT INTO radarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Radarr', q.name, 12.5, 1000, 35
FROM qualities q WHERE q.name = 'WEBDL-720p';
INSERT INTO radarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Radarr', q.name, 12.5, 2000, 42
FROM qualities q WHERE q.name = 'WEBRip-1080p';
INSERT INTO radarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Radarr', q.name, 34.5, 2000, 70
FROM qualities q WHERE q.name = 'WEBRip-2160p';
INSERT INTO radarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Radarr', q.name, 0, 2000, 1990
FROM qualities q WHERE q.name = 'WEBRip-480p';
INSERT INTO radarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Radarr', q.name, 12.5, 1000, 35
FROM qualities q WHERE q.name = 'WEBRip-720p';
INSERT INTO radarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Radarr', q.name, 0, 2000, 1990
FROM qualities q WHERE q.name = 'WORKPRINT';

-- =============================================================================
-- FR-Media-Sonarr — séries (~40–50 min/ép.). Cibles : Slay3R WEB ~2,4–3 Go/ép.,
-- Bluray série ~3–4 Go/ép. Instance Sonarr « séries live-action ».
-- =============================================================================

INSERT INTO sonarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Sonarr', q.name, 17.5, 1000, 55
FROM qualities q WHERE q.name = 'Bluray-1080p';
INSERT INTO sonarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Sonarr', q.name, 0, 1000, 1000
FROM qualities q WHERE q.name = 'Remux-1080p';
INSERT INTO sonarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Sonarr', q.name, 17, 1000, 45
FROM qualities q WHERE q.name = 'Bluray-2160p';
INSERT INTO sonarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Sonarr', q.name, 0, 1000, 1000
FROM qualities q WHERE q.name = 'Remux-2160p';
INSERT INTO sonarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Sonarr', q.name, 0, 1000, 990
FROM qualities q WHERE q.name = 'Bluray-480p';
INSERT INTO sonarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Sonarr', q.name, 0, 1000, 990
FROM qualities q WHERE q.name = 'Bluray-576p';
INSERT INTO sonarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Sonarr', q.name, 17.5, 1000, 45
FROM qualities q WHERE q.name = 'Bluray-720p';
INSERT INTO sonarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Sonarr', q.name, 0, 1000, 990
FROM qualities q WHERE q.name = 'DVD';
INSERT INTO sonarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Sonarr', q.name, 12.5, 1000, 50
FROM qualities q WHERE q.name = 'HDTV-1080p';
INSERT INTO sonarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Sonarr', q.name, 0, 1000, 990
FROM qualities q WHERE q.name = 'HDTV-2160p';
INSERT INTO sonarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Sonarr', q.name, 12.5, 500, 35
FROM qualities q WHERE q.name = 'HDTV-720p';
INSERT INTO sonarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Sonarr', q.name, 0, 1000, 990
FROM qualities q WHERE q.name = 'Raw-HD';
INSERT INTO sonarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Sonarr', q.name, 0, 1000, 990
FROM qualities q WHERE q.name = 'SDTV';
INSERT INTO sonarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Sonarr', q.name, 0, 1000, 990
FROM qualities q WHERE q.name = 'Unknown';
INSERT INTO sonarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Sonarr', q.name, 12.5, 1000, 60
FROM qualities q WHERE q.name = 'WEBDL-1080p';
INSERT INTO sonarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Sonarr', q.name, 34.5, 1000, 55
FROM qualities q WHERE q.name = 'WEBDL-2160p';
INSERT INTO sonarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Sonarr', q.name, 0, 1000, 990
FROM qualities q WHERE q.name = 'WEBDL-480p';
INSERT INTO sonarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Sonarr', q.name, 12.5, 500, 40
FROM qualities q WHERE q.name = 'WEBDL-720p';
INSERT INTO sonarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Sonarr', q.name, 12.5, 1000, 60
FROM qualities q WHERE q.name = 'WEBRip-1080p';
INSERT INTO sonarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Sonarr', q.name, 34.5, 1000, 55
FROM qualities q WHERE q.name = 'WEBRip-2160p';
INSERT INTO sonarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Sonarr', q.name, 0, 1000, 990
FROM qualities q WHERE q.name = 'WEBRip-480p';
INSERT INTO sonarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Sonarr', q.name, 12.5, 500, 40
FROM qualities q WHERE q.name = 'WEBRip-720p';

-- =============================================================================
-- FR-Media-Anime-Sonarr — animé (~24 min/ép.). Cibles : épisodes compacts ~0,5–1,5 Go,
-- WEB 1080p ~1–2 Go. Choisir ce preset sur l'instance Sonarr dédiée à l'animé (Profilarr).
-- =============================================================================

INSERT INTO sonarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Anime-Sonarr', q.name, 5, 1000, 38
FROM qualities q WHERE q.name = 'Bluray-1080p';
INSERT INTO sonarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Anime-Sonarr', q.name, 0, 1000, 1000
FROM qualities q WHERE q.name = 'Remux-1080p';
INSERT INTO sonarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Anime-Sonarr', q.name, 5, 1000, 40
FROM qualities q WHERE q.name = 'Bluray-2160p';
INSERT INTO sonarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Anime-Sonarr', q.name, 0, 1000, 1000
FROM qualities q WHERE q.name = 'Remux-2160p';
INSERT INTO sonarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Anime-Sonarr', q.name, 0, 1000, 990
FROM qualities q WHERE q.name = 'Bluray-480p';
INSERT INTO sonarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Anime-Sonarr', q.name, 0, 1000, 990
FROM qualities q WHERE q.name = 'Bluray-576p';
INSERT INTO sonarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Anime-Sonarr', q.name, 5, 500, 28
FROM qualities q WHERE q.name = 'Bluray-720p';
INSERT INTO sonarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Anime-Sonarr', q.name, 0, 1000, 990
FROM qualities q WHERE q.name = 'DVD';
INSERT INTO sonarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Anime-Sonarr', q.name, 5, 1000, 35
FROM qualities q WHERE q.name = 'HDTV-1080p';
INSERT INTO sonarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Anime-Sonarr', q.name, 0, 1000, 990
FROM qualities q WHERE q.name = 'HDTV-2160p';
INSERT INTO sonarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Anime-Sonarr', q.name, 5, 500, 25
FROM qualities q WHERE q.name = 'HDTV-720p';
INSERT INTO sonarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Anime-Sonarr', q.name, 0, 1000, 990
FROM qualities q WHERE q.name = 'Raw-HD';
INSERT INTO sonarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Anime-Sonarr', q.name, 0, 1000, 990
FROM qualities q WHERE q.name = 'SDTV';
INSERT INTO sonarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Anime-Sonarr', q.name, 0, 1000, 990
FROM qualities q WHERE q.name = 'Unknown';
INSERT INTO sonarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Anime-Sonarr', q.name, 5, 1000, 42
FROM qualities q WHERE q.name = 'WEBDL-1080p';
INSERT INTO sonarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Anime-Sonarr', q.name, 17, 1000, 50
FROM qualities q WHERE q.name = 'WEBDL-2160p';
INSERT INTO sonarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Anime-Sonarr', q.name, 0, 1000, 990
FROM qualities q WHERE q.name = 'WEBDL-480p';
INSERT INTO sonarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Anime-Sonarr', q.name, 5, 500, 30
FROM qualities q WHERE q.name = 'WEBDL-720p';
INSERT INTO sonarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Anime-Sonarr', q.name, 5, 1000, 42
FROM qualities q WHERE q.name = 'WEBRip-1080p';
INSERT INTO sonarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Anime-Sonarr', q.name, 17, 1000, 50
FROM qualities q WHERE q.name = 'WEBRip-2160p';
INSERT INTO sonarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Anime-Sonarr', q.name, 0, 1000, 990
FROM qualities q WHERE q.name = 'WEBRip-480p';
INSERT INTO sonarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Anime-Sonarr', q.name, 5, 500, 30
FROM qualities q WHERE q.name = 'WEBRip-720p';

INSERT INTO radarr_naming (name, rename, movie_format, movie_folder_format, replace_illegal_characters, colon_replacement_format) VALUES ('FR-Media-Radarr', 0, '{Movie CleanTitle} ({Release Year}) {tmdb-{TmdbId}} {edition-{Edition Tags}} [{Custom Formats}] [{Quality Full}] [{MediaInfo 3D}] [{MediaInfo VideoDynamicRangeType}] [{MediaInfo AudioCodec} {MediaInfo AudioChannels}] [{MediaInfo VideoCodec}] {-Release Group}', '{Movie CleanTitle} ({Release Year}) {tmdb-{TmdbId}}', 0, 'smart');
INSERT INTO sonarr_naming (name, rename, standard_episode_format, daily_episode_format, anime_episode_format, series_folder_format, season_folder_format, replace_illegal_characters, colon_replacement_format, custom_colon_replacement_format, multi_episode_style) VALUES ('FR-Media-Sonarr', 0, '{Series TitleYear} - S{season:00}E{episode:00} - {Episode CleanTitle} [{Custom Formats}] [{Quality Full}] [{MediaInfo VideoDynamicRangeType}] [{MediaInfo AudioCodec} {MediaInfo AudioChannels}] [{MediaInfo VideoCodec}] {-Release Group}', '{Series TitleYear} - {Air-Date} - {Episode CleanTitle} [{Custom Formats}] [{Quality Full}] [{MediaInfo VideoDynamicRangeType}] [{MediaInfo AudioCodec} {MediaInfo AudioChannels}] [{MediaInfo VideoCodec}] {-Release Group}', '{Series TitleYear} - S{season:00}E{episode:00} - {absolute:000} - {Episode CleanTitle} [{Custom Formats}] [{Quality Full}] [{MediaInfo VideoDynamicRangeType}] [{MediaInfo VideoBitDepth}bit] [{MediaInfo VideoCodec}] [{MediaInfo AudioCodec} {MediaInfo AudioChannels}] [{MediaInfo AudioLanguages}] {-Release Group}', '{Series TitleYear} {tvdb-{TvdbId}}', 'Season {season:00}', 0, 'smart', NULL, 5);
INSERT INTO sonarr_naming (name, rename, standard_episode_format, daily_episode_format, anime_episode_format, series_folder_format, season_folder_format, replace_illegal_characters, colon_replacement_format, custom_colon_replacement_format, multi_episode_style) VALUES ('FR-Media-Anime-Sonarr', 0, '{Series TitleYear} - S{season:00}E{episode:00} - {Episode CleanTitle} [{Custom Formats}] [{Quality Full}] [{MediaInfo VideoDynamicRangeType}] [{MediaInfo AudioCodec} {MediaInfo AudioChannels}] [{MediaInfo VideoCodec}] {-Release Group}', '{Series TitleYear} - {Air-Date} - {Episode CleanTitle} [{Custom Formats}] [{Quality Full}] [{MediaInfo VideoDynamicRangeType}] [{MediaInfo AudioCodec} {MediaInfo AudioChannels}] [{MediaInfo VideoCodec}] {-Release Group}', '{Series TitleYear} - S{season:00}E{episode:00} - {absolute:000} - {Episode CleanTitle} [{Custom Formats}] [{Quality Full}] [{MediaInfo VideoDynamicRangeType}] [{MediaInfo VideoBitDepth}bit] [{MediaInfo VideoCodec}] [{MediaInfo AudioCodec} {MediaInfo AudioChannels}] [{MediaInfo AudioLanguages}] {-Release Group}', '{Series TitleYear} {tvdb-{TvdbId}}', 'Season {season:00}', 0, 'smart', NULL, 5);

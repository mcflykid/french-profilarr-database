-- French Profilarr Database — PCD v2 (Profilarr >= 2.0.0)

-- Media management (FR defaults)
-- Modèle de base FR-Media-Base (cloné vers chaque profil FR-* dans ops/09)
-- Delay Radarr : FR-Delay-Radarr | Sonarr : FR-Delay-Sonarr (ops/09)

INSERT INTO radarr_media_settings (name, propers_repacks, enable_media_info)
VALUES ('FR-Media-Base', 'doNotPrefer', 1);

INSERT INTO sonarr_media_settings (name, propers_repacks, enable_media_info)
VALUES ('FR-Media-Base', 'doNotPrefer', 1);

-- Tracker FR = surtout torrent ; délai 0, bypass si déjà meilleure qualité
INSERT INTO delay_profiles (
    name, preferred_protocol, usenet_delay, torrent_delay,
    bypass_if_highest_quality, bypass_if_above_custom_format_score, minimum_custom_format_score
) VALUES (
    'FR-Delay-Radarr', 'only_torrent', NULL, 0, 1, 0, NULL
);

INSERT INTO radarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Base', q.name, 0, 2000, 1990
FROM qualities q WHERE q.name = 'BR-DISK';
INSERT INTO radarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Base', q.name, 1200, 2000, 1800
FROM qualities q WHERE q.name = 'Bluray-1080p';
INSERT INTO radarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Base', q.name, 0, 2000, 55
FROM qualities q WHERE q.name = 'Bluray-2160p';
INSERT INTO radarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Base', q.name, 0, 2000, 1990
FROM qualities q WHERE q.name = 'Bluray-480p';
INSERT INTO radarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Base', q.name, 0, 2000, 1990
FROM qualities q WHERE q.name = 'Bluray-576p';
INSERT INTO radarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Base', q.name, 800, 1000, 900
FROM qualities q WHERE q.name = 'Bluray-720p';
INSERT INTO radarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Base', q.name, 0, 2000, 1990
FROM qualities q WHERE q.name = 'CAM';
INSERT INTO radarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Base', q.name, 0, 2000, 1990
FROM qualities q WHERE q.name = 'DVD';
INSERT INTO radarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Base', q.name, 0, 2000, 1990
FROM qualities q WHERE q.name = 'DVD-R';
INSERT INTO radarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Base', q.name, 0, 2000, 1990
FROM qualities q WHERE q.name = 'DVDSCR';
INSERT INTO radarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Base', q.name, 0, 2000, 1990
FROM qualities q WHERE q.name = 'HDTV-1080p';
INSERT INTO radarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Base', q.name, 0, 2000, 1990
FROM qualities q WHERE q.name = 'HDTV-2160p';
INSERT INTO radarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Base', q.name, 0, 2000, 1990
FROM qualities q WHERE q.name = 'HDTV-720p';
INSERT INTO radarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Base', q.name, 0, 2000, 1990
FROM qualities q WHERE q.name = 'REGIONAL';
INSERT INTO radarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Base', q.name, 0, 2000, 1990
FROM qualities q WHERE q.name = 'Raw-HD';
INSERT INTO radarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Base', q.name, 0, 2000, 2000
FROM qualities q WHERE q.name = 'Remux-1080p';
INSERT INTO radarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Base', q.name, 0, 2000, 2000
FROM qualities q WHERE q.name = 'Remux-2160p';
INSERT INTO radarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Base', q.name, 0, 2000, 1990
FROM qualities q WHERE q.name = 'SDTV';
INSERT INTO radarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Base', q.name, 0, 2000, 1990
FROM qualities q WHERE q.name = 'TELECINE';
INSERT INTO radarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Base', q.name, 0, 2000, 1990
FROM qualities q WHERE q.name = 'TELESYNC';
INSERT INTO radarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Base', q.name, 0, 2000, 1990
FROM qualities q WHERE q.name = 'Unknown';
INSERT INTO radarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Base', q.name, 0, 2000, 1500
FROM qualities q WHERE q.name = 'WEBDL-1080p';
INSERT INTO radarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Base', q.name, 0, 2000, 60
FROM qualities q WHERE q.name = 'WEBDL-2160p';
INSERT INTO radarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Base', q.name, 0, 2000, 1990
FROM qualities q WHERE q.name = 'WEBDL-480p';
INSERT INTO radarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Base', q.name, 0, 1000, 600
FROM qualities q WHERE q.name = 'WEBDL-720p';
INSERT INTO radarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Base', q.name, 0, 2000, 1500
FROM qualities q WHERE q.name = 'WEBRip-1080p';
INSERT INTO radarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Base', q.name, 0, 2000, 60
FROM qualities q WHERE q.name = 'WEBRip-2160p';
INSERT INTO radarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Base', q.name, 0, 2000, 1990
FROM qualities q WHERE q.name = 'WEBRip-480p';
INSERT INTO radarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Base', q.name, 0, 1000, 600
FROM qualities q WHERE q.name = 'WEBRip-720p';
INSERT INTO radarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Base', q.name, 0, 2000, 1990
FROM qualities q WHERE q.name = 'WORKPRINT';
INSERT INTO sonarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Base', q.name, 600, 1000, 800
FROM qualities q WHERE q.name = 'Bluray-1080p';
INSERT INTO sonarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Base', q.name, 0, 1000, 1000
FROM qualities q WHERE q.name = 'Remux-1080p';
INSERT INTO sonarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Base', q.name, 0, 1000, 55
FROM qualities q WHERE q.name = 'Bluray-2160p';
INSERT INTO sonarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Base', q.name, 0, 1000, 1000
FROM qualities q WHERE q.name = 'Remux-2160p';
INSERT INTO sonarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Base', q.name, 0, 1000, 990
FROM qualities q WHERE q.name = 'Bluray-480p';
INSERT INTO sonarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Base', q.name, 0, 1000, 990
FROM qualities q WHERE q.name = 'Bluray-576p';
INSERT INTO sonarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Base', q.name, 400, 500, 450
FROM qualities q WHERE q.name = 'Bluray-720p';
INSERT INTO sonarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Base', q.name, 0, 1000, 990
FROM qualities q WHERE q.name = 'DVD';
INSERT INTO sonarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Base', q.name, 0, 1000, 400
FROM qualities q WHERE q.name = 'HDTV-1080p';
INSERT INTO sonarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Base', q.name, 0, 1000, 990
FROM qualities q WHERE q.name = 'HDTV-2160p';
INSERT INTO sonarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Base', q.name, 0, 500, 200
FROM qualities q WHERE q.name = 'HDTV-720p';
INSERT INTO sonarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Base', q.name, 0, 1000, 990
FROM qualities q WHERE q.name = 'Raw-HD';
INSERT INTO sonarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Base', q.name, 0, 1000, 990
FROM qualities q WHERE q.name = 'SDTV';
INSERT INTO sonarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Base', q.name, 0, 1000, 990
FROM qualities q WHERE q.name = 'Unknown';
INSERT INTO sonarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Base', q.name, 0, 1000, 350
FROM qualities q WHERE q.name = 'WEBDL-1080p';
INSERT INTO sonarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Base', q.name, 0, 1000, 60
FROM qualities q WHERE q.name = 'WEBDL-2160p';
INSERT INTO sonarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Base', q.name, 0, 1000, 990
FROM qualities q WHERE q.name = 'WEBDL-480p';
INSERT INTO sonarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Base', q.name, 0, 500, 300
FROM qualities q WHERE q.name = 'WEBDL-720p';
INSERT INTO sonarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Base', q.name, 0, 1000, 350
FROM qualities q WHERE q.name = 'WEBRip-1080p';
INSERT INTO sonarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Base', q.name, 0, 1000, 60
FROM qualities q WHERE q.name = 'WEBRip-2160p';
INSERT INTO sonarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Base', q.name, 0, 1000, 990
FROM qualities q WHERE q.name = 'WEBRip-480p';
INSERT INTO sonarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Media-Base', q.name, 0, 500, 300
FROM qualities q WHERE q.name = 'WEBRip-720p';
INSERT INTO radarr_naming (name, rename, movie_format, movie_folder_format, replace_illegal_characters, colon_replacement_format) VALUES ('FR-Media-Base', 0, '{Movie CleanTitle} ({Release Year}) {tmdb-{TmdbId}} {edition-{Edition Tags}} [{Custom Formats}] [{Quality Full}] [{MediaInfo 3D}] [{MediaInfo VideoDynamicRangeType}] [{MediaInfo AudioCodec} {MediaInfo AudioChannels}] [{MediaInfo VideoCodec}] {-Release Group}', '{Movie CleanTitle} ({Release Year}) {tmdb-{TmdbId}}', 0, 'smart');
INSERT INTO sonarr_naming (name, rename, standard_episode_format, daily_episode_format, anime_episode_format, series_folder_format, season_folder_format, replace_illegal_characters, colon_replacement_format, custom_colon_replacement_format, multi_episode_style) VALUES ('FR-Media-Base', 0, '{Series TitleYear} - S{season:00}E{episode:00} - {Episode CleanTitle} [{Custom Formats}] [{Quality Full}] [{MediaInfo VideoDynamicRangeType}] [{MediaInfo AudioCodec} {MediaInfo AudioChannels}] [{MediaInfo VideoCodec}] {-Release Group}', '{Series TitleYear} - {Air-Date} - {Episode CleanTitle} [{Custom Formats}] [{Quality Full}] [{MediaInfo VideoDynamicRangeType}] [{MediaInfo AudioCodec} {MediaInfo AudioChannels}] [{MediaInfo VideoCodec}] {-Release Group}', '{Series TitleYear} - S{season:00}E{episode:00} - {absolute:000} - {Episode CleanTitle} [{Custom Formats}] [{Quality Full}] [{MediaInfo VideoDynamicRangeType}] [{MediaInfo VideoBitDepth}bit] [{MediaInfo VideoCodec}] [{MediaInfo AudioCodec} {MediaInfo AudioChannels}] [{MediaInfo AudioLanguages}] {-Release Group}', '{Series TitleYear} {tvdb-{TvdbId}}', 'Season {season:00}', 0, 'smart', NULL, 5);

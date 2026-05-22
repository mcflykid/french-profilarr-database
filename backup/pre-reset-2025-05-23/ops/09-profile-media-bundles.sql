-- Fichier 09 : un preset media par profil (même nom que le profil qualité) + FR-Delay-Sonarr

UPDATE radarr_media_settings SET propers_repacks = 'doNotPrefer' WHERE name = 'FR-Media-Base';
UPDATE sonarr_media_settings SET propers_repacks = 'doNotPrefer' WHERE name = 'FR-Media-Base';

-- Delay Sonarr (Radarr : FR-Delay-Radarr dans ops/07)
INSERT INTO delay_profiles (
    name, preferred_protocol, usenet_delay, torrent_delay,
    bypass_if_highest_quality, bypass_if_above_custom_format_score, minimum_custom_format_score
) VALUES ('FR-Delay-Sonarr', 'only_torrent', NULL, 0, 1, 0, NULL);

-- FR-Films-4K (Radarr — profil qualité = ce nom dans Media Management)
INSERT INTO radarr_media_settings (name, propers_repacks, enable_media_info)
VALUES ('FR-Films-4K', 'doNotPrefer', 1);

INSERT INTO radarr_naming (name, rename, movie_format, movie_folder_format, replace_illegal_characters, colon_replacement_format)
SELECT 'FR-Films-4K', rename, movie_format, movie_folder_format, replace_illegal_characters, colon_replacement_format
FROM radarr_naming WHERE name = 'FR-Media-Base';

INSERT INTO radarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Films-4K', quality_name, min_size, max_size, CASE WHEN quality_name = 'Bluray-2160p' THEN 55 WHEN quality_name = 'HDTV-2160p' THEN 55 WHEN quality_name = 'WEBDL-2160p' THEN 60 WHEN quality_name = 'WEBRip-2160p' THEN 60 ELSE preferred_size END
FROM radarr_quality_definitions WHERE name = 'FR-Media-Base';

-- FR-Films-1080p (Radarr — profil qualité = ce nom dans Media Management)
INSERT INTO radarr_media_settings (name, propers_repacks, enable_media_info)
VALUES ('FR-Films-1080p', 'doNotPrefer', 1);

INSERT INTO radarr_naming (name, rename, movie_format, movie_folder_format, replace_illegal_characters, colon_replacement_format)
SELECT 'FR-Films-1080p', rename, movie_format, movie_folder_format, replace_illegal_characters, colon_replacement_format
FROM radarr_naming WHERE name = 'FR-Media-Base';

INSERT INTO radarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Films-1080p', quality_name, min_size, max_size, CASE WHEN quality_name = 'Bluray-1080p' THEN 900 WHEN quality_name = 'HDTV-1080p' THEN 400 WHEN quality_name = 'WEBDL-1080p' THEN 400 WHEN quality_name = 'WEBRip-1080p' THEN 400 ELSE preferred_size END
FROM radarr_quality_definitions WHERE name = 'FR-Media-Base';

-- FR-Films-720p (Radarr — profil qualité = ce nom dans Media Management)
INSERT INTO radarr_media_settings (name, propers_repacks, enable_media_info)
VALUES ('FR-Films-720p', 'doNotPrefer', 1);

INSERT INTO radarr_naming (name, rename, movie_format, movie_folder_format, replace_illegal_characters, colon_replacement_format)
SELECT 'FR-Films-720p', rename, movie_format, movie_folder_format, replace_illegal_characters, colon_replacement_format
FROM radarr_naming WHERE name = 'FR-Media-Base';

INSERT INTO radarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Films-720p', quality_name, min_size, max_size, CASE WHEN quality_name = 'Bluray-720p' THEN 450 WHEN quality_name = 'HDTV-720p' THEN 200 WHEN quality_name = 'WEBDL-720p' THEN 300 WHEN quality_name = 'WEBRip-720p' THEN 300 ELSE preferred_size END
FROM radarr_quality_definitions WHERE name = 'FR-Media-Base';

-- FR-Films-Any (Radarr — profil qualité = ce nom dans Media Management)
INSERT INTO radarr_media_settings (name, propers_repacks, enable_media_info)
VALUES ('FR-Films-Any', 'doNotPrefer', 1);

INSERT INTO radarr_naming (name, rename, movie_format, movie_folder_format, replace_illegal_characters, colon_replacement_format)
SELECT 'FR-Films-Any', rename, movie_format, movie_folder_format, replace_illegal_characters, colon_replacement_format
FROM radarr_naming WHERE name = 'FR-Media-Base';

INSERT INTO radarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Films-Any', quality_name, min_size, max_size, preferred_size
FROM radarr_quality_definitions WHERE name = 'FR-Media-Base';

-- FR-Series-4K (Sonarr — profil qualité = ce nom dans Media Management)
INSERT INTO sonarr_media_settings (name, propers_repacks, enable_media_info)
VALUES ('FR-Series-4K', 'doNotPrefer', 1);

INSERT INTO sonarr_naming (name, rename, standard_episode_format, daily_episode_format, anime_episode_format, series_folder_format, season_folder_format, replace_illegal_characters, colon_replacement_format, custom_colon_replacement_format, multi_episode_style)
SELECT 'FR-Series-4K', rename, standard_episode_format, daily_episode_format, anime_episode_format, series_folder_format, season_folder_format, replace_illegal_characters, colon_replacement_format, custom_colon_replacement_format, multi_episode_style
FROM sonarr_naming WHERE name = 'FR-Media-Base';

INSERT INTO sonarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Series-4K', quality_name, min_size, max_size, CASE WHEN quality_name = 'Bluray-2160p' THEN 55 WHEN quality_name = 'HDTV-2160p' THEN 55 WHEN quality_name = 'WEBDL-2160p' THEN 60 WHEN quality_name = 'WEBRip-2160p' THEN 60 ELSE preferred_size END
FROM sonarr_quality_definitions WHERE name = 'FR-Media-Base';

-- FR-Series-1080p (Sonarr — profil qualité = ce nom dans Media Management)
INSERT INTO sonarr_media_settings (name, propers_repacks, enable_media_info)
VALUES ('FR-Series-1080p', 'doNotPrefer', 1);

INSERT INTO sonarr_naming (name, rename, standard_episode_format, daily_episode_format, anime_episode_format, series_folder_format, season_folder_format, replace_illegal_characters, colon_replacement_format, custom_colon_replacement_format, multi_episode_style)
SELECT 'FR-Series-1080p', rename, standard_episode_format, daily_episode_format, anime_episode_format, series_folder_format, season_folder_format, replace_illegal_characters, colon_replacement_format, custom_colon_replacement_format, multi_episode_style
FROM sonarr_naming WHERE name = 'FR-Media-Base';

INSERT INTO sonarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Series-1080p', quality_name, min_size, max_size, CASE WHEN quality_name = 'Bluray-1080p' THEN 800 WHEN quality_name = 'HDTV-1080p' THEN 350 WHEN quality_name = 'WEBDL-1080p' THEN 350 WHEN quality_name = 'WEBRip-1080p' THEN 350 ELSE preferred_size END
FROM sonarr_quality_definitions WHERE name = 'FR-Media-Base';

-- FR-Series-720p (Sonarr — profil qualité = ce nom dans Media Management)
INSERT INTO sonarr_media_settings (name, propers_repacks, enable_media_info)
VALUES ('FR-Series-720p', 'doNotPrefer', 1);

INSERT INTO sonarr_naming (name, rename, standard_episode_format, daily_episode_format, anime_episode_format, series_folder_format, season_folder_format, replace_illegal_characters, colon_replacement_format, custom_colon_replacement_format, multi_episode_style)
SELECT 'FR-Series-720p', rename, standard_episode_format, daily_episode_format, anime_episode_format, series_folder_format, season_folder_format, replace_illegal_characters, colon_replacement_format, custom_colon_replacement_format, multi_episode_style
FROM sonarr_naming WHERE name = 'FR-Media-Base';

INSERT INTO sonarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Series-720p', quality_name, min_size, max_size, CASE WHEN quality_name = 'Bluray-720p' THEN 450 WHEN quality_name = 'HDTV-720p' THEN 200 WHEN quality_name = 'WEBDL-720p' THEN 300 WHEN quality_name = 'WEBRip-720p' THEN 300 ELSE preferred_size END
FROM sonarr_quality_definitions WHERE name = 'FR-Media-Base';

-- FR-Anime-4K (Sonarr — profil qualité = ce nom dans Media Management)
INSERT INTO sonarr_media_settings (name, propers_repacks, enable_media_info)
VALUES ('FR-Anime-4K', 'doNotPrefer', 1);

INSERT INTO sonarr_naming (name, rename, standard_episode_format, daily_episode_format, anime_episode_format, series_folder_format, season_folder_format, replace_illegal_characters, colon_replacement_format, custom_colon_replacement_format, multi_episode_style)
SELECT 'FR-Anime-4K', rename, standard_episode_format, daily_episode_format, anime_episode_format, series_folder_format, season_folder_format, replace_illegal_characters, colon_replacement_format, custom_colon_replacement_format, multi_episode_style
FROM sonarr_naming WHERE name = 'FR-Media-Base';

INSERT INTO sonarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Anime-4K', quality_name, min_size, max_size, CASE WHEN quality_name = 'Bluray-2160p' THEN 55 WHEN quality_name = 'HDTV-2160p' THEN 55 WHEN quality_name = 'WEBDL-2160p' THEN 60 WHEN quality_name = 'WEBRip-2160p' THEN 60 ELSE preferred_size END
FROM sonarr_quality_definitions WHERE name = 'FR-Media-Base';

-- FR-Anime-1080p (Sonarr — profil qualité = ce nom dans Media Management)
INSERT INTO sonarr_media_settings (name, propers_repacks, enable_media_info)
VALUES ('FR-Anime-1080p', 'doNotPrefer', 1);

INSERT INTO sonarr_naming (name, rename, standard_episode_format, daily_episode_format, anime_episode_format, series_folder_format, season_folder_format, replace_illegal_characters, colon_replacement_format, custom_colon_replacement_format, multi_episode_style)
SELECT 'FR-Anime-1080p', rename, standard_episode_format, daily_episode_format, anime_episode_format, series_folder_format, season_folder_format, replace_illegal_characters, colon_replacement_format, custom_colon_replacement_format, multi_episode_style
FROM sonarr_naming WHERE name = 'FR-Media-Base';

INSERT INTO sonarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Anime-1080p', quality_name, min_size, max_size, CASE WHEN quality_name = 'Bluray-1080p' THEN 800 WHEN quality_name = 'HDTV-1080p' THEN 350 WHEN quality_name = 'WEBDL-1080p' THEN 350 WHEN quality_name = 'WEBRip-1080p' THEN 350 ELSE preferred_size END
FROM sonarr_quality_definitions WHERE name = 'FR-Media-Base';

-- FR-Anime-720p (Sonarr — profil qualité = ce nom dans Media Management)
INSERT INTO sonarr_media_settings (name, propers_repacks, enable_media_info)
VALUES ('FR-Anime-720p', 'doNotPrefer', 1);

INSERT INTO sonarr_naming (name, rename, standard_episode_format, daily_episode_format, anime_episode_format, series_folder_format, season_folder_format, replace_illegal_characters, colon_replacement_format, custom_colon_replacement_format, multi_episode_style)
SELECT 'FR-Anime-720p', rename, standard_episode_format, daily_episode_format, anime_episode_format, series_folder_format, season_folder_format, replace_illegal_characters, colon_replacement_format, custom_colon_replacement_format, multi_episode_style
FROM sonarr_naming WHERE name = 'FR-Media-Base';

INSERT INTO sonarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT 'FR-Anime-720p', quality_name, min_size, max_size, CASE WHEN quality_name = 'Bluray-720p' THEN 450 WHEN quality_name = 'HDTV-720p' THEN 200 WHEN quality_name = 'WEBDL-720p' THEN 300 WHEN quality_name = 'WEBRip-720p' THEN 300 ELSE preferred_size END
FROM sonarr_quality_definitions WHERE name = 'FR-Media-Base';

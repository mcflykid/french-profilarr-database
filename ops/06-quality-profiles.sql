-- french-profilarr-database — ops/06
-- Profils qualité FR-* + groupes, scores, tags profil (Radarr/Sonarr/Films/Series/anime).

-- Seuils : minimum 400/500 ; upgrade_until 60000 ; increment 500 (anti-churn : pas de re-téléchargement sous +500 CF — ex. Repack +120, Season Pack +120 ; protège ratio et cross-seed). Langue 1er tri (8k max), équipe/HDR/son dominant (2026-05).
INSERT INTO quality_profiles (name, description, upgrades_allowed, minimum_custom_format_score, upgrade_until_score, upgrade_score_increment) VALUES ('FR-Anime-1080p', 'Profil Sonarr 1080p — animé, trackers FR. Objectif : 1080p efficient, HDTV-1080p, Season Pack. Fallback 720p si aucune release 1080p (upgrade auto). Exclut : Remux, Full Disc, AV1, Upscaled.', 1, 0, 60000, 500);
INSERT INTO quality_profiles (name, description, upgrades_allowed, minimum_custom_format_score, upgrade_until_score, upgrade_score_increment) VALUES ('FR-Anime-4K', 'Profil Sonarr 4K — animé (type Anime), trackers FR. Objectif : UHD HEVC, langue FR, DV/HDR, bonus 4KLight/Hybrid. Fallback 1080p puis 720p si aucune release UHD (upgrade auto vers 2160p ensuite). Exclut : x264@2160p, Remux, Full Disc, AV1, Upscaled.', 1, 500, 60000, 500);
INSERT INTO quality_profiles (name, description, upgrades_allowed, minimum_custom_format_score, upgrade_until_score, upgrade_score_increment) VALUES ('FR-Anime-720p', 'Profil Sonarr 720p — animé, trackers FR. Objectif : 720p compact, HDTV-720p. Exclut : Remux, Full Disc, AV1, Upscaled.', 1, 0, 60000, 500);
INSERT INTO quality_profiles (name, description, upgrades_allowed, minimum_custom_format_score, upgrade_until_score, upgrade_score_increment) VALUES ('FR-Films-1080p', 'Profil Radarr 1080p — trackers scène FR. Objectif : WEB/Bluray 1080p efficient (x265/h265), langue FR, audio premium, éditions IMAX/Theatrical. Fallback 720p si aucune release 1080p (upgrade auto). Priorité : hiérarchie langue FR + équipes + streamers. Exclut : Remux, Full Disc, AV1, Upscaled.', 1, 400, 60000, 500);
INSERT INTO quality_profiles (name, description, upgrades_allowed, minimum_custom_format_score, upgrade_until_score, upgrade_score_increment) VALUES ('FR-Films-4K', 'Profil Radarr 4K — scène française privée. Objectif : UHD encode HEVC, langue FR, DV puis HDR10+/HDR10, audio premium. Fallback 1080p puis 720p si aucune release UHD (upgrade auto vers 2160p ensuite). Priorité : MULTI VF2 > MULTI VFF > VF2 > VFF > VOSTFR ; équipes FR (team puis tier). Exclut : x264@2160p, Remux, Full Disc, AV1 (-999999), Upscaled.', 1, 500, 60000, 500);
INSERT INTO quality_profiles (name, description, upgrades_allowed, minimum_custom_format_score, upgrade_until_score, upgrade_score_increment) VALUES ('FR-Series-1080p', 'Profil Sonarr 1080p — séries sur trackers FR. Objectif : 1080p efficient, HDTV-1080p toléré (TV cap), Season Pack. Fallback 720p si aucune release 1080p (upgrade auto). Exclut : Remux, Full Disc, AV1, Upscaled.', 1, 0, 60000, 500);
INSERT INTO quality_profiles (name, description, upgrades_allowed, minimum_custom_format_score, upgrade_until_score, upgrade_score_increment) VALUES ('FR-Series-4K', 'Profil Sonarr 4K — séries sur trackers FR. Objectif : UHD HEVC, langue FR, DV/HDR, audio premium, bonus Season Pack. Priorité : langue FR + équipes. Fallback 1080p puis 720p si aucune release UHD (upgrade auto vers 2160p ensuite). Exclut : x264@UHD, Remux, Full Disc, AV1, Upscaled.', 1, 500, 60000, 500);
INSERT INTO quality_profiles (name, description, upgrades_allowed, minimum_custom_format_score, upgrade_until_score, upgrade_score_increment) VALUES ('FR-Series-720p', 'Profil Sonarr 720p — séries sur trackers FR. Objectif : 720p compact, HDTV-720p, Season Pack. Exclut : Remux, AV1, Upscaled.', 1, 0, 60000, 500);

-- Quality groups
INSERT INTO quality_groups (quality_profile_name, name)
SELECT 'FR-Anime-1080p', '1080p Quality' FROM quality_profiles qp WHERE qp.name = 'FR-Anime-1080p';
INSERT INTO quality_groups (quality_profile_name, name)
SELECT 'FR-Anime-1080p', '720p Fallback' FROM quality_profiles qp WHERE qp.name = 'FR-Anime-1080p';
INSERT INTO quality_groups (quality_profile_name, name)
SELECT 'FR-Anime-4K', '2160p Quality' FROM quality_profiles qp WHERE qp.name = 'FR-Anime-4K';
INSERT INTO quality_groups (quality_profile_name, name)
SELECT 'FR-Anime-4K', '1080p Fallback' FROM quality_profiles qp WHERE qp.name = 'FR-Anime-4K';
INSERT INTO quality_groups (quality_profile_name, name)
SELECT 'FR-Anime-4K', '720p Fallback' FROM quality_profiles qp WHERE qp.name = 'FR-Anime-4K';
INSERT INTO quality_groups (quality_profile_name, name)
SELECT 'FR-Anime-720p', '720p Quality' FROM quality_profiles qp WHERE qp.name = 'FR-Anime-720p';
INSERT INTO quality_groups (quality_profile_name, name)
SELECT 'FR-Films-1080p', '1080p Quality' FROM quality_profiles qp WHERE qp.name = 'FR-Films-1080p';
INSERT INTO quality_groups (quality_profile_name, name)
SELECT 'FR-Films-1080p', '720p Fallback' FROM quality_profiles qp WHERE qp.name = 'FR-Films-1080p';
INSERT INTO quality_groups (quality_profile_name, name)
SELECT 'FR-Films-4K', '2160p Quality' FROM quality_profiles qp WHERE qp.name = 'FR-Films-4K';
-- Fallback 1080p : sans release 4K dispo (vieux films), prendre du 1080p puis upgrader vers 2160p (upgrade_until sur le groupe 2160p).
INSERT INTO quality_groups (quality_profile_name, name)
SELECT 'FR-Films-4K', '1080p Fallback' FROM quality_profiles qp WHERE qp.name = 'FR-Films-4K';
INSERT INTO quality_groups (quality_profile_name, name)
SELECT 'FR-Films-4K', '720p Fallback' FROM quality_profiles qp WHERE qp.name = 'FR-Films-4K';
INSERT INTO quality_groups (quality_profile_name, name)
SELECT 'FR-Series-1080p', '1080p Quality' FROM quality_profiles qp WHERE qp.name = 'FR-Series-1080p';
INSERT INTO quality_groups (quality_profile_name, name)
SELECT 'FR-Series-1080p', '720p Fallback' FROM quality_profiles qp WHERE qp.name = 'FR-Series-1080p';
INSERT INTO quality_groups (quality_profile_name, name)
SELECT 'FR-Series-4K', '2160p Quality' FROM quality_profiles qp WHERE qp.name = 'FR-Series-4K';
INSERT INTO quality_groups (quality_profile_name, name)
SELECT 'FR-Series-4K', '1080p Fallback' FROM quality_profiles qp WHERE qp.name = 'FR-Series-4K';
INSERT INTO quality_groups (quality_profile_name, name)
SELECT 'FR-Series-4K', '720p Fallback' FROM quality_profiles qp WHERE qp.name = 'FR-Series-4K';
INSERT INTO quality_groups (quality_profile_name, name)
SELECT 'FR-Series-720p', '720p Quality' FROM quality_profiles qp WHERE qp.name = 'FR-Series-720p';

-- Quality group members
INSERT INTO quality_group_members (quality_profile_name, quality_group_name, quality_name, position)
SELECT 'FR-Anime-1080p', '1080p Quality', q.name, 0 FROM qualities q WHERE q.name = 'Bluray-1080p';
INSERT INTO quality_group_members (quality_profile_name, quality_group_name, quality_name, position)
SELECT 'FR-Anime-1080p', '1080p Quality', q.name, 1 FROM qualities q WHERE q.name = 'WEBDL-1080p';
INSERT INTO quality_group_members (quality_profile_name, quality_group_name, quality_name, position)
SELECT 'FR-Anime-1080p', '1080p Quality', q.name, 2 FROM qualities q WHERE q.name = 'WEBRip-1080p';
INSERT INTO quality_group_members (quality_profile_name, quality_group_name, quality_name, position)
SELECT 'FR-Anime-1080p', '1080p Quality', q.name, 3 FROM qualities q WHERE q.name = 'HDTV-1080p';
INSERT INTO quality_group_members (quality_profile_name, quality_group_name, quality_name, position)
SELECT 'FR-Anime-1080p', '720p Fallback', q.name, 0 FROM qualities q WHERE q.name = 'Bluray-720p';
INSERT INTO quality_group_members (quality_profile_name, quality_group_name, quality_name, position)
SELECT 'FR-Anime-1080p', '720p Fallback', q.name, 1 FROM qualities q WHERE q.name = 'WEBDL-720p';
INSERT INTO quality_group_members (quality_profile_name, quality_group_name, quality_name, position)
SELECT 'FR-Anime-1080p', '720p Fallback', q.name, 2 FROM qualities q WHERE q.name = 'WEBRip-720p';
INSERT INTO quality_group_members (quality_profile_name, quality_group_name, quality_name, position)
SELECT 'FR-Anime-1080p', '720p Fallback', q.name, 3 FROM qualities q WHERE q.name = 'HDTV-720p';
INSERT INTO quality_group_members (quality_profile_name, quality_group_name, quality_name, position)
SELECT 'FR-Anime-4K', '2160p Quality', q.name, 0 FROM qualities q WHERE q.name = 'Bluray-2160p';
INSERT INTO quality_group_members (quality_profile_name, quality_group_name, quality_name, position)
SELECT 'FR-Anime-4K', '2160p Quality', q.name, 1 FROM qualities q WHERE q.name = 'WEBDL-2160p';
INSERT INTO quality_group_members (quality_profile_name, quality_group_name, quality_name, position)
SELECT 'FR-Anime-4K', '2160p Quality', q.name, 2 FROM qualities q WHERE q.name = 'WEBRip-2160p';
INSERT INTO quality_group_members (quality_profile_name, quality_group_name, quality_name, position)
SELECT 'FR-Anime-4K', '1080p Fallback', q.name, 0 FROM qualities q WHERE q.name = 'Bluray-1080p';
INSERT INTO quality_group_members (quality_profile_name, quality_group_name, quality_name, position)
SELECT 'FR-Anime-4K', '1080p Fallback', q.name, 1 FROM qualities q WHERE q.name = 'WEBDL-1080p';
INSERT INTO quality_group_members (quality_profile_name, quality_group_name, quality_name, position)
SELECT 'FR-Anime-4K', '1080p Fallback', q.name, 2 FROM qualities q WHERE q.name = 'WEBRip-1080p';
INSERT INTO quality_group_members (quality_profile_name, quality_group_name, quality_name, position)
SELECT 'FR-Anime-4K', '1080p Fallback', q.name, 3 FROM qualities q WHERE q.name = 'HDTV-1080p';
INSERT INTO quality_group_members (quality_profile_name, quality_group_name, quality_name, position)
SELECT 'FR-Anime-4K', '720p Fallback', q.name, 0 FROM qualities q WHERE q.name = 'Bluray-720p';
INSERT INTO quality_group_members (quality_profile_name, quality_group_name, quality_name, position)
SELECT 'FR-Anime-4K', '720p Fallback', q.name, 1 FROM qualities q WHERE q.name = 'WEBDL-720p';
INSERT INTO quality_group_members (quality_profile_name, quality_group_name, quality_name, position)
SELECT 'FR-Anime-4K', '720p Fallback', q.name, 2 FROM qualities q WHERE q.name = 'WEBRip-720p';
INSERT INTO quality_group_members (quality_profile_name, quality_group_name, quality_name, position)
SELECT 'FR-Anime-4K', '720p Fallback', q.name, 3 FROM qualities q WHERE q.name = 'HDTV-720p';
INSERT INTO quality_group_members (quality_profile_name, quality_group_name, quality_name, position)
SELECT 'FR-Anime-720p', '720p Quality', q.name, 0 FROM qualities q WHERE q.name = 'Bluray-720p';
INSERT INTO quality_group_members (quality_profile_name, quality_group_name, quality_name, position)
SELECT 'FR-Anime-720p', '720p Quality', q.name, 1 FROM qualities q WHERE q.name = 'WEBDL-720p';
INSERT INTO quality_group_members (quality_profile_name, quality_group_name, quality_name, position)
SELECT 'FR-Anime-720p', '720p Quality', q.name, 2 FROM qualities q WHERE q.name = 'WEBRip-720p';
INSERT INTO quality_group_members (quality_profile_name, quality_group_name, quality_name, position)
SELECT 'FR-Anime-720p', '720p Quality', q.name, 3 FROM qualities q WHERE q.name = 'HDTV-720p';
INSERT INTO quality_group_members (quality_profile_name, quality_group_name, quality_name, position)
SELECT 'FR-Films-1080p', '1080p Quality', q.name, 0 FROM qualities q WHERE q.name = 'Bluray-1080p';
INSERT INTO quality_group_members (quality_profile_name, quality_group_name, quality_name, position)
SELECT 'FR-Films-1080p', '1080p Quality', q.name, 1 FROM qualities q WHERE q.name = 'WEBDL-1080p';
INSERT INTO quality_group_members (quality_profile_name, quality_group_name, quality_name, position)
SELECT 'FR-Films-1080p', '1080p Quality', q.name, 2 FROM qualities q WHERE q.name = 'WEBRip-1080p';
INSERT INTO quality_group_members (quality_profile_name, quality_group_name, quality_name, position)
SELECT 'FR-Films-1080p', '720p Fallback', q.name, 0 FROM qualities q WHERE q.name = 'Bluray-720p';
INSERT INTO quality_group_members (quality_profile_name, quality_group_name, quality_name, position)
SELECT 'FR-Films-1080p', '720p Fallback', q.name, 1 FROM qualities q WHERE q.name = 'WEBDL-720p';
INSERT INTO quality_group_members (quality_profile_name, quality_group_name, quality_name, position)
SELECT 'FR-Films-1080p', '720p Fallback', q.name, 2 FROM qualities q WHERE q.name = 'WEBRip-720p';
INSERT INTO quality_group_members (quality_profile_name, quality_group_name, quality_name, position)
SELECT 'FR-Films-1080p', '720p Fallback', q.name, 3 FROM qualities q WHERE q.name = 'HDTV-720p';
INSERT INTO quality_group_members (quality_profile_name, quality_group_name, quality_name, position)
-- Filet de sécurité : HDTV-1080p en dernière position (préférence égale, départagé par les scores CF).
-- Rattrape les HDLight "nues" (sans mot-source) que le parser Radarr devine en HDTV-1080p. Aligné sur FR-Series-1080p / FR-Anime-1080p.
SELECT 'FR-Films-1080p', '1080p Quality', q.name, 3 FROM qualities q WHERE q.name = 'HDTV-1080p';
INSERT INTO quality_group_members (quality_profile_name, quality_group_name, quality_name, position)
SELECT 'FR-Films-4K', '2160p Quality', q.name, 0 FROM qualities q WHERE q.name = 'Bluray-2160p';
INSERT INTO quality_group_members (quality_profile_name, quality_group_name, quality_name, position)
SELECT 'FR-Films-4K', '2160p Quality', q.name, 1 FROM qualities q WHERE q.name = 'WEBDL-2160p';
INSERT INTO quality_group_members (quality_profile_name, quality_group_name, quality_name, position)
SELECT 'FR-Films-4K', '2160p Quality', q.name, 2 FROM qualities q WHERE q.name = 'WEBRip-2160p';
INSERT INTO quality_group_members (quality_profile_name, quality_group_name, quality_name, position)
SELECT 'FR-Films-4K', '1080p Fallback', q.name, 0 FROM qualities q WHERE q.name = 'Bluray-1080p';
INSERT INTO quality_group_members (quality_profile_name, quality_group_name, quality_name, position)
SELECT 'FR-Films-4K', '1080p Fallback', q.name, 1 FROM qualities q WHERE q.name = 'WEBDL-1080p';
INSERT INTO quality_group_members (quality_profile_name, quality_group_name, quality_name, position)
SELECT 'FR-Films-4K', '1080p Fallback', q.name, 2 FROM qualities q WHERE q.name = 'WEBRip-1080p';
INSERT INTO quality_group_members (quality_profile_name, quality_group_name, quality_name, position)
SELECT 'FR-Films-4K', '1080p Fallback', q.name, 3 FROM qualities q WHERE q.name = 'HDTV-1080p';
INSERT INTO quality_group_members (quality_profile_name, quality_group_name, quality_name, position)
SELECT 'FR-Films-4K', '720p Fallback', q.name, 0 FROM qualities q WHERE q.name = 'Bluray-720p';
INSERT INTO quality_group_members (quality_profile_name, quality_group_name, quality_name, position)
SELECT 'FR-Films-4K', '720p Fallback', q.name, 1 FROM qualities q WHERE q.name = 'WEBDL-720p';
INSERT INTO quality_group_members (quality_profile_name, quality_group_name, quality_name, position)
SELECT 'FR-Films-4K', '720p Fallback', q.name, 2 FROM qualities q WHERE q.name = 'WEBRip-720p';
INSERT INTO quality_group_members (quality_profile_name, quality_group_name, quality_name, position)
SELECT 'FR-Films-4K', '720p Fallback', q.name, 3 FROM qualities q WHERE q.name = 'HDTV-720p';
INSERT INTO quality_group_members (quality_profile_name, quality_group_name, quality_name, position)
SELECT 'FR-Series-1080p', '1080p Quality', q.name, 0 FROM qualities q WHERE q.name = 'Bluray-1080p';
INSERT INTO quality_group_members (quality_profile_name, quality_group_name, quality_name, position)
SELECT 'FR-Series-1080p', '1080p Quality', q.name, 1 FROM qualities q WHERE q.name = 'WEBDL-1080p';
INSERT INTO quality_group_members (quality_profile_name, quality_group_name, quality_name, position)
SELECT 'FR-Series-1080p', '1080p Quality', q.name, 2 FROM qualities q WHERE q.name = 'WEBRip-1080p';
INSERT INTO quality_group_members (quality_profile_name, quality_group_name, quality_name, position)
SELECT 'FR-Series-1080p', '1080p Quality', q.name, 3 FROM qualities q WHERE q.name = 'HDTV-1080p';
INSERT INTO quality_group_members (quality_profile_name, quality_group_name, quality_name, position)
SELECT 'FR-Series-1080p', '720p Fallback', q.name, 0 FROM qualities q WHERE q.name = 'Bluray-720p';
INSERT INTO quality_group_members (quality_profile_name, quality_group_name, quality_name, position)
SELECT 'FR-Series-1080p', '720p Fallback', q.name, 1 FROM qualities q WHERE q.name = 'WEBDL-720p';
INSERT INTO quality_group_members (quality_profile_name, quality_group_name, quality_name, position)
SELECT 'FR-Series-1080p', '720p Fallback', q.name, 2 FROM qualities q WHERE q.name = 'WEBRip-720p';
INSERT INTO quality_group_members (quality_profile_name, quality_group_name, quality_name, position)
SELECT 'FR-Series-1080p', '720p Fallback', q.name, 3 FROM qualities q WHERE q.name = 'HDTV-720p';
INSERT INTO quality_group_members (quality_profile_name, quality_group_name, quality_name, position)
SELECT 'FR-Series-4K', '2160p Quality', q.name, 0 FROM qualities q WHERE q.name = 'Bluray-2160p';
INSERT INTO quality_group_members (quality_profile_name, quality_group_name, quality_name, position)
SELECT 'FR-Series-4K', '2160p Quality', q.name, 1 FROM qualities q WHERE q.name = 'WEBDL-2160p';
INSERT INTO quality_group_members (quality_profile_name, quality_group_name, quality_name, position)
SELECT 'FR-Series-4K', '2160p Quality', q.name, 2 FROM qualities q WHERE q.name = 'WEBRip-2160p';
INSERT INTO quality_group_members (quality_profile_name, quality_group_name, quality_name, position)
SELECT 'FR-Series-4K', '1080p Fallback', q.name, 0 FROM qualities q WHERE q.name = 'Bluray-1080p';
INSERT INTO quality_group_members (quality_profile_name, quality_group_name, quality_name, position)
SELECT 'FR-Series-4K', '1080p Fallback', q.name, 1 FROM qualities q WHERE q.name = 'WEBDL-1080p';
INSERT INTO quality_group_members (quality_profile_name, quality_group_name, quality_name, position)
SELECT 'FR-Series-4K', '1080p Fallback', q.name, 2 FROM qualities q WHERE q.name = 'WEBRip-1080p';
INSERT INTO quality_group_members (quality_profile_name, quality_group_name, quality_name, position)
SELECT 'FR-Series-4K', '1080p Fallback', q.name, 3 FROM qualities q WHERE q.name = 'HDTV-1080p';
INSERT INTO quality_group_members (quality_profile_name, quality_group_name, quality_name, position)
SELECT 'FR-Series-4K', '720p Fallback', q.name, 0 FROM qualities q WHERE q.name = 'Bluray-720p';
INSERT INTO quality_group_members (quality_profile_name, quality_group_name, quality_name, position)
SELECT 'FR-Series-4K', '720p Fallback', q.name, 1 FROM qualities q WHERE q.name = 'WEBDL-720p';
INSERT INTO quality_group_members (quality_profile_name, quality_group_name, quality_name, position)
SELECT 'FR-Series-4K', '720p Fallback', q.name, 2 FROM qualities q WHERE q.name = 'WEBRip-720p';
INSERT INTO quality_group_members (quality_profile_name, quality_group_name, quality_name, position)
SELECT 'FR-Series-4K', '720p Fallback', q.name, 3 FROM qualities q WHERE q.name = 'HDTV-720p';
INSERT INTO quality_group_members (quality_profile_name, quality_group_name, quality_name, position)
SELECT 'FR-Series-720p', '720p Quality', q.name, 0 FROM qualities q WHERE q.name = 'Bluray-720p';
INSERT INTO quality_group_members (quality_profile_name, quality_group_name, quality_name, position)
SELECT 'FR-Series-720p', '720p Quality', q.name, 1 FROM qualities q WHERE q.name = 'WEBDL-720p';
INSERT INTO quality_group_members (quality_profile_name, quality_group_name, quality_name, position)
SELECT 'FR-Series-720p', '720p Quality', q.name, 2 FROM qualities q WHERE q.name = 'WEBRip-720p';
INSERT INTO quality_group_members (quality_profile_name, quality_group_name, quality_name, position)
SELECT 'FR-Series-720p', '720p Quality', q.name, 3 FROM qualities q WHERE q.name = 'HDTV-720p';

-- Quality profile qualities (order + upgrade_until)
INSERT INTO quality_profile_qualities (quality_profile_name, quality_group_name, position, upgrade_until)
SELECT qp.name, qg.name, 0, 0
FROM quality_profiles qp, quality_groups qg
WHERE qp.name = 'FR-Anime-1080p' AND qg.quality_profile_name = qp.name AND qg.name = '720p Fallback';
INSERT INTO quality_profile_qualities (quality_profile_name, quality_group_name, position, upgrade_until)
SELECT qp.name, qg.name, 1, 1
FROM quality_profiles qp, quality_groups qg
WHERE qp.name = 'FR-Anime-1080p' AND qg.quality_profile_name = qp.name AND qg.name = '1080p Quality';
-- FR-Anime-4K : 1080p Fallback (position 0) < 2160p Quality (position 1, cutoff upgrade_until).
INSERT INTO quality_profile_qualities (quality_profile_name, quality_group_name, position, upgrade_until)
SELECT qp.name, qg.name, 0, 0
FROM quality_profiles qp, quality_groups qg
WHERE qp.name = 'FR-Anime-4K' AND qg.quality_profile_name = qp.name AND qg.name = '720p Fallback';
INSERT INTO quality_profile_qualities (quality_profile_name, quality_group_name, position, upgrade_until)
SELECT qp.name, qg.name, 1, 0
FROM quality_profiles qp, quality_groups qg
WHERE qp.name = 'FR-Anime-4K' AND qg.quality_profile_name = qp.name AND qg.name = '1080p Fallback';
INSERT INTO quality_profile_qualities (quality_profile_name, quality_group_name, position, upgrade_until)
SELECT qp.name, qg.name, 2, 1
FROM quality_profiles qp, quality_groups qg
WHERE qp.name = 'FR-Anime-4K' AND qg.quality_profile_name = qp.name AND qg.name = '2160p Quality';
INSERT INTO quality_profile_qualities (quality_profile_name, quality_group_name, position, upgrade_until)
SELECT qp.name, qg.name, 0, 1
FROM quality_profiles qp, quality_groups qg
WHERE qp.name = 'FR-Anime-720p' AND qg.quality_profile_name = qp.name AND qg.name = '720p Quality';
INSERT INTO quality_profile_qualities (quality_profile_name, quality_group_name, position, upgrade_until)
SELECT qp.name, qg.name, 0, 0
FROM quality_profiles qp, quality_groups qg
WHERE qp.name = 'FR-Films-1080p' AND qg.quality_profile_name = qp.name AND qg.name = '720p Fallback';
INSERT INTO quality_profile_qualities (quality_profile_name, quality_group_name, position, upgrade_until)
SELECT qp.name, qg.name, 1, 1
FROM quality_profiles qp, quality_groups qg
WHERE qp.name = 'FR-Films-1080p' AND qg.quality_profile_name = qp.name AND qg.name = '1080p Quality';
-- FR-Films-4K : 1080p Fallback (position 0, bas) < 2160p Quality (position 1, cutoff upgrade_until).
INSERT INTO quality_profile_qualities (quality_profile_name, quality_group_name, position, upgrade_until)
SELECT qp.name, qg.name, 0, 0
FROM quality_profiles qp, quality_groups qg
WHERE qp.name = 'FR-Films-4K' AND qg.quality_profile_name = qp.name AND qg.name = '720p Fallback';
INSERT INTO quality_profile_qualities (quality_profile_name, quality_group_name, position, upgrade_until)
SELECT qp.name, qg.name, 1, 0
FROM quality_profiles qp, quality_groups qg
WHERE qp.name = 'FR-Films-4K' AND qg.quality_profile_name = qp.name AND qg.name = '1080p Fallback';
INSERT INTO quality_profile_qualities (quality_profile_name, quality_group_name, position, upgrade_until)
SELECT qp.name, qg.name, 2, 1
FROM quality_profiles qp, quality_groups qg
WHERE qp.name = 'FR-Films-4K' AND qg.quality_profile_name = qp.name AND qg.name = '2160p Quality';
INSERT INTO quality_profile_qualities (quality_profile_name, quality_group_name, position, upgrade_until)
SELECT qp.name, qg.name, 0, 0
FROM quality_profiles qp, quality_groups qg
WHERE qp.name = 'FR-Series-1080p' AND qg.quality_profile_name = qp.name AND qg.name = '720p Fallback';
INSERT INTO quality_profile_qualities (quality_profile_name, quality_group_name, position, upgrade_until)
SELECT qp.name, qg.name, 1, 1
FROM quality_profiles qp, quality_groups qg
WHERE qp.name = 'FR-Series-1080p' AND qg.quality_profile_name = qp.name AND qg.name = '1080p Quality';
-- FR-Series-4K : 1080p Fallback (position 0) < 2160p Quality (position 1, cutoff upgrade_until).
INSERT INTO quality_profile_qualities (quality_profile_name, quality_group_name, position, upgrade_until)
SELECT qp.name, qg.name, 0, 0
FROM quality_profiles qp, quality_groups qg
WHERE qp.name = 'FR-Series-4K' AND qg.quality_profile_name = qp.name AND qg.name = '720p Fallback';
INSERT INTO quality_profile_qualities (quality_profile_name, quality_group_name, position, upgrade_until)
SELECT qp.name, qg.name, 1, 0
FROM quality_profiles qp, quality_groups qg
WHERE qp.name = 'FR-Series-4K' AND qg.quality_profile_name = qp.name AND qg.name = '1080p Fallback';
INSERT INTO quality_profile_qualities (quality_profile_name, quality_group_name, position, upgrade_until)
SELECT qp.name, qg.name, 2, 1
FROM quality_profiles qp, quality_groups qg
WHERE qp.name = 'FR-Series-4K' AND qg.quality_profile_name = qp.name AND qg.name = '2160p Quality';
INSERT INTO quality_profile_qualities (quality_profile_name, quality_group_name, position, upgrade_until)
SELECT qp.name, qg.name, 0, 1
FROM quality_profiles qp, quality_groups qg
WHERE qp.name = 'FR-Series-720p' AND qg.quality_profile_name = qp.name AND qg.name = '720p Quality';

-- Profile tags
INSERT OR IGNORE INTO quality_profile_tags (quality_profile_name, tag_name)
SELECT 'FR-Anime-1080p', '1080p' FROM tags t WHERE t.name = '1080p';
INSERT OR IGNORE INTO quality_profile_tags (quality_profile_name, tag_name)
SELECT 'FR-Anime-1080p', 'anime' FROM tags t WHERE t.name = 'anime';
INSERT OR IGNORE INTO quality_profile_tags (quality_profile_name, tag_name)
SELECT 'FR-Anime-1080p', 'French' FROM tags t WHERE t.name = 'French';
INSERT OR IGNORE INTO quality_profile_tags (quality_profile_name, tag_name)
SELECT 'FR-Anime-4K', '2160p' FROM tags t WHERE t.name = '2160p';
INSERT OR IGNORE INTO quality_profile_tags (quality_profile_name, tag_name)
SELECT 'FR-Anime-4K', 'anime' FROM tags t WHERE t.name = 'anime';
INSERT OR IGNORE INTO quality_profile_tags (quality_profile_name, tag_name)
SELECT 'FR-Anime-4K', 'French' FROM tags t WHERE t.name = 'French';
INSERT OR IGNORE INTO quality_profile_tags (quality_profile_name, tag_name)
SELECT 'FR-Anime-720p', '720p' FROM tags t WHERE t.name = '720p';
INSERT OR IGNORE INTO quality_profile_tags (quality_profile_name, tag_name)
SELECT 'FR-Anime-720p', 'anime' FROM tags t WHERE t.name = 'anime';
INSERT OR IGNORE INTO quality_profile_tags (quality_profile_name, tag_name)
SELECT 'FR-Anime-720p', 'French' FROM tags t WHERE t.name = 'French';
INSERT OR IGNORE INTO quality_profile_tags (quality_profile_name, tag_name)
SELECT 'FR-Films-1080p', '1080p' FROM tags t WHERE t.name = '1080p';
INSERT OR IGNORE INTO quality_profile_tags (quality_profile_name, tag_name)
SELECT 'FR-Films-1080p', 'French' FROM tags t WHERE t.name = 'French';
INSERT OR IGNORE INTO quality_profile_tags (quality_profile_name, tag_name)
SELECT 'FR-Films-4K', '2160p' FROM tags t WHERE t.name = '2160p';
INSERT OR IGNORE INTO quality_profile_tags (quality_profile_name, tag_name)
SELECT 'FR-Films-4K', 'French' FROM tags t WHERE t.name = 'French';
INSERT OR IGNORE INTO quality_profile_tags (quality_profile_name, tag_name)
SELECT 'FR-Series-1080p', '1080p' FROM tags t WHERE t.name = '1080p';
INSERT OR IGNORE INTO quality_profile_tags (quality_profile_name, tag_name)
SELECT 'FR-Series-1080p', 'French' FROM tags t WHERE t.name = 'French';
INSERT OR IGNORE INTO quality_profile_tags (quality_profile_name, tag_name)
SELECT 'FR-Series-1080p', 'tv' FROM tags t WHERE t.name = 'tv';
INSERT OR IGNORE INTO quality_profile_tags (quality_profile_name, tag_name)
SELECT 'FR-Series-4K', '2160p' FROM tags t WHERE t.name = '2160p';
INSERT OR IGNORE INTO quality_profile_tags (quality_profile_name, tag_name)
SELECT 'FR-Series-4K', 'French' FROM tags t WHERE t.name = 'French';
INSERT OR IGNORE INTO quality_profile_tags (quality_profile_name, tag_name)
SELECT 'FR-Series-4K', 'tv' FROM tags t WHERE t.name = 'tv';
INSERT OR IGNORE INTO quality_profile_tags (quality_profile_name, tag_name)
SELECT 'FR-Series-720p', '720p' FROM tags t WHERE t.name = '720p';
INSERT OR IGNORE INTO quality_profile_tags (quality_profile_name, tag_name)
SELECT 'FR-Series-720p', 'French' FROM tags t WHERE t.name = 'French';
INSERT OR IGNORE INTO quality_profile_tags (quality_profile_name, tag_name)
SELECT 'FR-Series-720p', 'tv' FROM tags t WHERE t.name = 'tv';

-- Tags UI Profilarr (filtrer Radarr / Sonarr / Films / Series — ex ops/10)
INSERT OR IGNORE INTO quality_profile_tags (quality_profile_name, tag_name)
SELECT 'FR-Films-4K', 'Radarr' FROM tags t WHERE t.name = 'Radarr';
INSERT OR IGNORE INTO quality_profile_tags (quality_profile_name, tag_name)
SELECT 'FR-Films-4K', 'Films' FROM tags t WHERE t.name = 'Films';
INSERT OR IGNORE INTO quality_profile_tags (quality_profile_name, tag_name)
SELECT 'FR-Films-1080p', 'Radarr' FROM tags t WHERE t.name = 'Radarr';
INSERT OR IGNORE INTO quality_profile_tags (quality_profile_name, tag_name)
SELECT 'FR-Films-1080p', 'Films' FROM tags t WHERE t.name = 'Films';
INSERT OR IGNORE INTO quality_profile_tags (quality_profile_name, tag_name)
SELECT 'FR-Series-4K', 'Sonarr' FROM tags t WHERE t.name = 'Sonarr';
INSERT OR IGNORE INTO quality_profile_tags (quality_profile_name, tag_name)
SELECT 'FR-Series-4K', 'Series' FROM tags t WHERE t.name = 'Series';
INSERT OR IGNORE INTO quality_profile_tags (quality_profile_name, tag_name)
SELECT 'FR-Series-1080p', 'Sonarr' FROM tags t WHERE t.name = 'Sonarr';
INSERT OR IGNORE INTO quality_profile_tags (quality_profile_name, tag_name)
SELECT 'FR-Series-1080p', 'Series' FROM tags t WHERE t.name = 'Series';
INSERT OR IGNORE INTO quality_profile_tags (quality_profile_name, tag_name)
SELECT 'FR-Series-720p', 'Sonarr' FROM tags t WHERE t.name = 'Sonarr';
INSERT OR IGNORE INTO quality_profile_tags (quality_profile_name, tag_name)
SELECT 'FR-Series-720p', 'Series' FROM tags t WHERE t.name = 'Series';
INSERT OR IGNORE INTO quality_profile_tags (quality_profile_name, tag_name)
SELECT 'FR-Anime-4K', 'Sonarr' FROM tags t WHERE t.name = 'Sonarr';
INSERT OR IGNORE INTO quality_profile_tags (quality_profile_name, tag_name)
SELECT 'FR-Anime-1080p', 'Sonarr' FROM tags t WHERE t.name = 'Sonarr';
INSERT OR IGNORE INTO quality_profile_tags (quality_profile_name, tag_name)
SELECT 'FR-Anime-720p', 'Sonarr' FROM tags t WHERE t.name = 'Sonarr';

-- Profile custom format scores
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-1080p', 'FR-MULTI-VF2', 'all', 8000
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-1080p', 'FR-MULTI-VFF', 'all', 7000
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-1080p', 'FR-MULTI-ambig', 'all', 5500
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-1080p';

INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-1080p', 'FR-VF2', 'all', 6000
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-1080p', 'FR-VFF', 'all', 5000
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-1080p', 'FR-MULTI-VFQ', 'all', 4500
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-1080p', 'FR-VFQ', 'all', 4000
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-1080p';

INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-1080p', 'FR-VOSTFR', 'all', 1500
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-1080p', 'FR-Team-QTZ', 'all', 5500
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-1080p', 'FR-Team-Neostark', 'all', 5300
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-1080p', 'FR-Team-AMEN', 'all', 5200
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-1080p', 'FR-Team-BONBON', 'all', 5000
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-1080p', 'FR-Team-TyHD', 'all', 4900
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-1080p', 'FR-Team-THESYNDiCATE', 'all', 4500
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-1080p', 'FR-Team-SUPPLY', 'all', 4800
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-1080p', 'FR-Team-BOUC', 'all', 4300
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-1080p', 'FR-Team-TFA', 'all', 4200
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-1080p', 'FR-Team-FW', 'all', 4000
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-1080p', 'FR-Team-ENIGMA', 'all', 3300
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-1080p', 'FR-Team-TOXIC', 'all', 3400
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-1080p', 'FR-Team-Slay3R', 'all', 3200
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-1080p', 'FR-Team-PopHD', 'all', 3500
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-1080p', 'FR-Team-Winks', 'all', 3600
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-1080p', 'FR-Team-OZEF', 'all', 800
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-1080p', 'FR-Team-HYPERION', 'all', 800
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-1080p', 'FR-Tier-01', 'all', 800
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-1080p', 'FR-Tier-02', 'all', 400
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-1080p', 'Atmos', 'all', 800
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-1080p', 'TrueHD', 'all', -500
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-1080p', 'FR-Audio-71', 'all', -400
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-1080p';

INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-1080p', 'DTS-X', 'all', 800
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-1080p', 'DTS-HD MA', 'all', 500
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-1080p', 'DTS-HD HRA', 'all', 350
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-1080p', 'DTS-ES', 'all', 280
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-1080p', 'DTS', 'all', 180
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-1080p', 'Dolby Digital +', 'all', 350
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-1080p', 'Dolby Digital', 'all', 80
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-1080p', 'AAC', 'all', 50
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-1080p', 'FLAC', 'all', 350
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-1080p', 'PCM', 'all', 400
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-1080p', 'Opus', 'all', 90
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-1080p', 'x265', 'all', 1000
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-1080p', 'h265', 'all', 850
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-1080p', 'VP9', 'all', -25
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-1080p', 'VVC', 'all', 60
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-1080p', 'Xvid', 'all', -80
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-1080p', 'Dolby Vision', 'all', 1200
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-1080p', 'HDR10+', 'all', 1000
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-1080p', 'HDR10', 'all', 600
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-1080p', 'HDR', 'all', 400
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-1080p', 'Season Pack', 'all', 120
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-1080p', 'FR-Streamer-Premium', 'all', 300
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-1080p', 'FR-Streamer-Standard', 'all', 180
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-1080p', 'FR-HDLight', 'all', 250
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-1080p', 'FR-Hybrid', 'all', 500
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-1080p', 'FR-Blockers', 'all', -999999
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-1080p', 'Remux', 'all', -999999
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-1080p', 'Full Disc', 'all', -999999
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-1080p', 'AV1', 'all', -999999
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-1080p', 'Upscaled', 'all', -999999
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-1080p', 'FR-Repack-3', 'all', 270
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-1080p', 'FR-Repack-2', 'all', 180
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-1080p', 'FR-Repack', 'all', 120
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-4K', 'FR-MULTI-VF2', 'all', 8000
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-4K', 'FR-MULTI-VFF', 'all', 7000
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-4K', 'FR-MULTI-ambig', 'all', 5500
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-4K';

INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-4K', 'FR-VF2', 'all', 6000
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-4K', 'FR-VFF', 'all', 5000
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-4K', 'FR-MULTI-VFQ', 'all', 4500
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-4K', 'FR-VFQ', 'all', 4000
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-4K';

INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-4K', 'FR-VOSTFR', 'all', 1500
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-4K', 'FR-Team-QTZ', 'all', 5500
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-4K', 'FR-Team-Neostark', 'all', 5300
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-4K', 'FR-Team-AMEN', 'all', 5200
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-4K', 'FR-Team-BONBON', 'all', 5000
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-4K', 'FR-Team-TyHD', 'all', 4900
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-4K', 'FR-Team-THESYNDiCATE', 'all', 4500
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-4K', 'FR-Team-SUPPLY', 'all', 4800
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-4K', 'FR-Team-BOUC', 'all', 4300
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-4K', 'FR-Team-TFA', 'all', 4200
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-4K', 'FR-Team-FW', 'all', 4000
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-4K', 'FR-Team-ENIGMA', 'all', 3300
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-4K', 'FR-Team-TOXIC', 'all', 3400
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-4K', 'FR-Team-Slay3R', 'all', 3200
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-4K', 'FR-Team-PopHD', 'all', 3500
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-4K', 'FR-Team-Winks', 'all', 3600
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-4K', 'FR-Team-OZEF', 'all', 800
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-4K', 'FR-Team-HYPERION', 'all', 800
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-4K', 'FR-Tier-01', 'all', 800
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-4K', 'FR-Tier-02', 'all', 400
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-4K', 'Dolby Vision', 'all', 3500
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-4K', 'Dolby Vision (Without Fallback)', 'all', -50
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-4K', 'HDR10+', 'all', 2200
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-4K', 'HDR10', 'all', 1300
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-4K', 'HDR', 'all', 1300
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-4K', 'Atmos', 'all', 2500
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-4K', 'TrueHD', 'all', -800
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-4K', 'FR-Audio-71', 'all', -400
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-4K';

INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-4K', 'DTS-X', 'all', 2500
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-4K', 'DTS-HD MA', 'all', 1400
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-4K', 'DTS-HD HRA', 'all', 900
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-4K', 'DTS-ES', 'all', 750
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-4K', 'DTS', 'all', 450
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-4K', 'Dolby Digital +', 'all', 500
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-4K', 'Dolby Digital', 'all', 120
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-4K', 'AAC', 'all', 60
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-4K', 'FLAC', 'all', 600
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-4K', 'PCM', 'all', 750
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-4K', 'Opus', 'all', 120
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-4K', 'x265', 'all', 1200
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-4K', 'h265', 'all', 1000
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-4K', 'VP9', 'all', -40
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-4K', 'VVC', 'all', 80
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-4K', 'Xvid', 'all', -100
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-4K', 'UHD Bluray', 'all', 800
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-4K', 'IMAX', 'all', 1500
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-4K', 'IMAX Enhanced', 'all', 1800
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-4K', 'FR-WEBRip', 'all', -750
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-4K', 'Season Pack', 'all', 150
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-4K', 'FR-Streamer-Premium', 'all', 400
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-4K', 'FR-Streamer-Standard', 'all', 250
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-4K', 'FR-4KLight', 'all', 3000
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-4K', 'FR-HDLight', 'all', 250
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-4K', 'FR-Hybrid', 'all', 1200
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-4K', 'FR-Blockers', 'all', -999999
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-4K', 'Remux', 'all', -999999
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-4K', 'Full Disc', 'all', -999999
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-4K', 'x264 (2160p)', 'all', -999999
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-4K', 'AV1', 'all', -999999
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-4K', 'Upscaled', 'all', -999999
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-4K', 'FR-Repack-3', 'all', 330
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-4K', 'FR-Repack-2', 'all', 220
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-4K', 'FR-Repack', 'all', 150
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-720p', 'FR-MULTI-VF2', 'all', 8000
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-720p', 'FR-MULTI-VFF', 'all', 7000
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-720p', 'FR-MULTI-ambig', 'all', 5500
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-720p';

INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-720p', 'FR-VF2', 'all', 6000
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-720p', 'FR-VFF', 'all', 5000
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-720p', 'FR-MULTI-VFQ', 'all', 4500
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-720p', 'FR-VFQ', 'all', 4000
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-720p';

INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-720p', 'FR-VOSTFR', 'all', 1500
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-720p', 'FR-Team-QTZ', 'all', 5500
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-720p', 'FR-Team-Neostark', 'all', 5300
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-720p', 'FR-Team-AMEN', 'all', 5200
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-720p', 'FR-Team-BONBON', 'all', 5000
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-720p', 'FR-Team-TyHD', 'all', 4900
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-720p', 'FR-Team-THESYNDiCATE', 'all', 4500
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-720p', 'FR-Team-SUPPLY', 'all', 4800
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-720p', 'FR-Team-BOUC', 'all', 4300
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-720p', 'FR-Team-TFA', 'all', 4200
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-720p', 'FR-Team-FW', 'all', 4000
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-720p', 'FR-Team-ENIGMA', 'all', 3300
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-720p', 'FR-Team-TOXIC', 'all', 3400
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-720p', 'FR-Team-Slay3R', 'all', 3200
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-720p', 'FR-Team-PopHD', 'all', 3500
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-720p', 'FR-Team-Winks', 'all', 3600
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-720p', 'FR-Team-OZEF', 'all', 800
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-720p', 'FR-Team-HYPERION', 'all', 800
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-720p', 'FR-Tier-01', 'all', 800
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-720p', 'FR-Tier-02', 'all', 400
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-720p', 'Atmos', 'all', 520
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-720p', 'TrueHD', 'all', -350
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-720p', 'FR-Audio-71', 'all', -400
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-720p';

INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-720p', 'DTS-X', 'all', 520
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-720p', 'DTS-HD MA', 'all', 325
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-720p', 'Dolby Digital +', 'all', 227
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-720p', 'Dolby Digital', 'all', 52
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-720p', 'AAC', 'all', 32
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-720p', 'FLAC', 'all', 227
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-720p', 'x265', 'all', 700
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-720p', 'h265', 'all', 600
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-720p', 'Xvid', 'all', -80
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-720p', 'Season Pack', 'all', 78
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-720p', 'FR-Streamer-Premium', 'all', 195
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-720p', 'FR-Streamer-Standard', 'all', 117
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-720p', 'FR-HDLight', 'all', 200
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-720p', 'FR-Blockers', 'all', -999999
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-720p', 'Remux', 'all', -999999
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-720p', 'Full Disc', 'all', -999999
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-720p', 'AV1', 'all', -999999
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-720p', 'Upscaled', 'all', -999999
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-720p', 'FR-Repack-3', 'all', 175
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-720p', 'FR-Repack-2', 'all', 117
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Anime-720p', 'FR-Repack', 'all', 78
FROM quality_profiles qp WHERE qp.name = 'FR-Anime-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-1080p', 'FR-MULTI-VF2', 'all', 8000
FROM quality_profiles qp WHERE qp.name = 'FR-Films-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-1080p', 'FR-MULTI-VFF', 'all', 7000
FROM quality_profiles qp WHERE qp.name = 'FR-Films-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-1080p', 'FR-MULTI-ambig', 'all', 5500
FROM quality_profiles qp WHERE qp.name = 'FR-Films-1080p';

INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-1080p', 'FR-VF2', 'all', 6000
FROM quality_profiles qp WHERE qp.name = 'FR-Films-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-1080p', 'FR-VFF', 'all', 5000
FROM quality_profiles qp WHERE qp.name = 'FR-Films-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-1080p', 'FR-MULTI-VFQ', 'all', 4500
FROM quality_profiles qp WHERE qp.name = 'FR-Films-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-1080p', 'FR-VFQ', 'all', 4000
FROM quality_profiles qp WHERE qp.name = 'FR-Films-1080p';

INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-1080p', 'FR-VOSTFR', 'all', 1500
FROM quality_profiles qp WHERE qp.name = 'FR-Films-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-1080p', 'FR-Team-QTZ', 'all', 5500
FROM quality_profiles qp WHERE qp.name = 'FR-Films-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-1080p', 'FR-Team-Neostark', 'all', 5300
FROM quality_profiles qp WHERE qp.name = 'FR-Films-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-1080p', 'FR-Team-AMEN', 'all', 5200
FROM quality_profiles qp WHERE qp.name = 'FR-Films-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-1080p', 'FR-Team-BONBON', 'all', 5000
FROM quality_profiles qp WHERE qp.name = 'FR-Films-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-1080p', 'FR-Team-TyHD', 'all', 4900
FROM quality_profiles qp WHERE qp.name = 'FR-Films-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-1080p', 'FR-Team-THESYNDiCATE', 'all', 4500
FROM quality_profiles qp WHERE qp.name = 'FR-Films-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-1080p', 'FR-Team-SUPPLY', 'all', 4800
FROM quality_profiles qp WHERE qp.name = 'FR-Films-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-1080p', 'FR-Team-BOUC', 'all', 4300
FROM quality_profiles qp WHERE qp.name = 'FR-Films-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-1080p', 'FR-Team-TFA', 'all', 4200
FROM quality_profiles qp WHERE qp.name = 'FR-Films-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-1080p', 'FR-Team-FW', 'all', 4000
FROM quality_profiles qp WHERE qp.name = 'FR-Films-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-1080p', 'FR-Team-ENIGMA', 'all', 3300
FROM quality_profiles qp WHERE qp.name = 'FR-Films-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-1080p', 'FR-Team-TOXIC', 'all', 3400
FROM quality_profiles qp WHERE qp.name = 'FR-Films-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-1080p', 'FR-Team-Slay3R', 'all', 3200
FROM quality_profiles qp WHERE qp.name = 'FR-Films-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-1080p', 'FR-Team-PopHD', 'all', 3500
FROM quality_profiles qp WHERE qp.name = 'FR-Films-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-1080p', 'FR-Team-Winks', 'all', 3600
FROM quality_profiles qp WHERE qp.name = 'FR-Films-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-1080p', 'FR-Team-OZEF', 'all', 800
FROM quality_profiles qp WHERE qp.name = 'FR-Films-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-1080p', 'FR-Team-HYPERION', 'all', 800
FROM quality_profiles qp WHERE qp.name = 'FR-Films-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-1080p', 'FR-Tier-01', 'all', 800
FROM quality_profiles qp WHERE qp.name = 'FR-Films-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-1080p', 'FR-Tier-02', 'all', 400
FROM quality_profiles qp WHERE qp.name = 'FR-Films-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-1080p', 'Atmos', 'all', 800
FROM quality_profiles qp WHERE qp.name = 'FR-Films-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-1080p', 'TrueHD', 'all', -500
FROM quality_profiles qp WHERE qp.name = 'FR-Films-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-1080p', 'FR-Audio-71', 'all', -400
FROM quality_profiles qp WHERE qp.name = 'FR-Films-1080p';

INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-1080p', 'DTS-X', 'all', 800
FROM quality_profiles qp WHERE qp.name = 'FR-Films-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-1080p', 'DTS-HD MA', 'all', 500
FROM quality_profiles qp WHERE qp.name = 'FR-Films-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-1080p', 'DTS-HD HRA', 'all', 350
FROM quality_profiles qp WHERE qp.name = 'FR-Films-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-1080p', 'DTS-ES', 'all', 280
FROM quality_profiles qp WHERE qp.name = 'FR-Films-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-1080p', 'DTS', 'all', 180
FROM quality_profiles qp WHERE qp.name = 'FR-Films-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-1080p', 'Dolby Digital +', 'all', 350
FROM quality_profiles qp WHERE qp.name = 'FR-Films-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-1080p', 'Dolby Digital', 'all', 80
FROM quality_profiles qp WHERE qp.name = 'FR-Films-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-1080p', 'AAC', 'all', 50
FROM quality_profiles qp WHERE qp.name = 'FR-Films-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-1080p', 'FLAC', 'all', 350
FROM quality_profiles qp WHERE qp.name = 'FR-Films-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-1080p', 'PCM', 'all', 400
FROM quality_profiles qp WHERE qp.name = 'FR-Films-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-1080p', 'Opus', 'all', 90
FROM quality_profiles qp WHERE qp.name = 'FR-Films-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-1080p', 'x265', 'all', 1000
FROM quality_profiles qp WHERE qp.name = 'FR-Films-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-1080p', 'h265', 'all', 850
FROM quality_profiles qp WHERE qp.name = 'FR-Films-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-1080p', 'VP9', 'all', -25
FROM quality_profiles qp WHERE qp.name = 'FR-Films-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-1080p', 'VVC', 'all', 60
FROM quality_profiles qp WHERE qp.name = 'FR-Films-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-1080p', 'Xvid', 'all', -80
FROM quality_profiles qp WHERE qp.name = 'FR-Films-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-1080p', 'Dolby Vision', 'all', 1200
FROM quality_profiles qp WHERE qp.name = 'FR-Films-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-1080p', 'Dolby Vision (Without Fallback)', 'all', -30
FROM quality_profiles qp WHERE qp.name = 'FR-Films-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-1080p', 'HDR10+', 'all', 1000
FROM quality_profiles qp WHERE qp.name = 'FR-Films-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-1080p', 'HDR10', 'all', 600
FROM quality_profiles qp WHERE qp.name = 'FR-Films-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-1080p', 'HDR', 'all', 400
FROM quality_profiles qp WHERE qp.name = 'FR-Films-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-1080p', 'IMAX', 'all', 1000
FROM quality_profiles qp WHERE qp.name = 'FR-Films-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-1080p', 'IMAX Enhanced', 'all', 1200
FROM quality_profiles qp WHERE qp.name = 'FR-Films-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-1080p', 'Theatrical', 'all', 100
FROM quality_profiles qp WHERE qp.name = 'FR-Films-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-1080p', '3D', 'all', -50
FROM quality_profiles qp WHERE qp.name = 'FR-Films-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-1080p', 'FR-Streamer-Premium', 'all', 300
FROM quality_profiles qp WHERE qp.name = 'FR-Films-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-1080p', 'FR-Streamer-Standard', 'all', 180
FROM quality_profiles qp WHERE qp.name = 'FR-Films-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-1080p', 'FR-Lourd-1080p', 'radarr', -1200
FROM quality_profiles qp WHERE qp.name = 'FR-Films-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-1080p', 'FR-Tres-Lourd-1080p', 'radarr', -1800
FROM quality_profiles qp WHERE qp.name = 'FR-Films-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-1080p', 'FR-HDLight', 'all', 250
FROM quality_profiles qp WHERE qp.name = 'FR-Films-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-1080p', 'FR-Hybrid', 'all', 500
FROM quality_profiles qp WHERE qp.name = 'FR-Films-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-1080p', 'FR-Blockers', 'all', -999999
FROM quality_profiles qp WHERE qp.name = 'FR-Films-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-1080p', 'Remux', 'all', -999999
FROM quality_profiles qp WHERE qp.name = 'FR-Films-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-1080p', 'Full Disc', 'all', -999999
FROM quality_profiles qp WHERE qp.name = 'FR-Films-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-1080p', 'AV1', 'all', -999999
FROM quality_profiles qp WHERE qp.name = 'FR-Films-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-1080p', 'Upscaled', 'all', -999999
FROM quality_profiles qp WHERE qp.name = 'FR-Films-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-1080p', 'FR-Repack-3', 'all', 270
FROM quality_profiles qp WHERE qp.name = 'FR-Films-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-1080p', 'FR-Repack-2', 'all', 180
FROM quality_profiles qp WHERE qp.name = 'FR-Films-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-1080p', 'FR-Repack', 'all', 120
FROM quality_profiles qp WHERE qp.name = 'FR-Films-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-4K', 'FR-MULTI-VF2', 'all', 8000
FROM quality_profiles qp WHERE qp.name = 'FR-Films-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-4K', 'FR-MULTI-VFF', 'all', 7000
FROM quality_profiles qp WHERE qp.name = 'FR-Films-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-4K', 'FR-MULTI-ambig', 'all', 5500
FROM quality_profiles qp WHERE qp.name = 'FR-Films-4K';

INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-4K', 'FR-VF2', 'all', 6000
FROM quality_profiles qp WHERE qp.name = 'FR-Films-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-4K', 'FR-VFF', 'all', 5000
FROM quality_profiles qp WHERE qp.name = 'FR-Films-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-4K', 'FR-MULTI-VFQ', 'all', 4500
FROM quality_profiles qp WHERE qp.name = 'FR-Films-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-4K', 'FR-VFQ', 'all', 4000
FROM quality_profiles qp WHERE qp.name = 'FR-Films-4K';

INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-4K', 'FR-VOSTFR', 'all', 1500
FROM quality_profiles qp WHERE qp.name = 'FR-Films-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-4K', 'FR-Team-QTZ', 'all', 5500
FROM quality_profiles qp WHERE qp.name = 'FR-Films-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-4K', 'FR-Team-Neostark', 'all', 5300
FROM quality_profiles qp WHERE qp.name = 'FR-Films-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-4K', 'FR-Team-AMEN', 'all', 5200
FROM quality_profiles qp WHERE qp.name = 'FR-Films-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-4K', 'FR-Team-BONBON', 'all', 5000
FROM quality_profiles qp WHERE qp.name = 'FR-Films-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-4K', 'FR-Team-TyHD', 'all', 4900
FROM quality_profiles qp WHERE qp.name = 'FR-Films-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-4K', 'FR-Team-THESYNDiCATE', 'all', 4500
FROM quality_profiles qp WHERE qp.name = 'FR-Films-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-4K', 'FR-Team-SUPPLY', 'all', 4800
FROM quality_profiles qp WHERE qp.name = 'FR-Films-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-4K', 'FR-Team-BOUC', 'all', 4300
FROM quality_profiles qp WHERE qp.name = 'FR-Films-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-4K', 'FR-Team-TFA', 'all', 4200
FROM quality_profiles qp WHERE qp.name = 'FR-Films-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-4K', 'FR-Team-FW', 'all', 4000
FROM quality_profiles qp WHERE qp.name = 'FR-Films-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-4K', 'FR-Team-ENIGMA', 'all', 3300
FROM quality_profiles qp WHERE qp.name = 'FR-Films-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-4K', 'FR-Team-TOXIC', 'all', 3400
FROM quality_profiles qp WHERE qp.name = 'FR-Films-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-4K', 'FR-Team-Slay3R', 'all', 3200
FROM quality_profiles qp WHERE qp.name = 'FR-Films-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-4K', 'FR-Team-PopHD', 'all', 3500
FROM quality_profiles qp WHERE qp.name = 'FR-Films-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-4K', 'FR-Team-Winks', 'all', 3600
FROM quality_profiles qp WHERE qp.name = 'FR-Films-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-4K', 'FR-Team-OZEF', 'all', 800
FROM quality_profiles qp WHERE qp.name = 'FR-Films-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-4K', 'FR-Team-HYPERION', 'all', 800
FROM quality_profiles qp WHERE qp.name = 'FR-Films-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-4K', 'FR-Tier-01', 'all', 800
FROM quality_profiles qp WHERE qp.name = 'FR-Films-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-4K', 'FR-Tier-02', 'all', 400
FROM quality_profiles qp WHERE qp.name = 'FR-Films-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-4K', 'Dolby Vision', 'all', 3500
FROM quality_profiles qp WHERE qp.name = 'FR-Films-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-4K', 'Dolby Vision (Without Fallback)', 'all', -50
FROM quality_profiles qp WHERE qp.name = 'FR-Films-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-4K', 'HDR10+', 'all', 2200
FROM quality_profiles qp WHERE qp.name = 'FR-Films-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-4K', 'HDR10', 'all', 1300
FROM quality_profiles qp WHERE qp.name = 'FR-Films-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-4K', 'HDR', 'all', 1300
FROM quality_profiles qp WHERE qp.name = 'FR-Films-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-4K', 'Atmos', 'all', 2500
FROM quality_profiles qp WHERE qp.name = 'FR-Films-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-4K', 'TrueHD', 'all', -800
FROM quality_profiles qp WHERE qp.name = 'FR-Films-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-4K', 'FR-Audio-71', 'all', -400
FROM quality_profiles qp WHERE qp.name = 'FR-Films-4K';

INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-4K', 'DTS-X', 'all', 2500
FROM quality_profiles qp WHERE qp.name = 'FR-Films-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-4K', 'DTS-HD MA', 'all', 1400
FROM quality_profiles qp WHERE qp.name = 'FR-Films-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-4K', 'DTS-HD HRA', 'all', 900
FROM quality_profiles qp WHERE qp.name = 'FR-Films-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-4K', 'DTS-ES', 'all', 750
FROM quality_profiles qp WHERE qp.name = 'FR-Films-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-4K', 'DTS', 'all', 450
FROM quality_profiles qp WHERE qp.name = 'FR-Films-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-4K', 'Dolby Digital +', 'all', 500
FROM quality_profiles qp WHERE qp.name = 'FR-Films-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-4K', 'Dolby Digital', 'all', 120
FROM quality_profiles qp WHERE qp.name = 'FR-Films-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-4K', 'AAC', 'all', 60
FROM quality_profiles qp WHERE qp.name = 'FR-Films-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-4K', 'FLAC', 'all', 600
FROM quality_profiles qp WHERE qp.name = 'FR-Films-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-4K', 'PCM', 'all', 750
FROM quality_profiles qp WHERE qp.name = 'FR-Films-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-4K', 'Opus', 'all', 120
FROM quality_profiles qp WHERE qp.name = 'FR-Films-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-4K', 'x265', 'all', 1200
FROM quality_profiles qp WHERE qp.name = 'FR-Films-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-4K', 'h265', 'all', 1000
FROM quality_profiles qp WHERE qp.name = 'FR-Films-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-4K', 'VP9', 'all', -40
FROM quality_profiles qp WHERE qp.name = 'FR-Films-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-4K', 'VVC', 'all', 80
FROM quality_profiles qp WHERE qp.name = 'FR-Films-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-4K', 'Xvid', 'all', -100
FROM quality_profiles qp WHERE qp.name = 'FR-Films-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-4K', 'UHD Bluray', 'all', 800
FROM quality_profiles qp WHERE qp.name = 'FR-Films-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-4K', 'IMAX', 'all', 1500
FROM quality_profiles qp WHERE qp.name = 'FR-Films-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-4K', 'IMAX Enhanced', 'all', 1800
FROM quality_profiles qp WHERE qp.name = 'FR-Films-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-4K', 'FR-WEBRip', 'all', -750
FROM quality_profiles qp WHERE qp.name = 'FR-Films-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-4K', 'Theatrical', 'all', 120
FROM quality_profiles qp WHERE qp.name = 'FR-Films-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-4K', '3D', 'all', -100
FROM quality_profiles qp WHERE qp.name = 'FR-Films-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-4K', 'FR-Streamer-Premium', 'all', 400
FROM quality_profiles qp WHERE qp.name = 'FR-Films-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-4K', 'FR-Streamer-Standard', 'all', 250
FROM quality_profiles qp WHERE qp.name = 'FR-Films-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-4K', 'FR-4KLight', 'all', 3000
FROM quality_profiles qp WHERE qp.name = 'FR-Films-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-4K', 'FR-Lourd-1080p', 'radarr', -1200
FROM quality_profiles qp WHERE qp.name = 'FR-Films-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-4K', 'FR-Tres-Lourd-1080p', 'radarr', -1800
FROM quality_profiles qp WHERE qp.name = 'FR-Films-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-4K', 'FR-HDLight', 'all', 250
FROM quality_profiles qp WHERE qp.name = 'FR-Films-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-4K', 'FR-Hybrid', 'all', 1200
FROM quality_profiles qp WHERE qp.name = 'FR-Films-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-4K', 'FR-Blockers', 'all', -999999
FROM quality_profiles qp WHERE qp.name = 'FR-Films-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-4K', 'Remux', 'all', -999999
FROM quality_profiles qp WHERE qp.name = 'FR-Films-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-4K', 'Full Disc', 'all', -999999
FROM quality_profiles qp WHERE qp.name = 'FR-Films-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-4K', 'x264 (2160p)', 'all', -999999
FROM quality_profiles qp WHERE qp.name = 'FR-Films-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-4K', 'AV1', 'all', -999999
FROM quality_profiles qp WHERE qp.name = 'FR-Films-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-4K', 'Upscaled', 'all', -999999
FROM quality_profiles qp WHERE qp.name = 'FR-Films-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-4K', 'FR-Repack-3', 'all', 330
FROM quality_profiles qp WHERE qp.name = 'FR-Films-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-4K', 'FR-Repack-2', 'all', 220
FROM quality_profiles qp WHERE qp.name = 'FR-Films-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-4K', 'FR-Repack', 'all', 150
FROM quality_profiles qp WHERE qp.name = 'FR-Films-4K';






INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-1080p', 'FR-MULTI-VF2', 'all', 8000
FROM quality_profiles qp WHERE qp.name = 'FR-Series-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-1080p', 'FR-MULTI-VFF', 'all', 7000
FROM quality_profiles qp WHERE qp.name = 'FR-Series-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-1080p', 'FR-MULTI-ambig', 'all', 5500
FROM quality_profiles qp WHERE qp.name = 'FR-Series-1080p';

INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-1080p', 'FR-VF2', 'all', 6000
FROM quality_profiles qp WHERE qp.name = 'FR-Series-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-1080p', 'FR-VFF', 'all', 5000
FROM quality_profiles qp WHERE qp.name = 'FR-Series-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-1080p', 'FR-MULTI-VFQ', 'all', 4500
FROM quality_profiles qp WHERE qp.name = 'FR-Series-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-1080p', 'FR-VFQ', 'all', 4000
FROM quality_profiles qp WHERE qp.name = 'FR-Series-1080p';

INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-1080p', 'FR-VOSTFR', 'all', 1500
FROM quality_profiles qp WHERE qp.name = 'FR-Series-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-1080p', 'FR-Team-QTZ', 'all', 5500
FROM quality_profiles qp WHERE qp.name = 'FR-Series-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-1080p', 'FR-Team-Neostark', 'all', 5300
FROM quality_profiles qp WHERE qp.name = 'FR-Series-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-1080p', 'FR-Team-AMEN', 'all', 5200
FROM quality_profiles qp WHERE qp.name = 'FR-Series-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-1080p', 'FR-Team-BONBON', 'all', 5000
FROM quality_profiles qp WHERE qp.name = 'FR-Series-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-1080p', 'FR-Team-TyHD', 'all', 4900
FROM quality_profiles qp WHERE qp.name = 'FR-Series-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-1080p', 'FR-Team-THESYNDiCATE', 'all', 4500
FROM quality_profiles qp WHERE qp.name = 'FR-Series-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-1080p', 'FR-Team-SUPPLY', 'all', 4800
FROM quality_profiles qp WHERE qp.name = 'FR-Series-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-1080p', 'FR-Team-BOUC', 'all', 4300
FROM quality_profiles qp WHERE qp.name = 'FR-Series-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-1080p', 'FR-Team-TFA', 'all', 4200
FROM quality_profiles qp WHERE qp.name = 'FR-Series-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-1080p', 'FR-Team-FW', 'all', 4000
FROM quality_profiles qp WHERE qp.name = 'FR-Series-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-1080p', 'FR-Team-ENIGMA', 'all', 3300
FROM quality_profiles qp WHERE qp.name = 'FR-Series-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-1080p', 'FR-Team-TOXIC', 'all', 3400
FROM quality_profiles qp WHERE qp.name = 'FR-Series-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-1080p', 'FR-Team-Slay3R', 'all', 3200
FROM quality_profiles qp WHERE qp.name = 'FR-Series-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-1080p', 'FR-Team-PopHD', 'all', 3500
FROM quality_profiles qp WHERE qp.name = 'FR-Series-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-1080p', 'FR-Team-Winks', 'all', 3600
FROM quality_profiles qp WHERE qp.name = 'FR-Series-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-1080p', 'FR-Team-OZEF', 'all', 800
FROM quality_profiles qp WHERE qp.name = 'FR-Series-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-1080p', 'FR-Team-HYPERION', 'all', 800
FROM quality_profiles qp WHERE qp.name = 'FR-Series-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-1080p', 'FR-Tier-01', 'all', 800
FROM quality_profiles qp WHERE qp.name = 'FR-Series-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-1080p', 'FR-Tier-02', 'all', 400
FROM quality_profiles qp WHERE qp.name = 'FR-Series-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-1080p', 'Atmos', 'all', 800
FROM quality_profiles qp WHERE qp.name = 'FR-Series-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-1080p', 'TrueHD', 'all', -500
FROM quality_profiles qp WHERE qp.name = 'FR-Series-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-1080p', 'FR-Audio-71', 'all', -400
FROM quality_profiles qp WHERE qp.name = 'FR-Series-1080p';

INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-1080p', 'DTS-X', 'all', 800
FROM quality_profiles qp WHERE qp.name = 'FR-Series-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-1080p', 'DTS-HD MA', 'all', 500
FROM quality_profiles qp WHERE qp.name = 'FR-Series-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-1080p', 'DTS-HD HRA', 'all', 350
FROM quality_profiles qp WHERE qp.name = 'FR-Series-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-1080p', 'DTS-ES', 'all', 280
FROM quality_profiles qp WHERE qp.name = 'FR-Series-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-1080p', 'DTS', 'all', 180
FROM quality_profiles qp WHERE qp.name = 'FR-Series-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-1080p', 'Dolby Digital +', 'all', 350
FROM quality_profiles qp WHERE qp.name = 'FR-Series-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-1080p', 'Dolby Digital', 'all', 80
FROM quality_profiles qp WHERE qp.name = 'FR-Series-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-1080p', 'AAC', 'all', 50
FROM quality_profiles qp WHERE qp.name = 'FR-Series-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-1080p', 'FLAC', 'all', 350
FROM quality_profiles qp WHERE qp.name = 'FR-Series-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-1080p', 'PCM', 'all', 400
FROM quality_profiles qp WHERE qp.name = 'FR-Series-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-1080p', 'Opus', 'all', 90
FROM quality_profiles qp WHERE qp.name = 'FR-Series-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-1080p', 'x265', 'all', 1000
FROM quality_profiles qp WHERE qp.name = 'FR-Series-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-1080p', 'h265', 'all', 850
FROM quality_profiles qp WHERE qp.name = 'FR-Series-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-1080p', 'VP9', 'all', -25
FROM quality_profiles qp WHERE qp.name = 'FR-Series-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-1080p', 'VVC', 'all', 60
FROM quality_profiles qp WHERE qp.name = 'FR-Series-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-1080p', 'Xvid', 'all', -80
FROM quality_profiles qp WHERE qp.name = 'FR-Series-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-1080p', 'Dolby Vision', 'all', 1200
FROM quality_profiles qp WHERE qp.name = 'FR-Series-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-1080p', 'HDR10+', 'all', 1000
FROM quality_profiles qp WHERE qp.name = 'FR-Series-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-1080p', 'HDR10', 'all', 600
FROM quality_profiles qp WHERE qp.name = 'FR-Series-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-1080p', 'HDR', 'all', 400
FROM quality_profiles qp WHERE qp.name = 'FR-Series-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-1080p', 'Season Pack', 'all', 120
FROM quality_profiles qp WHERE qp.name = 'FR-Series-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-1080p', 'FR-Streamer-Premium', 'all', 300
FROM quality_profiles qp WHERE qp.name = 'FR-Series-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-1080p', 'FR-Streamer-Standard', 'all', 180
FROM quality_profiles qp WHERE qp.name = 'FR-Series-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-1080p', 'FR-HDLight', 'all', 250
FROM quality_profiles qp WHERE qp.name = 'FR-Series-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-1080p', 'FR-Hybrid', 'all', 500
FROM quality_profiles qp WHERE qp.name = 'FR-Series-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-1080p', 'FR-Blockers', 'all', -999999
FROM quality_profiles qp WHERE qp.name = 'FR-Series-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-1080p', 'Remux', 'all', -999999
FROM quality_profiles qp WHERE qp.name = 'FR-Series-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-1080p', 'Full Disc', 'all', -999999
FROM quality_profiles qp WHERE qp.name = 'FR-Series-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-1080p', 'AV1', 'all', -999999
FROM quality_profiles qp WHERE qp.name = 'FR-Series-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-1080p', 'Upscaled', 'all', -999999
FROM quality_profiles qp WHERE qp.name = 'FR-Series-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-1080p', 'FR-Repack-3', 'all', 270
FROM quality_profiles qp WHERE qp.name = 'FR-Series-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-1080p', 'FR-Repack-2', 'all', 180
FROM quality_profiles qp WHERE qp.name = 'FR-Series-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-1080p', 'FR-Repack', 'all', 120
FROM quality_profiles qp WHERE qp.name = 'FR-Series-1080p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-4K', 'FR-MULTI-VF2', 'all', 8000
FROM quality_profiles qp WHERE qp.name = 'FR-Series-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-4K', 'FR-MULTI-VFF', 'all', 7000
FROM quality_profiles qp WHERE qp.name = 'FR-Series-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-4K', 'FR-MULTI-ambig', 'all', 5500
FROM quality_profiles qp WHERE qp.name = 'FR-Series-4K';

INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-4K', 'FR-VF2', 'all', 6000
FROM quality_profiles qp WHERE qp.name = 'FR-Series-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-4K', 'FR-VFF', 'all', 5000
FROM quality_profiles qp WHERE qp.name = 'FR-Series-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-4K', 'FR-MULTI-VFQ', 'all', 4500
FROM quality_profiles qp WHERE qp.name = 'FR-Series-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-4K', 'FR-VFQ', 'all', 4000
FROM quality_profiles qp WHERE qp.name = 'FR-Series-4K';

INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-4K', 'FR-VOSTFR', 'all', 1500
FROM quality_profiles qp WHERE qp.name = 'FR-Series-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-4K', 'FR-Team-QTZ', 'all', 5500
FROM quality_profiles qp WHERE qp.name = 'FR-Series-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-4K', 'FR-Team-Neostark', 'all', 5300
FROM quality_profiles qp WHERE qp.name = 'FR-Series-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-4K', 'FR-Team-AMEN', 'all', 5200
FROM quality_profiles qp WHERE qp.name = 'FR-Series-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-4K', 'FR-Team-BONBON', 'all', 5000
FROM quality_profiles qp WHERE qp.name = 'FR-Series-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-4K', 'FR-Team-TyHD', 'all', 4900
FROM quality_profiles qp WHERE qp.name = 'FR-Series-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-4K', 'FR-Team-THESYNDiCATE', 'all', 4500
FROM quality_profiles qp WHERE qp.name = 'FR-Series-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-4K', 'FR-Team-SUPPLY', 'all', 4800
FROM quality_profiles qp WHERE qp.name = 'FR-Series-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-4K', 'FR-Team-BOUC', 'all', 4300
FROM quality_profiles qp WHERE qp.name = 'FR-Series-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-4K', 'FR-Team-TFA', 'all', 4200
FROM quality_profiles qp WHERE qp.name = 'FR-Series-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-4K', 'FR-Team-FW', 'all', 4000
FROM quality_profiles qp WHERE qp.name = 'FR-Series-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-4K', 'FR-Team-ENIGMA', 'all', 3300
FROM quality_profiles qp WHERE qp.name = 'FR-Series-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-4K', 'FR-Team-TOXIC', 'all', 3400
FROM quality_profiles qp WHERE qp.name = 'FR-Series-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-4K', 'FR-Team-Slay3R', 'all', 3200
FROM quality_profiles qp WHERE qp.name = 'FR-Series-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-4K', 'FR-Team-PopHD', 'all', 3500
FROM quality_profiles qp WHERE qp.name = 'FR-Series-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-4K', 'FR-Team-Winks', 'all', 3600
FROM quality_profiles qp WHERE qp.name = 'FR-Series-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-4K', 'FR-Team-OZEF', 'all', 800
FROM quality_profiles qp WHERE qp.name = 'FR-Series-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-4K', 'FR-Team-HYPERION', 'all', 800
FROM quality_profiles qp WHERE qp.name = 'FR-Series-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-4K', 'FR-Tier-01', 'all', 800
FROM quality_profiles qp WHERE qp.name = 'FR-Series-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-4K', 'FR-Tier-02', 'all', 400
FROM quality_profiles qp WHERE qp.name = 'FR-Series-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-4K', 'Dolby Vision', 'all', 3500
FROM quality_profiles qp WHERE qp.name = 'FR-Series-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-4K', 'Dolby Vision (Without Fallback)', 'all', -50
FROM quality_profiles qp WHERE qp.name = 'FR-Series-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-4K', 'HDR10+', 'all', 2200
FROM quality_profiles qp WHERE qp.name = 'FR-Series-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-4K', 'HDR10', 'all', 1300
FROM quality_profiles qp WHERE qp.name = 'FR-Series-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-4K', 'HDR', 'all', 1300
FROM quality_profiles qp WHERE qp.name = 'FR-Series-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-4K', 'Atmos', 'all', 2500
FROM quality_profiles qp WHERE qp.name = 'FR-Series-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-4K', 'TrueHD', 'all', -800
FROM quality_profiles qp WHERE qp.name = 'FR-Series-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-4K', 'FR-Audio-71', 'all', -400
FROM quality_profiles qp WHERE qp.name = 'FR-Series-4K';

INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-4K', 'DTS-X', 'all', 2500
FROM quality_profiles qp WHERE qp.name = 'FR-Series-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-4K', 'DTS-HD MA', 'all', 1400
FROM quality_profiles qp WHERE qp.name = 'FR-Series-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-4K', 'DTS-HD HRA', 'all', 900
FROM quality_profiles qp WHERE qp.name = 'FR-Series-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-4K', 'DTS-ES', 'all', 750
FROM quality_profiles qp WHERE qp.name = 'FR-Series-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-4K', 'DTS', 'all', 450
FROM quality_profiles qp WHERE qp.name = 'FR-Series-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-4K', 'Dolby Digital +', 'all', 500
FROM quality_profiles qp WHERE qp.name = 'FR-Series-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-4K', 'Dolby Digital', 'all', 120
FROM quality_profiles qp WHERE qp.name = 'FR-Series-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-4K', 'AAC', 'all', 60
FROM quality_profiles qp WHERE qp.name = 'FR-Series-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-4K', 'FLAC', 'all', 600
FROM quality_profiles qp WHERE qp.name = 'FR-Series-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-4K', 'PCM', 'all', 750
FROM quality_profiles qp WHERE qp.name = 'FR-Series-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-4K', 'Opus', 'all', 120
FROM quality_profiles qp WHERE qp.name = 'FR-Series-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-4K', 'x265', 'all', 1200
FROM quality_profiles qp WHERE qp.name = 'FR-Series-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-4K', 'h265', 'all', 1000
FROM quality_profiles qp WHERE qp.name = 'FR-Series-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-4K', 'VP9', 'all', -40
FROM quality_profiles qp WHERE qp.name = 'FR-Series-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-4K', 'VVC', 'all', 80
FROM quality_profiles qp WHERE qp.name = 'FR-Series-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-4K', 'Xvid', 'all', -100
FROM quality_profiles qp WHERE qp.name = 'FR-Series-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-4K', 'UHD Bluray', 'all', 800
FROM quality_profiles qp WHERE qp.name = 'FR-Series-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-4K', 'IMAX', 'all', 1500
FROM quality_profiles qp WHERE qp.name = 'FR-Series-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-4K', 'IMAX Enhanced', 'all', 1800
FROM quality_profiles qp WHERE qp.name = 'FR-Series-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-4K', 'FR-WEBRip', 'all', -750
FROM quality_profiles qp WHERE qp.name = 'FR-Series-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-4K', 'Season Pack', 'all', 150
FROM quality_profiles qp WHERE qp.name = 'FR-Series-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-4K', 'FR-Streamer-Premium', 'all', 400
FROM quality_profiles qp WHERE qp.name = 'FR-Series-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-4K', 'FR-Streamer-Standard', 'all', 250
FROM quality_profiles qp WHERE qp.name = 'FR-Series-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-4K', 'FR-4KLight', 'all', 3000
FROM quality_profiles qp WHERE qp.name = 'FR-Series-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-4K', 'FR-HDLight', 'all', 250
FROM quality_profiles qp WHERE qp.name = 'FR-Series-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-4K', 'FR-Hybrid', 'all', 1200
FROM quality_profiles qp WHERE qp.name = 'FR-Series-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-4K', 'FR-Blockers', 'all', -999999
FROM quality_profiles qp WHERE qp.name = 'FR-Series-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-4K', 'Remux', 'all', -999999
FROM quality_profiles qp WHERE qp.name = 'FR-Series-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-4K', 'Full Disc', 'all', -999999
FROM quality_profiles qp WHERE qp.name = 'FR-Series-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-4K', 'x264 (2160p)', 'all', -999999
FROM quality_profiles qp WHERE qp.name = 'FR-Series-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-4K', 'AV1', 'all', -999999
FROM quality_profiles qp WHERE qp.name = 'FR-Series-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-4K', 'Upscaled', 'all', -999999
FROM quality_profiles qp WHERE qp.name = 'FR-Series-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-4K', 'FR-Repack-3', 'all', 330
FROM quality_profiles qp WHERE qp.name = 'FR-Series-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-4K', 'FR-Repack-2', 'all', 220
FROM quality_profiles qp WHERE qp.name = 'FR-Series-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-4K', 'FR-Repack', 'all', 150
FROM quality_profiles qp WHERE qp.name = 'FR-Series-4K';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-720p', 'FR-MULTI-VF2', 'all', 8000
FROM quality_profiles qp WHERE qp.name = 'FR-Series-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-720p', 'FR-MULTI-VFF', 'all', 7000
FROM quality_profiles qp WHERE qp.name = 'FR-Series-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-720p', 'FR-MULTI-ambig', 'all', 5500
FROM quality_profiles qp WHERE qp.name = 'FR-Series-720p';

INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-720p', 'FR-VF2', 'all', 6000
FROM quality_profiles qp WHERE qp.name = 'FR-Series-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-720p', 'FR-VFF', 'all', 5000
FROM quality_profiles qp WHERE qp.name = 'FR-Series-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-720p', 'FR-MULTI-VFQ', 'all', 4500
FROM quality_profiles qp WHERE qp.name = 'FR-Series-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-720p', 'FR-VFQ', 'all', 4000
FROM quality_profiles qp WHERE qp.name = 'FR-Series-720p';

INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-720p', 'FR-VOSTFR', 'all', 1500
FROM quality_profiles qp WHERE qp.name = 'FR-Series-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-720p', 'FR-Team-QTZ', 'all', 5500
FROM quality_profiles qp WHERE qp.name = 'FR-Series-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-720p', 'FR-Team-Neostark', 'all', 5300
FROM quality_profiles qp WHERE qp.name = 'FR-Series-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-720p', 'FR-Team-AMEN', 'all', 5200
FROM quality_profiles qp WHERE qp.name = 'FR-Series-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-720p', 'FR-Team-BONBON', 'all', 5000
FROM quality_profiles qp WHERE qp.name = 'FR-Series-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-720p', 'FR-Team-TyHD', 'all', 4900
FROM quality_profiles qp WHERE qp.name = 'FR-Series-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-720p', 'FR-Team-THESYNDiCATE', 'all', 4500
FROM quality_profiles qp WHERE qp.name = 'FR-Series-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-720p', 'FR-Team-SUPPLY', 'all', 4800
FROM quality_profiles qp WHERE qp.name = 'FR-Series-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-720p', 'FR-Team-BOUC', 'all', 4300
FROM quality_profiles qp WHERE qp.name = 'FR-Series-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-720p', 'FR-Team-TFA', 'all', 4200
FROM quality_profiles qp WHERE qp.name = 'FR-Series-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-720p', 'FR-Team-FW', 'all', 4000
FROM quality_profiles qp WHERE qp.name = 'FR-Series-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-720p', 'FR-Team-ENIGMA', 'all', 3300
FROM quality_profiles qp WHERE qp.name = 'FR-Series-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-720p', 'FR-Team-TOXIC', 'all', 3400
FROM quality_profiles qp WHERE qp.name = 'FR-Series-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-720p', 'FR-Team-Slay3R', 'all', 3200
FROM quality_profiles qp WHERE qp.name = 'FR-Series-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-720p', 'FR-Team-PopHD', 'all', 3500
FROM quality_profiles qp WHERE qp.name = 'FR-Series-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-720p', 'FR-Team-Winks', 'all', 3600
FROM quality_profiles qp WHERE qp.name = 'FR-Series-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-720p', 'FR-Team-OZEF', 'all', 800
FROM quality_profiles qp WHERE qp.name = 'FR-Series-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-720p', 'FR-Team-HYPERION', 'all', 800
FROM quality_profiles qp WHERE qp.name = 'FR-Series-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-720p', 'FR-Tier-01', 'all', 800
FROM quality_profiles qp WHERE qp.name = 'FR-Series-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-720p', 'FR-Tier-02', 'all', 400
FROM quality_profiles qp WHERE qp.name = 'FR-Series-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-720p', 'Atmos', 'all', 520
FROM quality_profiles qp WHERE qp.name = 'FR-Series-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-720p', 'TrueHD', 'all', -350
FROM quality_profiles qp WHERE qp.name = 'FR-Series-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-720p', 'FR-Audio-71', 'all', -400
FROM quality_profiles qp WHERE qp.name = 'FR-Series-720p';

INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-720p', 'DTS-X', 'all', 520
FROM quality_profiles qp WHERE qp.name = 'FR-Series-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-720p', 'DTS-HD MA', 'all', 325
FROM quality_profiles qp WHERE qp.name = 'FR-Series-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-720p', 'Dolby Digital +', 'all', 227
FROM quality_profiles qp WHERE qp.name = 'FR-Series-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-720p', 'Dolby Digital', 'all', 52
FROM quality_profiles qp WHERE qp.name = 'FR-Series-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-720p', 'AAC', 'all', 32
FROM quality_profiles qp WHERE qp.name = 'FR-Series-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-720p', 'FLAC', 'all', 227
FROM quality_profiles qp WHERE qp.name = 'FR-Series-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-720p', 'x265', 'all', 700
FROM quality_profiles qp WHERE qp.name = 'FR-Series-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-720p', 'h265', 'all', 600
FROM quality_profiles qp WHERE qp.name = 'FR-Series-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-720p', 'Xvid', 'all', -80
FROM quality_profiles qp WHERE qp.name = 'FR-Series-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-720p', 'Season Pack', 'all', 78
FROM quality_profiles qp WHERE qp.name = 'FR-Series-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-720p', 'FR-Streamer-Premium', 'all', 195
FROM quality_profiles qp WHERE qp.name = 'FR-Series-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-720p', 'FR-Streamer-Standard', 'all', 117
FROM quality_profiles qp WHERE qp.name = 'FR-Series-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-720p', 'FR-HDLight', 'all', 200
FROM quality_profiles qp WHERE qp.name = 'FR-Series-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-720p', 'FR-Blockers', 'all', -999999
FROM quality_profiles qp WHERE qp.name = 'FR-Series-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-720p', 'Remux', 'all', -999999
FROM quality_profiles qp WHERE qp.name = 'FR-Series-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-720p', 'Full Disc', 'all', -999999
FROM quality_profiles qp WHERE qp.name = 'FR-Series-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-720p', 'AV1', 'all', -999999
FROM quality_profiles qp WHERE qp.name = 'FR-Series-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-720p', 'Upscaled', 'all', -999999
FROM quality_profiles qp WHERE qp.name = 'FR-Series-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-720p', 'FR-Repack-3', 'all', 175
FROM quality_profiles qp WHERE qp.name = 'FR-Series-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-720p', 'FR-Repack-2', 'all', 117
FROM quality_profiles qp WHERE qp.name = 'FR-Series-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Series-720p', 'FR-Repack', 'all', 78
FROM quality_profiles qp WHERE qp.name = 'FR-Series-720p';

-- FR-Films-720p restauré (symétrie 720p/1080p/4K par catégorie) — profil conservé mais peu utilisé.
INSERT INTO quality_profiles (name, description, upgrades_allowed, minimum_custom_format_score, upgrade_until_score, upgrade_score_increment) VALUES ('FR-Films-720p', 'Profil Radarr 720p — trackers scène FR. Objectif : encodes compacts, langue FR, audio modéré. Priorité : langue FR + équipes FR. Exclut : Remux, Full Disc, AV1, Upscaled.', 1, 0, 60000, 500);
INSERT INTO quality_groups (quality_profile_name, name)
SELECT 'FR-Films-720p', '720p Quality' FROM quality_profiles qp WHERE qp.name = 'FR-Films-720p';
INSERT INTO quality_group_members (quality_profile_name, quality_group_name, quality_name, position)
SELECT 'FR-Films-720p', '720p Quality', q.name, 0 FROM qualities q WHERE q.name = 'Bluray-720p';
INSERT INTO quality_group_members (quality_profile_name, quality_group_name, quality_name, position)
SELECT 'FR-Films-720p', '720p Quality', q.name, 1 FROM qualities q WHERE q.name = 'WEBDL-720p';
INSERT INTO quality_group_members (quality_profile_name, quality_group_name, quality_name, position)
SELECT 'FR-Films-720p', '720p Quality', q.name, 2 FROM qualities q WHERE q.name = 'WEBRip-720p';
INSERT INTO quality_profile_qualities (quality_profile_name, quality_group_name, position, upgrade_until)
SELECT qp.name, qg.name, 0, 1
FROM quality_profiles qp, quality_groups qg
WHERE qp.name = 'FR-Films-720p' AND qg.quality_profile_name = qp.name AND qg.name = '720p Quality';
INSERT OR IGNORE INTO quality_profile_tags (quality_profile_name, tag_name)
SELECT 'FR-Films-720p', '720p' FROM tags t WHERE t.name = '720p';
INSERT OR IGNORE INTO quality_profile_tags (quality_profile_name, tag_name)
SELECT 'FR-Films-720p', 'French' FROM tags t WHERE t.name = 'French';
INSERT OR IGNORE INTO quality_profile_tags (quality_profile_name, tag_name)
SELECT 'FR-Films-720p', 'Radarr' FROM tags t WHERE t.name = 'Radarr';
INSERT OR IGNORE INTO quality_profile_tags (quality_profile_name, tag_name)
SELECT 'FR-Films-720p', 'Films' FROM tags t WHERE t.name = 'Films';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-720p', 'FR-MULTI-VF2', 'all', 8000
FROM quality_profiles qp WHERE qp.name = 'FR-Films-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-720p', 'FR-MULTI-VFF', 'all', 7000
FROM quality_profiles qp WHERE qp.name = 'FR-Films-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-720p', 'FR-MULTI-ambig', 'all', 5500
FROM quality_profiles qp WHERE qp.name = 'FR-Films-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-720p', 'FR-VF2', 'all', 6000
FROM quality_profiles qp WHERE qp.name = 'FR-Films-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-720p', 'FR-VFF', 'all', 5000
FROM quality_profiles qp WHERE qp.name = 'FR-Films-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-720p', 'FR-MULTI-VFQ', 'all', 4500
FROM quality_profiles qp WHERE qp.name = 'FR-Films-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-720p', 'FR-VFQ', 'all', 4000
FROM quality_profiles qp WHERE qp.name = 'FR-Films-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-720p', 'FR-VOSTFR', 'all', 1500
FROM quality_profiles qp WHERE qp.name = 'FR-Films-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-720p', 'FR-Team-QTZ', 'all', 5500
FROM quality_profiles qp WHERE qp.name = 'FR-Films-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-720p', 'FR-Team-Neostark', 'all', 5300
FROM quality_profiles qp WHERE qp.name = 'FR-Films-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-720p', 'FR-Team-AMEN', 'all', 5200
FROM quality_profiles qp WHERE qp.name = 'FR-Films-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-720p', 'FR-Team-BONBON', 'all', 5000
FROM quality_profiles qp WHERE qp.name = 'FR-Films-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-720p', 'FR-Team-TyHD', 'all', 4900
FROM quality_profiles qp WHERE qp.name = 'FR-Films-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-720p', 'FR-Team-THESYNDiCATE', 'all', 4500
FROM quality_profiles qp WHERE qp.name = 'FR-Films-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-720p', 'FR-Team-SUPPLY', 'all', 4800
FROM quality_profiles qp WHERE qp.name = 'FR-Films-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-720p', 'FR-Team-BOUC', 'all', 4300
FROM quality_profiles qp WHERE qp.name = 'FR-Films-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-720p', 'FR-Team-TFA', 'all', 4200
FROM quality_profiles qp WHERE qp.name = 'FR-Films-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-720p', 'FR-Team-FW', 'all', 4000
FROM quality_profiles qp WHERE qp.name = 'FR-Films-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-720p', 'FR-Team-ENIGMA', 'all', 3300
FROM quality_profiles qp WHERE qp.name = 'FR-Films-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-720p', 'FR-Team-TOXIC', 'all', 3400
FROM quality_profiles qp WHERE qp.name = 'FR-Films-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-720p', 'FR-Team-Slay3R', 'all', 3200
FROM quality_profiles qp WHERE qp.name = 'FR-Films-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-720p', 'FR-Team-PopHD', 'all', 3500
FROM quality_profiles qp WHERE qp.name = 'FR-Films-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-720p', 'FR-Team-Winks', 'all', 3600
FROM quality_profiles qp WHERE qp.name = 'FR-Films-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-720p', 'FR-Team-OZEF', 'all', 800
FROM quality_profiles qp WHERE qp.name = 'FR-Films-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-720p', 'FR-Team-HYPERION', 'all', 800
FROM quality_profiles qp WHERE qp.name = 'FR-Films-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-720p', 'FR-Tier-01', 'all', 800
FROM quality_profiles qp WHERE qp.name = 'FR-Films-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-720p', 'FR-Tier-02', 'all', 400
FROM quality_profiles qp WHERE qp.name = 'FR-Films-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-720p', 'Atmos', 'all', 520
FROM quality_profiles qp WHERE qp.name = 'FR-Films-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-720p', 'TrueHD', 'all', -350
FROM quality_profiles qp WHERE qp.name = 'FR-Films-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-720p', 'FR-Audio-71', 'all', -400
FROM quality_profiles qp WHERE qp.name = 'FR-Films-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-720p', 'DTS-X', 'all', 520
FROM quality_profiles qp WHERE qp.name = 'FR-Films-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-720p', 'DTS-HD MA', 'all', 325
FROM quality_profiles qp WHERE qp.name = 'FR-Films-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-720p', 'Dolby Digital +', 'all', 227
FROM quality_profiles qp WHERE qp.name = 'FR-Films-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-720p', 'Dolby Digital', 'all', 52
FROM quality_profiles qp WHERE qp.name = 'FR-Films-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-720p', 'AAC', 'all', 32
FROM quality_profiles qp WHERE qp.name = 'FR-Films-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-720p', 'FLAC', 'all', 227
FROM quality_profiles qp WHERE qp.name = 'FR-Films-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-720p', 'x265', 'all', 700
FROM quality_profiles qp WHERE qp.name = 'FR-Films-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-720p', 'h265', 'all', 600
FROM quality_profiles qp WHERE qp.name = 'FR-Films-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-720p', 'Xvid', 'all', -80
FROM quality_profiles qp WHERE qp.name = 'FR-Films-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-720p', 'IMAX', 'all', 650
FROM quality_profiles qp WHERE qp.name = 'FR-Films-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-720p', 'IMAX Enhanced', 'all', 845
FROM quality_profiles qp WHERE qp.name = 'FR-Films-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-720p', 'Theatrical', 'all', 65
FROM quality_profiles qp WHERE qp.name = 'FR-Films-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-720p', '3D', 'all', -50
FROM quality_profiles qp WHERE qp.name = 'FR-Films-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-720p', 'FR-Streamer-Premium', 'all', 195
FROM quality_profiles qp WHERE qp.name = 'FR-Films-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-720p', 'FR-Streamer-Standard', 'all', 117
FROM quality_profiles qp WHERE qp.name = 'FR-Films-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-720p', 'FR-HDLight', 'all', 200
FROM quality_profiles qp WHERE qp.name = 'FR-Films-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-720p', 'FR-Blockers', 'all', -999999
FROM quality_profiles qp WHERE qp.name = 'FR-Films-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-720p', 'Remux', 'all', -999999
FROM quality_profiles qp WHERE qp.name = 'FR-Films-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-720p', 'Full Disc', 'all', -999999
FROM quality_profiles qp WHERE qp.name = 'FR-Films-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-720p', 'AV1', 'all', -999999
FROM quality_profiles qp WHERE qp.name = 'FR-Films-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-720p', 'Upscaled', 'all', -999999
FROM quality_profiles qp WHERE qp.name = 'FR-Films-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-720p', 'FR-Repack-3', 'all', 175
FROM quality_profiles qp WHERE qp.name = 'FR-Films-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-720p', 'FR-Repack-2', 'all', 117
FROM quality_profiles qp WHERE qp.name = 'FR-Films-720p';
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-720p', 'FR-Repack', 'all', 78
FROM quality_profiles qp WHERE qp.name = 'FR-Films-720p';

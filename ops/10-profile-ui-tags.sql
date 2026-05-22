-- Tags UI Profilarr v2 — filtrer / retrouver les profils dans les listes

INSERT INTO tags (name) VALUES ('Radarr');
INSERT INTO tags (name) VALUES ('Sonarr');
INSERT INTO tags (name) VALUES ('Films');
INSERT INTO tags (name) VALUES ('Series');

INSERT INTO quality_profile_tags (quality_profile_name, tag_name)
SELECT 'FR-Films-4K', 'Radarr' FROM tags t WHERE t.name = 'Radarr';
INSERT INTO quality_profile_tags (quality_profile_name, tag_name)
SELECT 'FR-Films-4K', 'Films' FROM tags t WHERE t.name = 'Films';
INSERT INTO quality_profile_tags (quality_profile_name, tag_name)
SELECT 'FR-Films-1080p', 'Radarr' FROM tags t WHERE t.name = 'Radarr';
INSERT INTO quality_profile_tags (quality_profile_name, tag_name)
SELECT 'FR-Films-1080p', 'Films' FROM tags t WHERE t.name = 'Films';
INSERT INTO quality_profile_tags (quality_profile_name, tag_name)
SELECT 'FR-Films-720p', 'Radarr' FROM tags t WHERE t.name = 'Radarr';
INSERT INTO quality_profile_tags (quality_profile_name, tag_name)
SELECT 'FR-Films-720p', 'Films' FROM tags t WHERE t.name = 'Films';
INSERT INTO quality_profile_tags (quality_profile_name, tag_name)
SELECT 'FR-Films-Any', 'Radarr' FROM tags t WHERE t.name = 'Radarr';
INSERT INTO quality_profile_tags (quality_profile_name, tag_name)
SELECT 'FR-Films-Any', 'Films' FROM tags t WHERE t.name = 'Films';

INSERT INTO quality_profile_tags (quality_profile_name, tag_name)
SELECT 'FR-Series-4K', 'Sonarr' FROM tags t WHERE t.name = 'Sonarr';
INSERT INTO quality_profile_tags (quality_profile_name, tag_name)
SELECT 'FR-Series-4K', 'Series' FROM tags t WHERE t.name = 'Series';
INSERT INTO quality_profile_tags (quality_profile_name, tag_name)
SELECT 'FR-Series-1080p', 'Sonarr' FROM tags t WHERE t.name = 'Sonarr';
INSERT INTO quality_profile_tags (quality_profile_name, tag_name)
SELECT 'FR-Series-1080p', 'Series' FROM tags t WHERE t.name = 'Series';
INSERT INTO quality_profile_tags (quality_profile_name, tag_name)
SELECT 'FR-Series-720p', 'Sonarr' FROM tags t WHERE t.name = 'Sonarr';
INSERT INTO quality_profile_tags (quality_profile_name, tag_name)
SELECT 'FR-Series-720p', 'Series' FROM tags t WHERE t.name = 'Series';

INSERT INTO quality_profile_tags (quality_profile_name, tag_name)
SELECT 'FR-Anime-4K', 'Sonarr' FROM tags t WHERE t.name = 'Sonarr';
INSERT INTO quality_profile_tags (quality_profile_name, tag_name)
SELECT 'FR-Anime-4K', 'anime' FROM tags t WHERE t.name = 'anime';
INSERT INTO quality_profile_tags (quality_profile_name, tag_name)
SELECT 'FR-Anime-1080p', 'Sonarr' FROM tags t WHERE t.name = 'Sonarr';
INSERT INTO quality_profile_tags (quality_profile_name, tag_name)
SELECT 'FR-Anime-1080p', 'anime' FROM tags t WHERE t.name = 'anime';
INSERT INTO quality_profile_tags (quality_profile_name, tag_name)
SELECT 'FR-Anime-720p', 'Sonarr' FROM tags t WHERE t.name = 'Sonarr';
INSERT INTO quality_profile_tags (quality_profile_name, tag_name)
SELECT 'FR-Anime-720p', 'anime' FROM tags t WHERE t.name = 'anime';

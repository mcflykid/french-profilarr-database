-- french-profilarr-database — ops/01
-- Tags Profilarr v2 : filtres UI + liaison custom formats / profils qualité.
-- Uniquement les tags référencés dans ops/05 et ops/06 (pas de catalogue Dictionarry inutile).
--
-- Repris de Dictionarry / TRaSH (catégories CF réellement utilisées) :
--   Audio, Banned, Bleeding Edge, Codec, Colour Grade, Dolby, Edition, Enhancement,
--   Flag, HDR, Language, Release Group, Release Group Tier, Repack, Source, Storage, Streaming Service
-- Spécifique scène FR : French, 4K (4KLight)
-- Profils / UI Profilarr : résolutions, anime, tv, Radarr, Sonarr, Films, Series
-- Non importés (hors périmètre FR ou inutiles ici) :
--   Golden Popcorn, GPPi, Balanced, Compact, Efficient, Quality, Movie, HEVC, 480p,
--   marques Dumpstarr/Dictionarry/SIDCA/Scrubs, etc.

-- Résolution / profils
INSERT OR IGNORE INTO tags (name) VALUES ('1080p');
INSERT OR IGNORE INTO tags (name) VALUES ('2160p');
INSERT OR IGNORE INTO tags (name) VALUES ('4K');
INSERT OR IGNORE INTO tags (name) VALUES ('720p');
INSERT OR IGNORE INTO tags (name) VALUES ('any');

-- Scène française
INSERT OR IGNORE INTO tags (name) VALUES ('French');

-- Catégories custom formats (alignement Dictionarry / TRaSH)
INSERT OR IGNORE INTO tags (name) VALUES ('Audio');
INSERT OR IGNORE INTO tags (name) VALUES ('Banned');
INSERT OR IGNORE INTO tags (name) VALUES ('Bleeding Edge');
INSERT OR IGNORE INTO tags (name) VALUES ('Codec');
INSERT OR IGNORE INTO tags (name) VALUES ('Colour Grade');
INSERT OR IGNORE INTO tags (name) VALUES ('Dolby');
INSERT OR IGNORE INTO tags (name) VALUES ('Edition');
INSERT OR IGNORE INTO tags (name) VALUES ('Enhancement');
INSERT OR IGNORE INTO tags (name) VALUES ('Flag');
INSERT OR IGNORE INTO tags (name) VALUES ('HDR');
INSERT OR IGNORE INTO tags (name) VALUES ('Language');
INSERT OR IGNORE INTO tags (name) VALUES ('Release Group');
INSERT OR IGNORE INTO tags (name) VALUES ('Release Group Tier');
INSERT OR IGNORE INTO tags (name) VALUES ('Repack');
INSERT OR IGNORE INTO tags (name) VALUES ('Source');
INSERT OR IGNORE INTO tags (name) VALUES ('Storage');
INSERT OR IGNORE INTO tags (name) VALUES ('Streaming Service');

-- Contexte série / animé
INSERT OR IGNORE INTO tags (name) VALUES ('anime');
INSERT OR IGNORE INTO tags (name) VALUES ('tv');

-- Filtres UI Profilarr (instance + type de contenu)
INSERT OR IGNORE INTO tags (name) VALUES ('Radarr');
INSERT OR IGNORE INTO tags (name) VALUES ('Sonarr');
INSERT OR IGNORE INTO tags (name) VALUES ('Films');
INSERT OR IGNORE INTO tags (name) VALUES ('Series');

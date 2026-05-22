-- french-profilarr-database — ops/01
-- Tags Profilarr v2 : filtres UI + liaison custom formats / profils qualité.
-- Tags requis par ops/05 et ops/06 (pas de tags catalogue inutilisés)
-- par les futurs ops/05 et ops/06 (pas de copie intégrale des tags « catalogue » inutilisés).

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

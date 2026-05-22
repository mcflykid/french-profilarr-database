-- Fichier 12 : simulations profil qualité (optionnel)

-- =============================================================================
-- Film : La Momie (1999) — TMDB 564 — référence FR-Films-4K
-- Attendu avec FR-Films-4K (scores ops/06) : QTZ 4KLight ≈ Slay3R WEB > TyHD > Remux/AV1 exclus
-- =============================================================================
INSERT INTO test_entities (type, tmdb_id, title, year) VALUES ('movie', 564, 'La Momie', 1999);

INSERT INTO test_releases (entity_type, entity_tmdb_id, title, size_bytes, languages, indexers, flags)
VALUES (
    'movie', 564,
    'La.Momie.1999.MULTI.VFF.2160p.BluRay.4KLight.HDR10Plus.TrueHD.7.1.Atmos.x265-QTZ',
    15032385536,
    '[]', '[]', '[]'
);

INSERT INTO test_releases (entity_type, entity_tmdb_id, title, size_bytes, languages, indexers, flags)
VALUES (
    'movie', 564,
    'La.Momie.1999.MULTI.VFF.2160p.WEB.DV.HDR10PLUS.AC3.5.1.H265-Slay3R',
    12884901888,
    '[]', '[]', '[]'
);

INSERT INTO test_releases (entity_type, entity_tmdb_id, title, size_bytes, languages, indexers, flags)
VALUES (
    'movie', 564,
    'La.Momie.1999.MULTI.VFF.2160p.WEB.DV.HDR10PLUS.AC3.5.1.H265-TyHD',
    10737418240,
    '[]', '[]', '[]'
);

INSERT INTO test_releases (entity_type, entity_tmdb_id, title, size_bytes, languages, indexers, flags)
VALUES (
    'movie', 564,
    'The.Mummy.1999.2160p.UHD.BluRay.Remux.TrueHD.7.1.Atmos.HDR.x265-GROUP',
    53687091200,
    '[]', '[]', '[]'
);

INSERT INTO test_releases (entity_type, entity_tmdb_id, title, size_bytes, languages, indexers, flags)
VALUES (
    'movie', 564,
    'La.Momie.1999.MULTI.VFF.2160p.WEBRiP.DV.HDR.EAC3.5.1.AV1-THESYNDiCATE',
    8589934592,
    '[]', '[]', '[]'
);

-- =============================================================================
-- Série : Person of Interest — TMDB 1411 — langue MULTI.FRENCH
-- Attendu FR-Series-1080p : DELIRIUS MULTI.FRENCH > Remux épisode
-- =============================================================================
INSERT INTO test_entities (type, tmdb_id, title, year) VALUES ('series', 1411, 'Person of Interest', 2011);

INSERT INTO test_releases (entity_type, entity_tmdb_id, title, size_bytes, languages, indexers, flags)
VALUES (
    'series', 1411,
    'Person.Of.Interest.S05.MULTI.FRENCH.1080p.WEBRip.x265-DELIRIUS',
    2147483648,
    '[]', '[]', '[]'
);

INSERT INTO test_releases (entity_type, entity_tmdb_id, title, size_bytes, languages, indexers, flags)
VALUES (
    'series', 1411,
    'Person.of.Interest.S05E01.1080p.BluRay.Remux.TrueHD.5.1.x264-GROUP',
    5368709120,
    '[]', '[]', '[]'
);

-- =============================================================================
-- Animé : Demon Slayer — TMDB 85937 — FR-Anime-1080p
-- Attendu : WEB Crunchyroll MULTI VFF > Remux
-- =============================================================================
INSERT INTO test_entities (type, tmdb_id, title, year) VALUES ('series', 85937, 'Demon Slayer', 2019);

INSERT INTO test_releases (entity_type, entity_tmdb_id, title, size_bytes, languages, indexers, flags)
VALUES (
    'series', 85937,
    'Kimetsu.no.Yaiba.S04E01.MULTI.VFF.1080p.CR.WEB-DL.EAC3.2.0.x264-GROUP',
    1610612736,
    '[]', '[]', '[]'
);

INSERT INTO test_releases (entity_type, entity_tmdb_id, title, size_bytes, languages, indexers, flags)
VALUES (
    'series', 85937,
    'Kimetsu.no.Yaiba.S04E01.1080p.CR.WEB-DL.Remux.FLAC.2.0.x264-GROUP',
    8589934592,
    '[]', '[]', '[]'
);

-- =============================================================================
-- Film : Incendies (2010) — TMDB 41283 — langue VOQ sans MULTI
-- Attendu parser : FR-VF2 oui ; FR-MULTI-VF2 non ; FR-MULTI-VFF non
-- (vérifier aussi dans ops/11-custom-format-tests.sql)
-- =============================================================================
INSERT INTO test_entities (type, tmdb_id, title, year) VALUES ('movie', 41283, 'Incendies', 2010);

INSERT INTO test_releases (entity_type, entity_tmdb_id, title, size_bytes, languages, indexers, flags)
VALUES (
    'movie', 41283,
    'Incendies.2010.VOQ.2160p.BluRay.DDP.x265-QTZ',
    12884901888,
    '[]', '[]', '[]'
);

INSERT INTO test_releases (entity_type, entity_tmdb_id, title, size_bytes, languages, indexers, flags)
VALUES (
    'movie', 41283,
    'Incendies.2010.MULTI.VOQ.2160p.BluRay.DDP.x265-QTZ',
    13958643712,
    '[]', '[]', '[]'
);

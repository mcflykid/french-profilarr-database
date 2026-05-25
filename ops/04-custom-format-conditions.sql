-- french-profilarr-database — ops/04
-- Conditions CF (regex, release_title, langue, qualité, négations « Exclure : »).

INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT '3D', '3D', 'release_title', 'all', 0, 1
FROM custom_formats cf WHERE cf.name = '3D';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'AAC', 'AAC', 'release_title', 'all', 0, 1
FROM custom_formats cf WHERE cf.name = 'AAC';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'AAC', 'Exclure : Dolby Digital', 'release_title', 'all', 1, 1
FROM custom_formats cf WHERE cf.name = 'AAC';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'AAC', 'Exclure : Dolby Digital+', 'release_title', 'all', 1, 1
FROM custom_formats cf WHERE cf.name = 'AAC';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'AAC', 'Exclure : DTS', 'release_title', 'all', 1, 1
FROM custom_formats cf WHERE cf.name = 'AAC';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'AAC', 'Exclure : FLAC', 'release_title', 'all', 1, 1
FROM custom_formats cf WHERE cf.name = 'AAC';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'AAC', 'Exclure : PCM', 'release_title', 'all', 1, 1
FROM custom_formats cf WHERE cf.name = 'AAC';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'AAC', 'Exclure : TrueHD', 'release_title', 'all', 1, 1
FROM custom_formats cf WHERE cf.name = 'AAC';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'AV1', 'AV1', 'release_title', 'all', 0, 1
FROM custom_formats cf WHERE cf.name = 'AV1';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'Atmos', 'Atmos (regroupement)', 'release_title', 'all', 0, 1
FROM custom_formats cf WHERE cf.name = 'Atmos';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'DTS-ES', 'DTS-ES', 'release_title', 'all', 0, 1
FROM custom_formats cf WHERE cf.name = 'DTS-ES';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'DTS-ES', 'Exclure : AAC', 'release_title', 'all', 1, 1
FROM custom_formats cf WHERE cf.name = 'DTS-ES';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'DTS-ES', 'Exclure : Dolby Digital', 'release_title', 'all', 1, 1
FROM custom_formats cf WHERE cf.name = 'DTS-ES';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'DTS-ES', 'Exclure : Dolby Digital+', 'release_title', 'all', 1, 1
FROM custom_formats cf WHERE cf.name = 'DTS-ES';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'DTS-ES', 'Exclure : DTS', 'release_title', 'all', 1, 1
FROM custom_formats cf WHERE cf.name = 'DTS-ES';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'DTS-ES', 'Exclure : DTS-X', 'release_title', 'all', 1, 1
FROM custom_formats cf WHERE cf.name = 'DTS-ES';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'DTS-ES', 'Exclure : FLAC', 'release_title', 'all', 1, 1
FROM custom_formats cf WHERE cf.name = 'DTS-ES';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'DTS-ES', 'Exclure : PCM', 'release_title', 'all', 1, 1
FROM custom_formats cf WHERE cf.name = 'DTS-ES';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'DTS-ES', 'Exclure : TrueHD', 'release_title', 'all', 1, 1
FROM custom_formats cf WHERE cf.name = 'DTS-ES';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'DTS-HD HRA', 'DTS-HD HRA', 'release_title', 'all', 0, 1
FROM custom_formats cf WHERE cf.name = 'DTS-HD HRA';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'DTS-HD HRA', 'Exclure : AAC', 'release_title', 'all', 1, 1
FROM custom_formats cf WHERE cf.name = 'DTS-HD HRA';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'DTS-HD HRA', 'Exclure : Dolby Digital', 'release_title', 'all', 1, 1
FROM custom_formats cf WHERE cf.name = 'DTS-HD HRA';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'DTS-HD HRA', 'Exclure : Dolby Digital+', 'release_title', 'all', 1, 1
FROM custom_formats cf WHERE cf.name = 'DTS-HD HRA';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'DTS-HD HRA', 'Exclure : DTS', 'release_title', 'all', 1, 1
FROM custom_formats cf WHERE cf.name = 'DTS-HD HRA';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'DTS-HD HRA', 'Exclure : DTS-ES', 'release_title', 'all', 1, 1
FROM custom_formats cf WHERE cf.name = 'DTS-HD HRA';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'DTS-HD HRA', 'Exclure : DTS-X', 'release_title', 'all', 1, 1
FROM custom_formats cf WHERE cf.name = 'DTS-HD HRA';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'DTS-HD HRA', 'Exclure : FLAC', 'release_title', 'all', 1, 1
FROM custom_formats cf WHERE cf.name = 'DTS-HD HRA';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'DTS-HD HRA', 'Exclure : PCM', 'release_title', 'all', 1, 1
FROM custom_formats cf WHERE cf.name = 'DTS-HD HRA';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'DTS-HD HRA', 'Exclure : TrueHD', 'release_title', 'all', 1, 1
FROM custom_formats cf WHERE cf.name = 'DTS-HD HRA';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'DTS-HD MA', 'DTS-HD MA', 'release_title', 'all', 0, 1
FROM custom_formats cf WHERE cf.name = 'DTS-HD MA';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'DTS-HD MA', 'Exclure : AAC', 'release_title', 'all', 1, 1
FROM custom_formats cf WHERE cf.name = 'DTS-HD MA';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'DTS-HD MA', 'Exclure : Dolby Digital', 'release_title', 'all', 1, 1
FROM custom_formats cf WHERE cf.name = 'DTS-HD MA';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'DTS-HD MA', 'Exclure : Dolby Digital+', 'release_title', 'all', 1, 1
FROM custom_formats cf WHERE cf.name = 'DTS-HD MA';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'DTS-HD MA', 'Exclure : DTS-HD HRA/ES', 'release_title', 'all', 1, 1
FROM custom_formats cf WHERE cf.name = 'DTS-HD MA';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'DTS-HD MA', 'Exclure : DTS-X', 'release_title', 'all', 1, 1
FROM custom_formats cf WHERE cf.name = 'DTS-HD MA';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'DTS-HD MA', 'Exclure : FLAC', 'release_title', 'all', 1, 1
FROM custom_formats cf WHERE cf.name = 'DTS-HD MA';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'DTS-HD MA', 'Exclure : PCM', 'release_title', 'all', 1, 1
FROM custom_formats cf WHERE cf.name = 'DTS-HD MA';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'DTS-HD MA', 'Exclure : TrueHD', 'release_title', 'all', 1, 1
FROM custom_formats cf WHERE cf.name = 'DTS-HD MA';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'DTS-X', 'DTS-X', 'release_title', 'all', 0, 1
FROM custom_formats cf WHERE cf.name = 'DTS-X';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'DTS-X', 'Exclure : AAC', 'release_title', 'all', 1, 1
FROM custom_formats cf WHERE cf.name = 'DTS-X';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'DTS-X', 'Exclure : Dolby Digital', 'release_title', 'all', 1, 1
FROM custom_formats cf WHERE cf.name = 'DTS-X';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'DTS-X', 'Exclure : Dolby Digital+', 'release_title', 'all', 1, 1
FROM custom_formats cf WHERE cf.name = 'DTS-X';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'DTS-X', 'Exclure : DTS', 'release_title', 'all', 1, 1
FROM custom_formats cf WHERE cf.name = 'DTS-X';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'DTS-X', 'Exclure : FLAC', 'release_title', 'all', 1, 1
FROM custom_formats cf WHERE cf.name = 'DTS-X';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'DTS-X', 'Exclure : PCM', 'release_title', 'all', 1, 1
FROM custom_formats cf WHERE cf.name = 'DTS-X';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'DTS-X', 'Exclure : TrueHD', 'release_title', 'all', 1, 1
FROM custom_formats cf WHERE cf.name = 'DTS-X';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'DTS', 'DTS', 'release_title', 'all', 0, 1
FROM custom_formats cf WHERE cf.name = 'DTS';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'DTS', 'Exclure : AAC', 'release_title', 'all', 1, 1
FROM custom_formats cf WHERE cf.name = 'DTS';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'DTS', 'Exclure : Dolby Digital', 'release_title', 'all', 1, 1
FROM custom_formats cf WHERE cf.name = 'DTS';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'DTS', 'Exclure : Dolby Digital+', 'release_title', 'all', 1, 1
FROM custom_formats cf WHERE cf.name = 'DTS';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'DTS', 'Exclure : DTS-HD', 'release_title', 'all', 1, 1
FROM custom_formats cf WHERE cf.name = 'DTS';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'DTS', 'Exclure : DTS-HD HRA/ES', 'release_title', 'all', 1, 1
FROM custom_formats cf WHERE cf.name = 'DTS';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'DTS', 'Exclure : DTS-X', 'release_title', 'all', 1, 1
FROM custom_formats cf WHERE cf.name = 'DTS';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'DTS', 'Exclure : FLAC', 'release_title', 'all', 1, 1
FROM custom_formats cf WHERE cf.name = 'DTS';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'DTS', 'Exclure : PCM', 'release_title', 'all', 1, 1
FROM custom_formats cf WHERE cf.name = 'DTS';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'DTS', 'Exclure : TrueHD', 'release_title', 'all', 1, 1
FROM custom_formats cf WHERE cf.name = 'DTS';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'Dolby Digital +', 'Dolby Digital +', 'release_title', 'all', 0, 1
FROM custom_formats cf WHERE cf.name = 'Dolby Digital +';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'Dolby Digital +', 'Exclure : AAC', 'release_title', 'all', 1, 1
FROM custom_formats cf WHERE cf.name = 'Dolby Digital +';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'Dolby Digital +', 'Exclure : DTS', 'release_title', 'all', 1, 1
FROM custom_formats cf WHERE cf.name = 'Dolby Digital +';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'Dolby Digital +', 'Exclure : FLAC', 'release_title', 'all', 1, 1
FROM custom_formats cf WHERE cf.name = 'Dolby Digital +';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'Dolby Digital +', 'Exclure : PCM', 'release_title', 'all', 1, 1
FROM custom_formats cf WHERE cf.name = 'Dolby Digital +';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'Dolby Digital +', 'Exclure : TrueHD', 'release_title', 'all', 1, 1
FROM custom_formats cf WHERE cf.name = 'Dolby Digital +';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'Dolby Digital', 'Dolby Digital', 'release_title', 'all', 0, 1
FROM custom_formats cf WHERE cf.name = 'Dolby Digital';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'Dolby Digital', 'Exclure : AAC', 'release_title', 'all', 1, 1
FROM custom_formats cf WHERE cf.name = 'Dolby Digital';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'Dolby Digital', 'Exclure : Dolby Digital+', 'release_title', 'all', 1, 1
FROM custom_formats cf WHERE cf.name = 'Dolby Digital';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'Dolby Digital', 'Exclure : DTS', 'release_title', 'all', 1, 1
FROM custom_formats cf WHERE cf.name = 'Dolby Digital';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'Dolby Digital', 'Exclure : FLAC', 'release_title', 'all', 1, 1
FROM custom_formats cf WHERE cf.name = 'Dolby Digital';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'Dolby Digital', 'Exclure : PCM', 'release_title', 'all', 1, 1
FROM custom_formats cf WHERE cf.name = 'Dolby Digital';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'Dolby Digital', 'Exclure : TrueHD', 'release_title', 'all', 1, 1
FROM custom_formats cf WHERE cf.name = 'Dolby Digital';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'Dolby Vision (Without Fallback)', 'Dolby Vision (Without Fallback)', 'release_title', 'all', 0, 1
FROM custom_formats cf WHERE cf.name = 'Dolby Vision (Without Fallback)';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'Dolby Vision', 'Dolby Vision', 'release_title', 'all', 0, 1
FROM custom_formats cf WHERE cf.name = 'Dolby Vision';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'FLAC', 'FLAC', 'release_title', 'all', 0, 1
FROM custom_formats cf WHERE cf.name = 'FLAC';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'FLAC', 'Exclure : AAC', 'release_title', 'all', 1, 1
FROM custom_formats cf WHERE cf.name = 'FLAC';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'FLAC', 'Exclure : Dolby Digital', 'release_title', 'all', 1, 1
FROM custom_formats cf WHERE cf.name = 'FLAC';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'FLAC', 'Exclure : Dolby Digital+', 'release_title', 'all', 1, 1
FROM custom_formats cf WHERE cf.name = 'FLAC';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'FLAC', 'Exclure : DTS', 'release_title', 'all', 1, 1
FROM custom_formats cf WHERE cf.name = 'FLAC';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'FLAC', 'Exclure : PCM', 'release_title', 'all', 1, 1
FROM custom_formats cf WHERE cf.name = 'FLAC';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'FLAC', 'Exclure : TrueHD', 'release_title', 'all', 1, 1
FROM custom_formats cf WHERE cf.name = 'FLAC';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'FR-4KLight', '4KLight', 'release_title', 'all', 0, 1
FROM custom_formats cf WHERE cf.name = 'FR-4KLight';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'FR-Blockers', 'Liste noire scène FR', 'release_title', 'all', 0, 1
FROM custom_formats cf WHERE cf.name = 'FR-Blockers';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'FR-HDLight', 'HDLight', 'release_title', 'all', 0, 1
FROM custom_formats cf WHERE cf.name = 'FR-HDLight';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'FR-Hybrid', 'HYBRID', 'release_title', 'all', 0, 1
FROM custom_formats cf WHERE cf.name = 'FR-Hybrid';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'FR-MULTI-VF2', 'MULTI', 'release_title', 'all', 0, 1
FROM custom_formats cf WHERE cf.name = 'FR-MULTI-VF2';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'FR-MULTI-VF2', 'VF2', 'release_title', 'all', 0, 1
FROM custom_formats cf WHERE cf.name = 'FR-MULTI-VF2';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'FR-MULTI-VFQ', 'MULTI', 'release_title', 'all', 0, 1
FROM custom_formats cf WHERE cf.name = 'FR-MULTI-VFQ';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'FR-MULTI-VFQ', 'VFQ', 'release_title', 'all', 0, 1
FROM custom_formats cf WHERE cf.name = 'FR-MULTI-VFQ';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'FR-MULTI-VFF', 'MULTI + tag FR C411', 'release_title', 'all', 0, 1
FROM custom_formats cf WHERE cf.name = 'FR-MULTI-VFF';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'FR-MULTI-ambig', 'MULTI sans précision FR', 'release_title', 'all', 0, 1
FROM custom_formats cf WHERE cf.name = 'FR-MULTI-ambig';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'FR-VFF', 'Pas de tag MULTI', 'release_title', 'all', 1, 1
FROM custom_formats cf WHERE cf.name = 'FR-VFF';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'FR-Repack-2', 'Repack — 2e itération', 'release_title', 'all', 0, 1
FROM custom_formats cf WHERE cf.name = 'FR-Repack-2';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'FR-Repack-3', 'Repack — 3e itération', 'release_title', 'all', 0, 1
FROM custom_formats cf WHERE cf.name = 'FR-Repack-3';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'FR-Repack', 'Repack', 'release_title', 'all', 0, 1
FROM custom_formats cf WHERE cf.name = 'FR-Repack';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'FR-WEBRip', 'WEBRip dans le titre', 'release_title', 'all', 0, 1
FROM custom_formats cf WHERE cf.name = 'FR-WEBRip';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'FR-Audio-71', '7.1 dans le titre', 'release_title', 'all', 0, 1
FROM custom_formats cf WHERE cf.name = 'FR-Audio-71';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'FR-Streamer-Premium', 'Streamers premium (regex FR)', 'release_title', 'all', 0, 1
FROM custom_formats cf WHERE cf.name = 'FR-Streamer-Premium';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'FR-Streamer-Standard', 'Streamers standard (regex FR)', 'release_title', 'all', 0, 1
FROM custom_formats cf WHERE cf.name = 'FR-Streamer-Standard';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'FR-Team-AMEN', 'AMEN', 'release_title', 'all', 0, 0
FROM custom_formats cf WHERE cf.name = 'FR-Team-AMEN';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'FR-Team-AMEN', 'AMEN Group', 'release_group', 'all', 0, 0
FROM custom_formats cf WHERE cf.name = 'FR-Team-AMEN';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'FR-Team-BONBON', 'BONBON', 'release_title', 'all', 0, 0
FROM custom_formats cf WHERE cf.name = 'FR-Team-BONBON';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'FR-Team-BONBON', 'BONBON Group', 'release_group', 'all', 0, 0
FROM custom_formats cf WHERE cf.name = 'FR-Team-BONBON';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'FR-Team-BOUC', 'BOUC', 'release_title', 'all', 0, 0
FROM custom_formats cf WHERE cf.name = 'FR-Team-BOUC';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'FR-Team-BOUC', 'BOUC Group', 'release_group', 'all', 0, 0
FROM custom_formats cf WHERE cf.name = 'FR-Team-BOUC';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'FR-Team-ENIGMA', 'ENIGMA', 'release_title', 'all', 0, 0
FROM custom_formats cf WHERE cf.name = 'FR-Team-ENIGMA';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'FR-Team-ENIGMA', 'ENIGMA Group', 'release_group', 'all', 0, 0
FROM custom_formats cf WHERE cf.name = 'FR-Team-ENIGMA';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'FR-Team-FW', 'FW', 'release_title', 'all', 0, 0
FROM custom_formats cf WHERE cf.name = 'FR-Team-FW';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'FR-Team-FW', 'FW Group', 'release_group', 'all', 0, 0
FROM custom_formats cf WHERE cf.name = 'FR-Team-FW';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'FR-Team-HYPERION', 'HYPERION', 'release_title', 'all', 0, 0
FROM custom_formats cf WHERE cf.name = 'FR-Team-HYPERION';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'FR-Team-HYPERION', 'HYPERION Group', 'release_group', 'all', 0, 0
FROM custom_formats cf WHERE cf.name = 'FR-Team-HYPERION';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'FR-Team-OZEF', 'OZEF', 'release_title', 'all', 0, 0
FROM custom_formats cf WHERE cf.name = 'FR-Team-OZEF';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'FR-Team-OZEF', 'OZEF Group', 'release_group', 'all', 0, 0
FROM custom_formats cf WHERE cf.name = 'FR-Team-OZEF';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'FR-Team-PopHD', 'PopHD', 'release_title', 'all', 0, 0
FROM custom_formats cf WHERE cf.name = 'FR-Team-PopHD';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'FR-Team-PopHD', 'PopHD Group', 'release_group', 'all', 0, 0
FROM custom_formats cf WHERE cf.name = 'FR-Team-PopHD';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'FR-Team-QTZ', 'QTZ', 'release_title', 'all', 0, 0
FROM custom_formats cf WHERE cf.name = 'FR-Team-QTZ';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'FR-Team-QTZ', 'QTZ Group', 'release_group', 'all', 0, 0
FROM custom_formats cf WHERE cf.name = 'FR-Team-QTZ';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'FR-Team-SUPPLY', 'SUPPLY', 'release_title', 'all', 0, 0
FROM custom_formats cf WHERE cf.name = 'FR-Team-SUPPLY';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'FR-Team-SUPPLY', 'SUPPLY Group', 'release_group', 'all', 0, 0
FROM custom_formats cf WHERE cf.name = 'FR-Team-SUPPLY';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'FR-Team-Slay3R', 'Slay3R', 'release_title', 'all', 0, 0
FROM custom_formats cf WHERE cf.name = 'FR-Team-Slay3R';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'FR-Team-Slay3R', 'Slay3R Group', 'release_group', 'all', 0, 0
FROM custom_formats cf WHERE cf.name = 'FR-Team-Slay3R';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'FR-Team-TFA', 'TFA', 'release_title', 'all', 0, 0
FROM custom_formats cf WHERE cf.name = 'FR-Team-TFA';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'FR-Team-TFA', 'TFA Group', 'release_group', 'all', 0, 0
FROM custom_formats cf WHERE cf.name = 'FR-Team-TFA';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'FR-Team-THESYNDiCATE', 'THESYNDiCATE', 'release_title', 'all', 0, 0
FROM custom_formats cf WHERE cf.name = 'FR-Team-THESYNDiCATE';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'FR-Team-THESYNDiCATE', 'THESYNDiCATE Group', 'release_group', 'all', 0, 0
FROM custom_formats cf WHERE cf.name = 'FR-Team-THESYNDiCATE';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'FR-Team-TOXIC', 'TOXIC', 'release_title', 'all', 0, 0
FROM custom_formats cf WHERE cf.name = 'FR-Team-TOXIC';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'FR-Team-TOXIC', 'TOXIC Group', 'release_group', 'all', 0, 0
FROM custom_formats cf WHERE cf.name = 'FR-Team-TOXIC';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'FR-Team-TyHD', 'TyHD', 'release_title', 'all', 0, 0
FROM custom_formats cf WHERE cf.name = 'FR-Team-TyHD';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'FR-Team-TyHD', 'TyHD Group', 'release_group', 'all', 0, 0
FROM custom_formats cf WHERE cf.name = 'FR-Team-TyHD';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'FR-Team-Winks', 'Winks', 'release_title', 'all', 0, 0
FROM custom_formats cf WHERE cf.name = 'FR-Team-Winks';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'FR-Team-Winks', 'Winks Group', 'release_group', 'all', 0, 0
FROM custom_formats cf WHERE cf.name = 'FR-Team-Winks';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'FR-Tier-01', 'Palier 01 — longue traîne haute', 'release_title', 'all', 0, 1
FROM custom_formats cf WHERE cf.name = 'FR-Tier-01';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'FR-Tier-02', 'Palier 02 — longue traîne basse', 'release_title', 'all', 0, 1
FROM custom_formats cf WHERE cf.name = 'FR-Tier-02';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'FR-VF2', 'VF2', 'release_title', 'all', 0, 1
FROM custom_formats cf WHERE cf.name = 'FR-VF2';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'FR-VFQ', 'Pas de tag MULTI', 'release_title', 'all', 1, 1
FROM custom_formats cf WHERE cf.name = 'FR-VFQ';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'FR-VFQ', 'VFQ', 'release_title', 'all', 0, 1
FROM custom_formats cf WHERE cf.name = 'FR-VFQ';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'FR-VFF', 'VFF', 'release_title', 'all', 0, 1
FROM custom_formats cf WHERE cf.name = 'FR-VFF';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'FR-VOSTFR', 'VOSTFR', 'release_title', 'all', 0, 1
FROM custom_formats cf WHERE cf.name = 'FR-VOSTFR';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'Full Disc', 'Full Disc', 'release_title', 'all', 0, 1
FROM custom_formats cf WHERE cf.name = 'Full Disc';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'Full Disc', 'Exclure : source WEB-DL', 'source', 'all', 1, 1
FROM custom_formats cf WHERE cf.name = 'Full Disc';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'Full Disc', 'Exclure : source WEBRip', 'source', 'all', 1, 1
FROM custom_formats cf WHERE cf.name = 'Full Disc';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'Full Disc', 'Exclure : Remux', 'release_title', 'all', 1, 1
FROM custom_formats cf WHERE cf.name = 'Full Disc';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'Full Disc', 'Exclure : x264', 'release_title', 'all', 1, 1
FROM custom_formats cf WHERE cf.name = 'Full Disc';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'Full Disc', 'Exclure : x265', 'release_title', 'all', 1, 1
FROM custom_formats cf WHERE cf.name = 'Full Disc';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'HDR', 'HDR', 'release_title', 'all', 0, 1
FROM custom_formats cf WHERE cf.name = 'HDR';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'HDR', 'Exclure : SDR', 'release_title', 'all', 1, 1
FROM custom_formats cf WHERE cf.name = 'HDR';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'HDR', 'Exclure : PQ', 'release_title', 'all', 1, 1
FROM custom_formats cf WHERE cf.name = 'HDR';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'HDR', 'Exclure : HLG', 'release_title', 'all', 1, 1
FROM custom_formats cf WHERE cf.name = 'HDR';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'HDR', 'Exclure : HDR10', 'release_title', 'all', 1, 1
FROM custom_formats cf WHERE cf.name = 'HDR';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'HDR', 'Exclure : HDR10+', 'release_title', 'all', 1, 1
FROM custom_formats cf WHERE cf.name = 'HDR';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'HDR10+', 'HDR10+', 'release_title', 'all', 0, 1
FROM custom_formats cf WHERE cf.name = 'HDR10+';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'HDR10+', 'Exclure : SDR', 'release_title', 'all', 1, 1
FROM custom_formats cf WHERE cf.name = 'HDR10+';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'HDR10+', 'Exclure : PQ', 'release_title', 'all', 1, 1
FROM custom_formats cf WHERE cf.name = 'HDR10+';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'HDR10+', 'Exclure : HLG', 'release_title', 'all', 1, 1
FROM custom_formats cf WHERE cf.name = 'HDR10+';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'HDR10', 'HDR10', 'release_title', 'all', 0, 1
FROM custom_formats cf WHERE cf.name = 'HDR10';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'HDR10', 'Exclure : SDR', 'release_title', 'all', 1, 1
FROM custom_formats cf WHERE cf.name = 'HDR10';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'HDR10', 'Exclure : PQ', 'release_title', 'all', 1, 1
FROM custom_formats cf WHERE cf.name = 'HDR10';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'HDR10', 'Exclure : HLG', 'release_title', 'all', 1, 1
FROM custom_formats cf WHERE cf.name = 'HDR10';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'HDR10', 'Exclure : HDR10+', 'release_title', 'all', 1, 1
FROM custom_formats cf WHERE cf.name = 'HDR10';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'IMAX Enhanced', 'IMAX Enhanced', 'release_title', 'all', 0, 1
FROM custom_formats cf WHERE cf.name = 'IMAX Enhanced';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'IMAX', 'IMAX', 'release_title', 'all', 0, 1
FROM custom_formats cf WHERE cf.name = 'IMAX';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'IMAX', 'IMAX Enhanced', 'release_title', 'all', 1, 1
FROM custom_formats cf WHERE cf.name = 'IMAX';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'Opus', 'Opus', 'release_title', 'all', 0, 1
FROM custom_formats cf WHERE cf.name = 'Opus';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'PCM', 'PCM', 'release_title', 'all', 0, 1
FROM custom_formats cf WHERE cf.name = 'PCM';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'PCM', 'Exclure : AAC', 'release_title', 'all', 1, 1
FROM custom_formats cf WHERE cf.name = 'PCM';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'PCM', 'Exclure : Dolby Digital', 'release_title', 'all', 1, 1
FROM custom_formats cf WHERE cf.name = 'PCM';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'PCM', 'Exclure : Dolby Digital+', 'release_title', 'all', 1, 1
FROM custom_formats cf WHERE cf.name = 'PCM';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'PCM', 'Exclure : DTS', 'release_title', 'all', 1, 1
FROM custom_formats cf WHERE cf.name = 'PCM';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'PCM', 'Exclure : FLAC', 'release_title', 'all', 1, 1
FROM custom_formats cf WHERE cf.name = 'PCM';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'PCM', 'Exclure : TrueHD', 'release_title', 'all', 1, 1
FROM custom_formats cf WHERE cf.name = 'PCM';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'Remux', 'Remux', 'release_title', 'all', 0, 1
FROM custom_formats cf WHERE cf.name = 'Remux';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'Remux', 'Exclure : source DVD', 'source', 'all', 1, 1
FROM custom_formats cf WHERE cf.name = 'Remux';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'Season Pack', 'Season Pack', 'release_type', 'all', 0, 1
FROM custom_formats cf WHERE cf.name = 'Season Pack';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'Theatrical', 'Theatrical', 'release_title', 'all', 0, 1
FROM custom_formats cf WHERE cf.name = 'Theatrical';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'Theatrical', 'Exclure : IMAX', 'release_title', 'all', 1, 1
FROM custom_formats cf WHERE cf.name = 'Theatrical';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'TrueHD', 'TrueHD', 'release_title', 'all', 0, 1
FROM custom_formats cf WHERE cf.name = 'TrueHD';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'TrueHD', 'Exclure : Dolby Digital', 'release_title', 'all', 1, 1
FROM custom_formats cf WHERE cf.name = 'TrueHD';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'TrueHD', 'Exclure : Dolby Digital+', 'release_title', 'all', 1, 1
FROM custom_formats cf WHERE cf.name = 'TrueHD';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'TrueHD', 'Exclure : DTS', 'release_title', 'all', 1, 1
FROM custom_formats cf WHERE cf.name = 'TrueHD';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'TrueHD', 'Exclure : FLAC', 'release_title', 'all', 1, 1
FROM custom_formats cf WHERE cf.name = 'TrueHD';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'UHD Bluray', '1080p', 'resolution', 'all', 0, 1
FROM custom_formats cf WHERE cf.name = 'UHD Bluray';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'UHD Bluray', 'UHD Bluray', 'release_title', 'all', 0, 1
FROM custom_formats cf WHERE cf.name = 'UHD Bluray';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'UHD Bluray', 'HDR', 'release_title', 'all', 0, 1
FROM custom_formats cf WHERE cf.name = 'UHD Bluray';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'Upscaled', 'Upscaled', 'release_title', 'all', 0, 1
FROM custom_formats cf WHERE cf.name = 'Upscaled';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'VP9', 'VP9', 'release_title', 'all', 0, 1
FROM custom_formats cf WHERE cf.name = 'VP9';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'VVC', 'VVC', 'release_title', 'all', 0, 1
FROM custom_formats cf WHERE cf.name = 'VVC';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'Xvid', 'Xvid', 'release_title', 'all', 0, 1
FROM custom_formats cf WHERE cf.name = 'Xvid';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'Xvid', 'Exclure : source DVD', 'source', 'all', 1, 1
FROM custom_formats cf WHERE cf.name = 'Xvid';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'Xvid', 'Exclure : source HDTV', 'source', 'all', 1, 1
FROM custom_formats cf WHERE cf.name = 'Xvid';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'h265', 'h265', 'release_title', 'all', 0, 1
FROM custom_formats cf WHERE cf.name = 'h265';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'h265', 'Exclure : résolution 2160p', 'resolution', 'all', 1, 1
FROM custom_formats cf WHERE cf.name = 'h265';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'x264 (2160p)', '2160p', 'resolution', 'all', 0, 1
FROM custom_formats cf WHERE cf.name = 'x264 (2160p)';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'x264 (2160p)', 'x264', 'release_title', 'all', 0, 1
FROM custom_formats cf WHERE cf.name = 'x264 (2160p)';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'x265', 'x265', 'release_title', 'all', 0, 1
FROM custom_formats cf WHERE cf.name = 'x265';
INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required)
SELECT 'x265', 'Exclure : résolution 2160p', 'resolution', 'all', 1, 1
FROM custom_formats cf WHERE cf.name = 'x265';

-- condition_sources
INSERT INTO condition_sources (custom_format_name, condition_name, source)
SELECT 'Full Disc', 'Exclure : source WEB-DL', 'web_dl'
FROM custom_format_conditions c WHERE c.custom_format_name = 'Full Disc' AND c.name = 'Exclure : source WEB-DL';
INSERT INTO condition_sources (custom_format_name, condition_name, source)
SELECT 'Full Disc', 'Exclure : source WEBRip', 'webrip'
FROM custom_format_conditions c WHERE c.custom_format_name = 'Full Disc' AND c.name = 'Exclure : source WEBRip';
INSERT INTO condition_sources (custom_format_name, condition_name, source)
SELECT 'Remux', 'Exclure : source DVD', 'dvd'
FROM custom_format_conditions c WHERE c.custom_format_name = 'Remux' AND c.name = 'Exclure : source DVD';
INSERT INTO condition_sources (custom_format_name, condition_name, source)
SELECT 'Xvid', 'Exclure : source DVD', 'dvd'
FROM custom_format_conditions c WHERE c.custom_format_name = 'Xvid' AND c.name = 'Exclure : source DVD';
INSERT INTO condition_sources (custom_format_name, condition_name, source)
SELECT 'Xvid', 'Exclure : source HDTV', 'television'
FROM custom_format_conditions c WHERE c.custom_format_name = 'Xvid' AND c.name = 'Exclure : source HDTV';

-- condition_resolutions
INSERT INTO condition_resolutions (custom_format_name, condition_name, resolution)
SELECT 'UHD Bluray', '1080p', '1080p'
FROM custom_format_conditions c WHERE c.custom_format_name = 'UHD Bluray' AND c.name = '1080p';
INSERT INTO condition_resolutions (custom_format_name, condition_name, resolution)
SELECT 'h265', 'Exclure : résolution 2160p', '2160p'
FROM custom_format_conditions c WHERE c.custom_format_name = 'h265' AND c.name = 'Exclure : résolution 2160p';
INSERT INTO condition_resolutions (custom_format_name, condition_name, resolution)
SELECT 'x264 (2160p)', '2160p', '2160p'
FROM custom_format_conditions c WHERE c.custom_format_name = 'x264 (2160p)' AND c.name = '2160p';
INSERT INTO condition_resolutions (custom_format_name, condition_name, resolution)
SELECT 'x265', 'Exclure : résolution 2160p', '2160p'
FROM custom_format_conditions c WHERE c.custom_format_name = 'x265' AND c.name = 'Exclure : résolution 2160p';

-- condition_release_types
INSERT INTO condition_release_types (custom_format_name, condition_name, release_type)
SELECT 'Season Pack', 'Season Pack', 'season_pack'
FROM custom_format_conditions c WHERE c.custom_format_name = 'Season Pack' AND c.name = 'Season Pack';

-- condition_patterns
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT '3D', '3D', re.name FROM regular_expressions re WHERE re.name = '3D';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'AAC', 'AAC', re.name FROM regular_expressions re WHERE re.name = 'AAC';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'AAC', 'Exclure : Dolby Digital', re.name FROM regular_expressions re WHERE re.name = 'Dolby Digital';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'AAC', 'Exclure : Dolby Digital+', re.name FROM regular_expressions re WHERE re.name = 'Dolby Digital +';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'AAC', 'Exclure : DTS', re.name FROM regular_expressions re WHERE re.name = 'DTS';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'AAC', 'Exclure : FLAC', re.name FROM regular_expressions re WHERE re.name = 'FLAC';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'AAC', 'Exclure : PCM', re.name FROM regular_expressions re WHERE re.name = 'PCM';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'AAC', 'Exclure : TrueHD', re.name FROM regular_expressions re WHERE re.name = 'TrueHD';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'AV1', 'AV1', re.name FROM regular_expressions re WHERE re.name = 'AV1';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'Atmos', 'Atmos (regroupement)', re.name FROM regular_expressions re WHERE re.name = 'FR-Regex-Atmos-Bundle';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'DTS-ES', 'DTS-ES', re.name FROM regular_expressions re WHERE re.name = 'DTS-ES';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'DTS-ES', 'Exclure : AAC', re.name FROM regular_expressions re WHERE re.name = 'AAC';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'DTS-ES', 'Exclure : Dolby Digital', re.name FROM regular_expressions re WHERE re.name = 'Dolby Digital';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'DTS-ES', 'Exclure : Dolby Digital+', re.name FROM regular_expressions re WHERE re.name = 'Dolby Digital +';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'DTS-ES', 'Exclure : DTS', re.name FROM regular_expressions re WHERE re.name = 'DTS Basic';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'DTS-ES', 'Exclure : DTS-X', re.name FROM regular_expressions re WHERE re.name = 'DTS-X';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'DTS-ES', 'Exclure : FLAC', re.name FROM regular_expressions re WHERE re.name = 'FLAC';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'DTS-ES', 'Exclure : PCM', re.name FROM regular_expressions re WHERE re.name = 'PCM';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'DTS-ES', 'Exclure : TrueHD', re.name FROM regular_expressions re WHERE re.name = 'TrueHD';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'DTS-HD HRA', 'DTS-HD HRA', re.name FROM regular_expressions re WHERE re.name = 'DTS-HD HRA';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'DTS-HD HRA', 'Exclure : AAC', re.name FROM regular_expressions re WHERE re.name = 'AAC';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'DTS-HD HRA', 'Exclure : Dolby Digital', re.name FROM regular_expressions re WHERE re.name = 'Dolby Digital';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'DTS-HD HRA', 'Exclure : Dolby Digital+', re.name FROM regular_expressions re WHERE re.name = 'Dolby Digital +';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'DTS-HD HRA', 'Exclure : DTS', re.name FROM regular_expressions re WHERE re.name = 'DTS Basic';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'DTS-HD HRA', 'Exclure : DTS-ES', re.name FROM regular_expressions re WHERE re.name = 'DTS-ES';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'DTS-HD HRA', 'Exclure : DTS-X', re.name FROM regular_expressions re WHERE re.name = 'DTS-X';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'DTS-HD HRA', 'Exclure : FLAC', re.name FROM regular_expressions re WHERE re.name = 'FLAC';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'DTS-HD HRA', 'Exclure : PCM', re.name FROM regular_expressions re WHERE re.name = 'PCM';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'DTS-HD HRA', 'Exclure : TrueHD', re.name FROM regular_expressions re WHERE re.name = 'TrueHD';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'DTS-HD MA', 'DTS-HD MA', re.name FROM regular_expressions re WHERE re.name = 'DTS-HD MA';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'DTS-HD MA', 'Exclure : AAC', re.name FROM regular_expressions re WHERE re.name = 'AAC';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'DTS-HD MA', 'Exclure : Dolby Digital', re.name FROM regular_expressions re WHERE re.name = 'Dolby Digital';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'DTS-HD MA', 'Exclure : Dolby Digital+', re.name FROM regular_expressions re WHERE re.name = 'Dolby Digital +';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'DTS-HD MA', 'Exclure : DTS-HD HRA/ES', re.name FROM regular_expressions re WHERE re.name = 'DTS-HD HRA ES';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'DTS-HD MA', 'Exclure : DTS-X', re.name FROM regular_expressions re WHERE re.name = 'DTS-X';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'DTS-HD MA', 'Exclure : FLAC', re.name FROM regular_expressions re WHERE re.name = 'FLAC';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'DTS-HD MA', 'Exclure : PCM', re.name FROM regular_expressions re WHERE re.name = 'PCM';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'DTS-HD MA', 'Exclure : TrueHD', re.name FROM regular_expressions re WHERE re.name = 'TrueHD';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'DTS-X', 'DTS-X', re.name FROM regular_expressions re WHERE re.name = 'DTS-X';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'DTS-X', 'Exclure : AAC', re.name FROM regular_expressions re WHERE re.name = 'AAC';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'DTS-X', 'Exclure : Dolby Digital', re.name FROM regular_expressions re WHERE re.name = 'Dolby Digital';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'DTS-X', 'Exclure : Dolby Digital+', re.name FROM regular_expressions re WHERE re.name = 'Dolby Digital +';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'DTS-X', 'Exclure : DTS', re.name FROM regular_expressions re WHERE re.name = 'DTS Basic';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'DTS-X', 'Exclure : FLAC', re.name FROM regular_expressions re WHERE re.name = 'FLAC';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'DTS-X', 'Exclure : PCM', re.name FROM regular_expressions re WHERE re.name = 'PCM';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'DTS-X', 'Exclure : TrueHD', re.name FROM regular_expressions re WHERE re.name = 'TrueHD';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'DTS', 'DTS', re.name FROM regular_expressions re WHERE re.name = 'DTS';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'DTS', 'Exclure : AAC', re.name FROM regular_expressions re WHERE re.name = 'AAC';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'DTS', 'Exclure : Dolby Digital', re.name FROM regular_expressions re WHERE re.name = 'Dolby Digital';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'DTS', 'Exclure : Dolby Digital+', re.name FROM regular_expressions re WHERE re.name = 'Dolby Digital +';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'DTS', 'Exclure : DTS-HD', re.name FROM regular_expressions re WHERE re.name = 'DTS-HD MA';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'DTS', 'Exclure : DTS-HD HRA/ES', re.name FROM regular_expressions re WHERE re.name = 'DTS-HD HRA ES';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'DTS', 'Exclure : DTS-X', re.name FROM regular_expressions re WHERE re.name = 'DTS-X';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'DTS', 'Exclure : FLAC', re.name FROM regular_expressions re WHERE re.name = 'FLAC';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'DTS', 'Exclure : PCM', re.name FROM regular_expressions re WHERE re.name = 'PCM';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'DTS', 'Exclure : TrueHD', re.name FROM regular_expressions re WHERE re.name = 'TrueHD';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'Dolby Digital +', 'Dolby Digital +', re.name FROM regular_expressions re WHERE re.name = 'Dolby Digital +';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'Dolby Digital +', 'Exclure : AAC', re.name FROM regular_expressions re WHERE re.name = 'AAC';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'Dolby Digital +', 'Exclure : DTS', re.name FROM regular_expressions re WHERE re.name = 'DTS';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'Dolby Digital +', 'Exclure : FLAC', re.name FROM regular_expressions re WHERE re.name = 'FLAC';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'Dolby Digital +', 'Exclure : PCM', re.name FROM regular_expressions re WHERE re.name = 'PCM';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'Dolby Digital +', 'Exclure : TrueHD', re.name FROM regular_expressions re WHERE re.name = 'TrueHD';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'Dolby Digital', 'Dolby Digital', re.name FROM regular_expressions re WHERE re.name = 'Dolby Digital';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'Dolby Digital', 'Exclure : AAC', re.name FROM regular_expressions re WHERE re.name = 'AAC';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'Dolby Digital', 'Exclure : Dolby Digital+', re.name FROM regular_expressions re WHERE re.name = 'Dolby Digital +';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'Dolby Digital', 'Exclure : DTS', re.name FROM regular_expressions re WHERE re.name = 'DTS';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'Dolby Digital', 'Exclure : FLAC', re.name FROM regular_expressions re WHERE re.name = 'FLAC';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'Dolby Digital', 'Exclure : PCM', re.name FROM regular_expressions re WHERE re.name = 'PCM';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'Dolby Digital', 'Exclure : TrueHD', re.name FROM regular_expressions re WHERE re.name = 'TrueHD';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'Dolby Vision (Without Fallback)', 'Dolby Vision (Without Fallback)', re.name FROM regular_expressions re WHERE re.name = 'Dolby Vision (Without Fallback)';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'Dolby Vision', 'Dolby Vision', re.name FROM regular_expressions re WHERE re.name = 'Dolby Vision';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'FLAC', 'FLAC', re.name FROM regular_expressions re WHERE re.name = 'FLAC';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'FLAC', 'Exclure : AAC', re.name FROM regular_expressions re WHERE re.name = 'AAC';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'FLAC', 'Exclure : Dolby Digital', re.name FROM regular_expressions re WHERE re.name = 'Dolby Digital';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'FLAC', 'Exclure : Dolby Digital+', re.name FROM regular_expressions re WHERE re.name = 'Dolby Digital +';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'FLAC', 'Exclure : DTS', re.name FROM regular_expressions re WHERE re.name = 'DTS';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'FLAC', 'Exclure : PCM', re.name FROM regular_expressions re WHERE re.name = 'PCM';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'FLAC', 'Exclure : TrueHD', re.name FROM regular_expressions re WHERE re.name = 'TrueHD';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'FR-4KLight', '4KLight', re.name FROM regular_expressions re WHERE re.name = 'FR-Regex-4KLight';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'FR-Blockers', 'Liste noire scène FR', re.name FROM regular_expressions re WHERE re.name = 'FR-Regex-Blockers';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'FR-HDLight', 'HDLight', re.name FROM regular_expressions re WHERE re.name = 'FR-Regex-HDLight';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'FR-Hybrid', 'HYBRID', re.name FROM regular_expressions re WHERE re.name = 'FR-Regex-Hybrid';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'FR-MULTI-VF2', 'MULTI', re.name FROM regular_expressions re WHERE re.name = 'FR-Regex-MULTI';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'FR-MULTI-VF2', 'VF2', re.name FROM regular_expressions re WHERE re.name = 'FR-Regex-VF2';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'FR-MULTI-VFQ', 'MULTI', re.name FROM regular_expressions re WHERE re.name = 'FR-Regex-MULTI';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'FR-MULTI-VFQ', 'VFQ', re.name FROM regular_expressions re WHERE re.name = 'FR-Regex-VFQ';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'FR-MULTI-VFF', 'MULTI + tag FR C411', re.name FROM regular_expressions re WHERE re.name = 'FR-Regex-MULTI-VFF';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'FR-MULTI-ambig', 'MULTI sans précision FR', re.name FROM regular_expressions re WHERE re.name = 'FR-Regex-MULTI-ambig';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'FR-VFF', 'Pas de tag MULTI', re.name FROM regular_expressions re WHERE re.name = 'FR-Regex-MULTI';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'FR-Repack-2', 'Repack — 2e itération', re.name FROM regular_expressions re WHERE re.name = 'FR-Repack-2';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'FR-Repack-3', 'Repack — 3e itération', re.name FROM regular_expressions re WHERE re.name = 'FR-Repack-3';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'FR-Repack', 'Repack', re.name FROM regular_expressions re WHERE re.name = 'FR-Repack';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'FR-WEBRip', 'WEBRip dans le titre', re.name FROM regular_expressions re WHERE re.name = 'FR-Regex-WEBRip';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'FR-Audio-71', '7.1 dans le titre', re.name FROM regular_expressions re WHERE re.name = 'FR-Regex-Audio-71';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'FR-Streamer-Premium', 'Streamers premium (regex FR)', re.name FROM regular_expressions re WHERE re.name = 'FR-Regex-Streamers-Premium';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'FR-Streamer-Standard', 'Streamers standard (regex FR)', re.name FROM regular_expressions re WHERE re.name = 'FR-Regex-Streamers-Standard';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'FR-Team-AMEN', 'AMEN', re.name FROM regular_expressions re WHERE re.name = 'AMEN';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'FR-Team-AMEN', 'AMEN Group', re.name FROM regular_expressions re WHERE re.name = 'AMEN';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'FR-Team-BONBON', 'BONBON', re.name FROM regular_expressions re WHERE re.name = 'BONBON';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'FR-Team-BONBON', 'BONBON Group', re.name FROM regular_expressions re WHERE re.name = 'BONBON';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'FR-Team-BOUC', 'BOUC', re.name FROM regular_expressions re WHERE re.name = 'BOUC';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'FR-Team-BOUC', 'BOUC Group', re.name FROM regular_expressions re WHERE re.name = 'BOUC';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'FR-Team-ENIGMA', 'ENIGMA', re.name FROM regular_expressions re WHERE re.name = 'ENIGMA';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'FR-Team-ENIGMA', 'ENIGMA Group', re.name FROM regular_expressions re WHERE re.name = 'ENIGMA';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'FR-Team-FW', 'FW', re.name FROM regular_expressions re WHERE re.name = 'FW';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'FR-Team-FW', 'FW Group', re.name FROM regular_expressions re WHERE re.name = 'FW';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'FR-Team-HYPERION', 'HYPERION', re.name FROM regular_expressions re WHERE re.name = 'HYPERION';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'FR-Team-HYPERION', 'HYPERION Group', re.name FROM regular_expressions re WHERE re.name = 'HYPERION';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'FR-Team-OZEF', 'OZEF', re.name FROM regular_expressions re WHERE re.name = 'OZEF';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'FR-Team-OZEF', 'OZEF Group', re.name FROM regular_expressions re WHERE re.name = 'OZEF';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'FR-Team-PopHD', 'PopHD', re.name FROM regular_expressions re WHERE re.name = 'PopHD';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'FR-Team-PopHD', 'PopHD Group', re.name FROM regular_expressions re WHERE re.name = 'PopHD';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'FR-Team-QTZ', 'QTZ', re.name FROM regular_expressions re WHERE re.name = 'QTZ';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'FR-Team-QTZ', 'QTZ Group', re.name FROM regular_expressions re WHERE re.name = 'QTZ';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'FR-Team-SUPPLY', 'SUPPLY', re.name FROM regular_expressions re WHERE re.name = 'SUPPLY';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'FR-Team-SUPPLY', 'SUPPLY Group', re.name FROM regular_expressions re WHERE re.name = 'SUPPLY';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'FR-Team-Slay3R', 'Slay3R', re.name FROM regular_expressions re WHERE re.name = 'Slay3R';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'FR-Team-Slay3R', 'Slay3R Group', re.name FROM regular_expressions re WHERE re.name = 'Slay3R';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'FR-Team-TFA', 'TFA', re.name FROM regular_expressions re WHERE re.name = 'TFA';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'FR-Team-TFA', 'TFA Group', re.name FROM regular_expressions re WHERE re.name = 'TFA';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'FR-Team-THESYNDiCATE', 'THESYNDiCATE', re.name FROM regular_expressions re WHERE re.name = 'THESYNDiCATE';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'FR-Team-THESYNDiCATE', 'THESYNDiCATE Group', re.name FROM regular_expressions re WHERE re.name = 'THESYNDiCATE';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'FR-Team-TOXIC', 'TOXIC', re.name FROM regular_expressions re WHERE re.name = 'TOXIC';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'FR-Team-TOXIC', 'TOXIC Group', re.name FROM regular_expressions re WHERE re.name = 'TOXIC';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'FR-Team-TyHD', 'TyHD', re.name FROM regular_expressions re WHERE re.name = 'TyHD';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'FR-Team-TyHD', 'TyHD Group', re.name FROM regular_expressions re WHERE re.name = 'TyHD';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'FR-Team-Winks', 'Winks', re.name FROM regular_expressions re WHERE re.name = 'Winks';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'FR-Team-Winks', 'Winks Group', re.name FROM regular_expressions re WHERE re.name = 'Winks';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'FR-Tier-01', 'Palier 01 — longue traîne haute', re.name FROM regular_expressions re WHERE re.name = 'FR-Tier-01';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'FR-Tier-02', 'Palier 02 — longue traîne basse', re.name FROM regular_expressions re WHERE re.name = 'FR-Tier-02';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'FR-VF2', 'VF2', re.name FROM regular_expressions re WHERE re.name = 'FR-Regex-VF2';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'FR-VFQ', 'Pas de tag MULTI', re.name FROM regular_expressions re WHERE re.name = 'FR-Regex-MULTI';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'FR-VFQ', 'VFQ', re.name FROM regular_expressions re WHERE re.name = 'FR-Regex-VFQ';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'FR-VFF', 'VFF', re.name FROM regular_expressions re WHERE re.name = 'FR-Regex-VFF';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'FR-VOSTFR', 'VOSTFR', re.name FROM regular_expressions re WHERE re.name = 'FR-Regex-VOSTFR';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'Full Disc', 'Full Disc', re.name FROM regular_expressions re WHERE re.name = 'Full Disc';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'Full Disc', 'Exclure : Remux', re.name FROM regular_expressions re WHERE re.name = 'Remux';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'Full Disc', 'Exclure : x264', re.name FROM regular_expressions re WHERE re.name = 'x264';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'Full Disc', 'Exclure : x265', re.name FROM regular_expressions re WHERE re.name = 'x265';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'HDR', 'HDR', re.name FROM regular_expressions re WHERE re.name = 'HDR';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'HDR', 'Exclure : SDR', re.name FROM regular_expressions re WHERE re.name = 'SDR';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'HDR', 'Exclure : PQ', re.name FROM regular_expressions re WHERE re.name = 'PQ';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'HDR', 'Exclure : HLG', re.name FROM regular_expressions re WHERE re.name = 'HLG';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'HDR', 'Exclure : HDR10', re.name FROM regular_expressions re WHERE re.name = 'HDR10';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'HDR', 'Exclure : HDR10+', re.name FROM regular_expressions re WHERE re.name = 'HDR10+';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'HDR10+', 'HDR10+', re.name FROM regular_expressions re WHERE re.name = 'HDR10+';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'HDR10+', 'Exclure : SDR', re.name FROM regular_expressions re WHERE re.name = 'SDR';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'HDR10+', 'Exclure : PQ', re.name FROM regular_expressions re WHERE re.name = 'PQ';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'HDR10+', 'Exclure : HLG', re.name FROM regular_expressions re WHERE re.name = 'HLG';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'HDR10', 'HDR10', re.name FROM regular_expressions re WHERE re.name = 'HDR10';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'HDR10', 'Exclure : SDR', re.name FROM regular_expressions re WHERE re.name = 'SDR';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'HDR10', 'Exclure : PQ', re.name FROM regular_expressions re WHERE re.name = 'PQ';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'HDR10', 'Exclure : HLG', re.name FROM regular_expressions re WHERE re.name = 'HLG';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'HDR10', 'Exclure : HDR10+', re.name FROM regular_expressions re WHERE re.name = 'HDR10+';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'IMAX Enhanced', 'IMAX Enhanced', re.name FROM regular_expressions re WHERE re.name = 'IMAX Enhanced';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'IMAX', 'IMAX', re.name FROM regular_expressions re WHERE re.name = 'IMAX';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'IMAX', 'IMAX Enhanced', re.name FROM regular_expressions re WHERE re.name = 'IMAX Enhanced';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'Opus', 'Opus', re.name FROM regular_expressions re WHERE re.name = 'Opus';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'PCM', 'PCM', re.name FROM regular_expressions re WHERE re.name = 'PCM';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'PCM', 'Exclure : AAC', re.name FROM regular_expressions re WHERE re.name = 'AAC';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'PCM', 'Exclure : Dolby Digital', re.name FROM regular_expressions re WHERE re.name = 'Dolby Digital';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'PCM', 'Exclure : Dolby Digital+', re.name FROM regular_expressions re WHERE re.name = 'Dolby Digital +';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'PCM', 'Exclure : DTS', re.name FROM regular_expressions re WHERE re.name = 'DTS';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'PCM', 'Exclure : FLAC', re.name FROM regular_expressions re WHERE re.name = 'FLAC';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'PCM', 'Exclure : TrueHD', re.name FROM regular_expressions re WHERE re.name = 'TrueHD';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'Remux', 'Remux', re.name FROM regular_expressions re WHERE re.name = 'Remux';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'Theatrical', 'Theatrical', re.name FROM regular_expressions re WHERE re.name = 'Theatrical Edition';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'Theatrical', 'Exclure : IMAX', re.name FROM regular_expressions re WHERE re.name = 'IMAX';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'TrueHD', 'TrueHD', re.name FROM regular_expressions re WHERE re.name = 'TrueHD';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'TrueHD', 'Exclure : Dolby Digital', re.name FROM regular_expressions re WHERE re.name = 'Dolby Digital';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'TrueHD', 'Exclure : Dolby Digital+', re.name FROM regular_expressions re WHERE re.name = 'Dolby Digital +';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'TrueHD', 'Exclure : DTS', re.name FROM regular_expressions re WHERE re.name = 'DTS';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'TrueHD', 'Exclure : FLAC', re.name FROM regular_expressions re WHERE re.name = 'FLAC';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'UHD Bluray', 'UHD Bluray', re.name FROM regular_expressions re WHERE re.name = 'UHD Bluray';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'UHD Bluray', 'HDR', re.name FROM regular_expressions re WHERE re.name = 'Basic HDR Formats';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'Upscaled', 'Upscaled', re.name FROM regular_expressions re WHERE re.name = 'Upscaled';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'VP9', 'VP9', re.name FROM regular_expressions re WHERE re.name = 'VP9';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'VVC', 'VVC', re.name FROM regular_expressions re WHERE re.name = 'VVC';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'Xvid', 'Xvid', re.name FROM regular_expressions re WHERE re.name = 'Xvid';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'h265', 'h265', re.name FROM regular_expressions re WHERE re.name = 'h265';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'x264 (2160p)', 'x264', re.name FROM regular_expressions re WHERE re.name = 'x264';
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
SELECT 'x265', 'x265', re.name FROM regular_expressions re WHERE re.name = 'x265';

-- french-profilarr-database — ops/05
-- Liaison custom_format ↔ tags (filtres UI Profilarr).

INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT '3D', 'Banned' FROM tags t WHERE t.name = 'Banned';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT '3D', 'Enhancement' FROM tags t WHERE t.name = 'Enhancement';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'AAC', 'Audio' FROM tags t WHERE t.name = 'Audio';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'AV1', 'Codec' FROM tags t WHERE t.name = 'Codec';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'AV1', 'Bleeding Edge' FROM tags t WHERE t.name = 'Bleeding Edge';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'Atmos', 'Audio' FROM tags t WHERE t.name = 'Audio';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'Atmos', 'Dolby' FROM tags t WHERE t.name = 'Dolby';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'DTS-ES', 'Audio' FROM tags t WHERE t.name = 'Audio';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'DTS-HD HRA', 'Audio' FROM tags t WHERE t.name = 'Audio';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'DTS-HD MA', 'Audio' FROM tags t WHERE t.name = 'Audio';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'DTS-X', 'Audio' FROM tags t WHERE t.name = 'Audio';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'DTS', 'Audio' FROM tags t WHERE t.name = 'Audio';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'Dolby Digital +', 'Audio' FROM tags t WHERE t.name = 'Audio';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'Dolby Digital', 'Audio' FROM tags t WHERE t.name = 'Audio';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'Dolby Vision (Without Fallback)', 'Colour Grade' FROM tags t WHERE t.name = 'Colour Grade';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'Dolby Vision (Without Fallback)', 'HDR' FROM tags t WHERE t.name = 'HDR';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'Dolby Vision', 'Colour Grade' FROM tags t WHERE t.name = 'Colour Grade';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'Dolby Vision', 'HDR' FROM tags t WHERE t.name = 'HDR';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'FLAC', 'Audio' FROM tags t WHERE t.name = 'Audio';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'FR-4KLight', 'Source' FROM tags t WHERE t.name = 'Source';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'FR-4KLight', 'French' FROM tags t WHERE t.name = 'French';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'FR-4KLight', '4K' FROM tags t WHERE t.name = '4K';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'FR-Blockers', 'Release Group' FROM tags t WHERE t.name = 'Release Group';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'FR-Blockers', 'French' FROM tags t WHERE t.name = 'French';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'FR-Blockers', 'Banned' FROM tags t WHERE t.name = 'Banned';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'FR-HDLight', 'Source' FROM tags t WHERE t.name = 'Source';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'FR-HDLight', 'French' FROM tags t WHERE t.name = 'French';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'FR-Hybrid', 'Source' FROM tags t WHERE t.name = 'Source';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'FR-Hybrid', 'French' FROM tags t WHERE t.name = 'French';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'FR-Hybrid', 'Enhancement' FROM tags t WHERE t.name = 'Enhancement';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'FR-MULTI-VF2', 'Language' FROM tags t WHERE t.name = 'Language';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'FR-MULTI-VF2', 'French' FROM tags t WHERE t.name = 'French';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'FR-MULTI-VFF', 'Language' FROM tags t WHERE t.name = 'Language';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'FR-MULTI-VFF', 'French' FROM tags t WHERE t.name = 'French';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'FR-Repack-2', 'Flag' FROM tags t WHERE t.name = 'Flag';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'FR-Repack-2', 'Repack' FROM tags t WHERE t.name = 'Repack';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'FR-Repack-2', 'French' FROM tags t WHERE t.name = 'French';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'FR-Repack-3', 'Flag' FROM tags t WHERE t.name = 'Flag';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'FR-Repack-3', 'Repack' FROM tags t WHERE t.name = 'Repack';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'FR-Repack-3', 'French' FROM tags t WHERE t.name = 'French';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'FR-Repack', 'Flag' FROM tags t WHERE t.name = 'Flag';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'FR-Repack', 'Repack' FROM tags t WHERE t.name = 'Repack';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'FR-Repack', 'French' FROM tags t WHERE t.name = 'French';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'FR-Streamer-Premium', 'Streaming Service' FROM tags t WHERE t.name = 'Streaming Service';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'FR-Streamer-Premium', 'French' FROM tags t WHERE t.name = 'French';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'FR-Streamer-Standard', 'Streaming Service' FROM tags t WHERE t.name = 'Streaming Service';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'FR-Streamer-Standard', 'French' FROM tags t WHERE t.name = 'French';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'FR-Team-AMEN', 'Release Group' FROM tags t WHERE t.name = 'Release Group';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'FR-Team-AMEN', 'French' FROM tags t WHERE t.name = 'French';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'FR-Team-BONBON', 'Release Group' FROM tags t WHERE t.name = 'Release Group';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'FR-Team-BONBON', 'French' FROM tags t WHERE t.name = 'French';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'FR-Team-BOUC', 'Release Group' FROM tags t WHERE t.name = 'Release Group';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'FR-Team-BOUC', 'French' FROM tags t WHERE t.name = 'French';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'FR-Team-ENIGMA', 'Release Group' FROM tags t WHERE t.name = 'Release Group';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'FR-Team-ENIGMA', 'French' FROM tags t WHERE t.name = 'French';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'FR-Team-FW', 'Release Group' FROM tags t WHERE t.name = 'Release Group';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'FR-Team-FW', 'French' FROM tags t WHERE t.name = 'French';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'FR-Team-HYPERION', 'Release Group' FROM tags t WHERE t.name = 'Release Group';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'FR-Team-HYPERION', 'French' FROM tags t WHERE t.name = 'French';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'FR-Team-OZEF', 'Release Group' FROM tags t WHERE t.name = 'Release Group';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'FR-Team-OZEF', 'French' FROM tags t WHERE t.name = 'French';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'FR-Team-PopHD', 'Release Group' FROM tags t WHERE t.name = 'Release Group';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'FR-Team-PopHD', 'French' FROM tags t WHERE t.name = 'French';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'FR-Team-QTZ', 'Release Group' FROM tags t WHERE t.name = 'Release Group';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'FR-Team-QTZ', 'French' FROM tags t WHERE t.name = 'French';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'FR-Team-SUPPLY', 'Release Group' FROM tags t WHERE t.name = 'Release Group';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'FR-Team-SUPPLY', 'French' FROM tags t WHERE t.name = 'French';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'FR-Team-Slay3R', 'Release Group' FROM tags t WHERE t.name = 'Release Group';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'FR-Team-Slay3R', 'French' FROM tags t WHERE t.name = 'French';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'FR-Team-TFA', 'Release Group' FROM tags t WHERE t.name = 'Release Group';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'FR-Team-TFA', 'French' FROM tags t WHERE t.name = 'French';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'FR-Team-THESYNDiCATE', 'Release Group' FROM tags t WHERE t.name = 'Release Group';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'FR-Team-THESYNDiCATE', 'French' FROM tags t WHERE t.name = 'French';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'FR-Team-TOXIC', 'Release Group' FROM tags t WHERE t.name = 'Release Group';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'FR-Team-TOXIC', 'French' FROM tags t WHERE t.name = 'French';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'FR-Team-TyHD', 'Release Group' FROM tags t WHERE t.name = 'Release Group';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'FR-Team-TyHD', 'French' FROM tags t WHERE t.name = 'French';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'FR-Tier-01', 'Release Group' FROM tags t WHERE t.name = 'Release Group';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'FR-Tier-01', 'Release Group Tier' FROM tags t WHERE t.name = 'Release Group Tier';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'FR-Tier-01', 'French' FROM tags t WHERE t.name = 'French';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'FR-Tier-02', 'Release Group' FROM tags t WHERE t.name = 'Release Group';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'FR-Tier-02', 'Release Group Tier' FROM tags t WHERE t.name = 'Release Group Tier';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'FR-Tier-02', 'French' FROM tags t WHERE t.name = 'French';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'FR-VF2', 'Language' FROM tags t WHERE t.name = 'Language';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'FR-VF2', 'French' FROM tags t WHERE t.name = 'French';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'FR-VFF', 'Language' FROM tags t WHERE t.name = 'Language';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'FR-VFF', 'French' FROM tags t WHERE t.name = 'French';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'FR-VOSTFR', 'Language' FROM tags t WHERE t.name = 'Language';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'FR-VOSTFR', 'French' FROM tags t WHERE t.name = 'French';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'Full Disc', 'Storage' FROM tags t WHERE t.name = 'Storage';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'Full Disc', 'Banned' FROM tags t WHERE t.name = 'Banned';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'HDR', 'Colour Grade' FROM tags t WHERE t.name = 'Colour Grade';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'HDR', 'HDR' FROM tags t WHERE t.name = 'HDR';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'HDR10+', 'Colour Grade' FROM tags t WHERE t.name = 'Colour Grade';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'HDR10+', 'HDR' FROM tags t WHERE t.name = 'HDR';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'HDR10', 'Colour Grade' FROM tags t WHERE t.name = 'Colour Grade';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'HDR10', 'HDR' FROM tags t WHERE t.name = 'HDR';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'IMAX Enhanced', 'Edition' FROM tags t WHERE t.name = 'Edition';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'IMAX', 'Edition' FROM tags t WHERE t.name = 'Edition';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'Opus', 'Audio' FROM tags t WHERE t.name = 'Audio';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'PCM', 'Audio' FROM tags t WHERE t.name = 'Audio';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'Remux', 'Storage' FROM tags t WHERE t.name = 'Storage';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'Remux', 'Banned' FROM tags t WHERE t.name = 'Banned';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'Season Pack', 'Enhancement' FROM tags t WHERE t.name = 'Enhancement';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'Theatrical', 'Edition' FROM tags t WHERE t.name = 'Edition';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'TrueHD', 'Audio' FROM tags t WHERE t.name = 'Audio';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'UHD Bluray', '2160p' FROM tags t WHERE t.name = '2160p';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'UHD Bluray', 'Storage' FROM tags t WHERE t.name = 'Storage';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'Upscaled', 'Banned' FROM tags t WHERE t.name = 'Banned';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'Upscaled', 'Enhancement' FROM tags t WHERE t.name = 'Enhancement';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'VP9', 'Codec' FROM tags t WHERE t.name = 'Codec';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'VP9', 'Bleeding Edge' FROM tags t WHERE t.name = 'Bleeding Edge';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'VVC', 'Codec' FROM tags t WHERE t.name = 'Codec';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'VVC', 'Bleeding Edge' FROM tags t WHERE t.name = 'Bleeding Edge';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'Xvid', 'Codec' FROM tags t WHERE t.name = 'Codec';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'h265', 'Codec' FROM tags t WHERE t.name = 'Codec';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'x264 (2160p)', 'Codec' FROM tags t WHERE t.name = 'Codec';
INSERT OR IGNORE INTO custom_format_tags (custom_format_name, tag_name)
SELECT 'x265', 'Codec' FROM tags t WHERE t.name = 'Codec';

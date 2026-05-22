-- french-profilarr-database — ops/09
-- Delay Sonarr (Radarr : FR-Delay-Radarr dans ops/07).
-- Media instance : French - Radarr / French - Sonarr dans ops/07 (pas de clone par profil FR-Films-*).

INSERT INTO delay_profiles (
    name, preferred_protocol, usenet_delay, torrent_delay,
    bypass_if_highest_quality, bypass_if_above_custom_format_score, minimum_custom_format_score
) VALUES ('FR-Delay-Sonarr', 'only_torrent', NULL, 0, 1, 0, NULL);

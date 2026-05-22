# French Profilarr Database

Base PCD [Profilarr v2](https://v2.dictionarry.dev) — scène française (C411, La Cale, Gemini). Structure comme [Dumpstarr/Database](https://github.com/Dumpstarr/Database) : `pcd.json` + `ops/*.sql` uniquement.

**Profilarr ≥ 2.0.0** — schema [1.1.0](https://github.com/Dictionarry-Hub/schema). Après mise à jour Git : **Pull → Compile → Sync**.

Dans Radarr/Sonarr, assigner le **profil qualité** et le **media management** du **même nom** (ex. `FR-Films-1080p`) — pas `FR-Media-Base` (gabarit interne).

## Profils recommandés

| Profil | Application | Usage |
| :--- | :--- | :--- |
| `FR-Films-1080p` | Radarr | Films 1080p — point de départ |
| `FR-Films-4K` | Radarr | Films 4K (HDR / DV) |
| `FR-Series-1080p` | Sonarr | Séries 1080p |
| `FR-Series-4K` | Sonarr | Séries 4K |
| `FR-Anime-1080p` | Sonarr | Animé 1080p |
| `FR-Films-720p` / `FR-Series-720p` | Radarr / Sonarr | Encodes compacts |
| `FR-Films-Any` | Radarr | Secours toutes résolutions |

## Spécificités FR (vs Dumpstarr international)

- **Langue** : scores VF / VFF / MULTI / VOSTFR (priorité scène FR).
- **Trackers torrent** : délais `FR-Delay-Radarr` / `FR-Delay-Sonarr` (`only_torrent`, délai 0).
- **Pas de Remux** : bloqués à -999999.
- **rename = 0** : noms de release conservés (habitude trackers FR).
- **x265 en 1080p/720p** : autorisé et favorisé (contrairement à Dumpstarr qui pénalise x265 sous 2160p).

## Issues

[GitHub Issues](https://github.com/mcflykid/french-profilarr-database/issues)

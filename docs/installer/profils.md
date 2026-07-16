# Profils qualité

**En bref** : un profil = une résolution + des règles de points. Films Radarr : souvent `FR-Films-1080p` ou `FR-Films-4K`. Séries Sonarr : `FR-Series-*`. Animé : `FR-Anime-*`.

[← Index doc](../README.md) · [Guide](guide.md)

---

| Profil | App | Usage |
|--------|-----|--------|
| **FR-Films-1080p** | Radarr | Films 1080p — point de départ |
| **FR-Films-720p** | Radarr | Compacts (peu utilisé, symétrie) |
| **FR-Films-Any** | Radarr | Secours toute qualité, SD → 4K, **sans remux** |
| **FR-Films-4K** | Radarr | 4K — DV/HDR, 4KLight, équipes WEB |
| **FR-Series-1080p** | Sonarr | Séries 1080p + Season Pack |
| **FR-Series-4K** | Sonarr | Séries 4K |
| **FR-Series-720p** | Sonarr | Séries compactes |
| **FR-Anime-1080p/4K/720p** | Sonarr | Animé (type Anime) |

**Scoring identique sur les 10 profils** (`ops/06`) : même hiérarchie **langue 1er tri** (8k max) + **qualité** (équipe ~5,5k, HDR/DV/son sur profils **4K**). Seules les pondérations **techniques** varient selon la résolution du profil (ex. **Dolby Vision 3 500** en `FR-Films-4K` / `FR-Series-4K`, **1 200** en 1080p). **`upgrade_until_score` = 60 000** et **`upgrade_score_increment` = 1400** partout (un upgrade ne se re-télécharge que s'il rapporte au moins +1400 points ≈ un palier de langue — anti-churn renforcé 2026-07, voir [tailles.md](tailles.md)).

Chaque profil **exclut** : Remux, Full Disc, AV1, Upscaled (+ x264@2160p sur 4K).

Tags UI (`ops/06` + `ops/10`) : Radarr, Sonarr, Films, Series, 1080p/2160p/720p, French, **anime** (filtre Sonarr — tag SQL minuscule volontaire).

---

---

[← Index doc](../README.md) · [← README](../../README.md)

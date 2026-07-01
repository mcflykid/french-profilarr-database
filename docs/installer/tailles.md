# Tailles des fichiers

**En bref** : en plus des points sur le titre, Radarr vérifie que le fichier n’est ni **trop petit** ni **trop gros** pour la durée du film ou de l’épisode. Trois réglages : **films**, **séries**, **animé**.

[← Index doc](../README.md) · [Guide](guide.md)

---

### Principe

Les champs `min_size` / `preferred_size` / `max_size` dans **`ops/07`** (Radarr) et **`ops/09`** (delay Sonarr) guident Radarr/Sonarr vers des **tailles cohérentes avec la scène FR** (encodes compacts), en complément des scores CF.

**Trois presets media** (Profilarr v2 — un choix par instance / type de contenu) :

| Preset | App | Contenu | Durée typique |
|--------|-----|---------|---------------|
| **`FR-Media-Radarr`** | Radarr | Films | ~90–150 min |
| **`FR-Media-Sonarr`** | Sonarr | Séries live-action | ~40–50 min/ép. |
| **`FR-Media-Anime-Sonarr`** | Sonarr | Animé (type Anime) | ~24 min/ép. |

Chaque preset = Naming + Quality definitions + Media settings (les 3 menus Media Management pointent vers **le même nom** sur l’instance concernée).

**Sonarr mixte (séries + animé sur une seule instance)** : une seule définition de taille active — privilégier **`FR-Media-Sonarr`** (planchers bas) ou une instance Sonarr dédiée à l’animé avec **`FR-Media-Anime-Sonarr`**.

Ancien modèle abandonné : un bundle media **par** profil `FR-Films-4K`.

### Tableau des tailles (valeurs actuelles)

**Unité réelle** : Radarr/Sonarr stockent des **Mo par minute** de durée du film ou de l’épisode (`min_size`, `preferred_size`, `max_size` dans `ops/07`). La taille minimale autorisée pour un titre est :

`min_size (Mo/min) × durée (min) ≈ taille minimale (Mo)`

Exemple *Up in the Air* (~109 min) avec l’ancien `min = 900` sur Bluray-1080p : `900 × 109 ≈ 98 100 Mo` → **~96,7 Go** minimum — d’où le rejet de releases à 7–11 Go en recherche interactive. L’UI peut afficher des libellés ambigus ; ne pas confondre avec « Mo/h ».

**`preferred`** = cible Mo/min (favorise les releases proches de la taille scène FR compacte, pas « toujours le plus gros »).

**Logique des bornes (2026-06)** :

- **`min` = anti-junk seulement** : il ne sert qu'à rejeter les fakes et fichiers cassés (un « 4K » de 800 Mo, un sample). Le tri qualité, c'est le travail des **scores CF**, pas du plancher. Les anciens planchers (ex. `34,5` sur WEB 2160p) rejetaient des releases **légitimes et bien scorées** — typiquement les 4KLight/WEBRip ~2,5–5 Go (Neostark, BONBON) — d'où des « release rejetée : taille trop petite » en recherche.
- **`max` = garde-fou anti-obèses** : borne dure par grab contre les encodes énormes ou mal taggés, hors cible **scène FR compacte** (et lourds pour le disque comme pour le ratio). Calibré pour laisser passer le **premium documenté** (DV/Atmos ~17–26 Go en 4K film) et bloquer au-delà.
- Anti-churn complémentaire : `upgrade_score_increment` **500** dans `ops/06` — pas de re-téléchargement complet pour un gain de moins de 500 points CF (Repack +120, Season Pack +120…) ; ça évite aussi de casser le seed/cross-seed pour rien.

#### Radarr — `FR-Media-Radarr`

**Limite API** : `max_size` **≤ 2000** (Mo/min).

| Qualité | min | preferred | max | ~120 min film |
|---------|-----|-----------|-----|----------------|
| **Bluray / WEB 1080p** | 8 | **42–48** | 150 | min ~1 Go ; cible **~5 Go** (SUPPLY compact H265 ~2–7 Go) ; plafond ~18 Go |
| **Bluray-720p / WEB 720p** | 5 | **35** | 60 | min ~0,6 Go ; plafond ~7 Go |
| **Bluray-2160p** | 17 | **50** | 250 | 4KLight ~2,5–8 Go ; plafond ~30 Go |
| **WEB 2160p** | 17 | **95** | 250 | 4KLight WEBRip ~2,5–5 Go **passe** ; **SUPPLY** compact ~10–14 Go ; DV/Atmos ~17–26 Go ; plafond ~30 Go |

Qualités de secours (720p/HDTV en fallback des profils films) : `min` anti-junk, `max` plafonné, `preferred` aligné sur la résolution équivalente — plus de `preferred 1990` qui visait « le plus gros possible ».

#### Sonarr — `FR-Media-Sonarr` (séries)

| Qualité | min | preferred | max | ~45 min épisode |
|---------|-----|-----------|-----|-----------------|
| **Bluray-1080p** | 8 | **55** | 120 | min ~0,36 Go ; cible ~2,5 Go ; plafond ~5,4 Go |
| **WEB / HDTV 1080p** | 8 | **50–60** | 100 | **Slay3R** ~2,4–3 Go ; plafond ~4,5 Go |
| **Bluray / WEB / HDTV 720p** | 5 | **35–45** | 50 | épisodes compacts ; plafond ~2,3 Go |
| **Bluray / WEB 2160p** | 17 | **45 / 55** | 150 | 4K série compact (~1–1,5 Go/ép. accepté) ; plafond ~6,8 Go |

#### Sonarr — `FR-Media-Anime-Sonarr` (animé)

| Qualité | min | preferred | max | ~24 min épisode |
|---------|-----|-----------|-----|-----------------|
| **Bluray / WEB 1080p** | **5** | **38–42** | 80 | min ~120 Mo ; cible ~0,9–1 Go ; plafond ~1,9 Go |
| **Bluray / WEB 720p** | **5** | **25–30** | 40 | fansub / BDRip compacts ; plafond ~1 Go |
| **Bluray / WEB 2160p** | 5 / 17 | **40 / 50** | 120 | animé 4K compact ; plafond ~2,9 Go |

### Delays

| Preset | Fichier | Comportement |
|--------|---------|--------------|
| **FR-Delay-Radarr** | `ops/07` | Torrent only, délai 0, bypass si déjà meilleure qualité |
| **FR-Delay-Sonarr** | `ops/09` | Idem Sonarr |

---

---

[← Index doc](../README.md) · [← README](../../README.md)

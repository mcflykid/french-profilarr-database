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

#### Radarr — `FR-Media-Radarr`

**Limite API** : `max_size` **≤ 2000** (Mo/min).

| Qualité | min | preferred | max | ~120 min film |
|---------|-----|-----------|-----|----------------|
| **Bluray / WEB 1080p** | 12,5 | **48** | 2000 | min ~1,5 Go ; cible **~5 Go** (SUPPLY compact H265 ~2–7 Go) |
| **Bluray-720p / WEB 720p** | 12,5 | **35** | 1000–2000 | ~4,2 Go cible |
| **Bluray-2160p** | 17 | **50** | 2000 | 4KLight ~2,5–8 Go |
| **WEB 2160p** | 34,5 | **95** | 2000 | **SUPPLY** compact ~10–14 Go ; DV/Atmos ~17–26 Go via `max` |

#### Sonarr — `FR-Media-Sonarr` (séries)

| Qualité | min | preferred | max | ~45 min épisode |
|---------|-----|-----------|-----|-----------------|
| **Bluray-1080p** | 17,5 | **55** | 1000 | min ~0,8 Go ; cible ~2,5 Go |
| **WEB 1080p** | 12,5 | **60** | 1000 | **Slay3R** ~2,4–3 Go |
| **Bluray / WEB 720p** | 12,5–17,5 | **40–45** | 500–1000 | épisodes compacts |
| **Bluray / WEB 2160p** | 17 / 34,5 | **45 / 55** | 1000 | 4K série compact |

#### Sonarr — `FR-Media-Anime-Sonarr` (animé)

| Qualité | min | preferred | max | ~24 min épisode |
|---------|-----|-----------|-----|-----------------|
| **Bluray / WEB 1080p** | **5** | **38–42** | 1000 | min ~120 Mo ; cible ~0,9–1 Go |
| **Bluray / WEB 720p** | **5** | **28–30** | 500 | fansub / BDRip compacts |
| **Bluray / WEB 2160p** | 5 / 17 | **40 / 50** | 1000 | animé 4K compact |

### Delays

| Preset | Fichier | Comportement |
|--------|---------|--------------|
| **FR-Delay-Radarr** | `ops/07` | Torrent only, délai 0, bypass si déjà meilleure qualité |
| **FR-Delay-Sonarr** | `ops/09` | Idem Sonarr |

---

---

[← Index doc](../README.md) · [← README](../../README.md)

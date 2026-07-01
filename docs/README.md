# Documentation

Référence **complète** du dépôt — pour les utilisateurs, les mainteneurs et les **IA** qui feront évoluer la base.  
Chaque page garde un **En bref** + schémas, puis le **détail technique** (tableaux, `ops/`, tests).

[← Retour au README](../README.md)

---

## Commencer par le « pourquoi »

| Document | Rôle |
|----------|------|
| **[comprendre/pourquoi.md](comprendre/pourquoi.md)** | **Document central** : objectif du projet, décisions vs alternatives, ce qu’il ne faut pas casser, carte de toute la doc |

Ensuite : [principes.md](comprendre/principes.md) (synthèse) → pages thématiques ci-dessous.

---

## 1 — `installer/` (mise en route)

| Fichier | Contenu complet |
|---------|-----------------|
| [guide.md](installer/guide.md) | Pull, Compile, Sync, ordre Save, checklist Radarr/Sonarr, Docker |
| [interface.md](installer/interface.md) | Sync, Drift, Upgrades, lecture du score 22k/60k |
| [profils.md](installer/profils.md) | 9 profils `FR-*`, exclusions, tags UI |
| [tailles.md](installer/tailles.md) | Mo/min, tableaux Radarr/Sonarr/Anime, delays, limite API 2000 |

---

## 2 — `comprendre/` (scores et règles)

| Fichier | Contenu complet |
|---------|-----------------|
| **[pourquoi.md](comprendre/pourquoi.md)** | Intentions, alternatives refusées, guide IA |
| [principes.md](comprendre/principes.md) | Priorités, tableau choix, seuils `ops/06` |
| [langue.md](comprendre/langue.md) | Hiérarchie FR, **pourquoi chaque palier**, regex `ops/02` |
| [equipes.md](comprendre/equipes.md) | Scores `FR-Team-*`, tiers, 4KLight/HDLight/WEBRip |
| [image-son.md](comprendre/image-son.md) | HDR, audio (exclusions), codecs, streamers |
| [calibrage.md](comprendre/calibrage.md) | C411 vs parser, filtres, workflow, **journal** |
| [torr9.md](comprendre/torr9.md) | Règles Torr9, nomenclature, équipes, API/RSS (sans secrets) |
| [limites.md](comprendre/limites.md) | **PCD = tracker** vs **Plex/tMM** ; torrent / `.mkv` ; motifs rename Plex, tests `ops/12` |
| [hors-scope.md](comprendre/hors-scope.md) | Slots, rejets détaillés, roadmap |

---

## 3 — `contribuer/` (évolution du dépôt)

| Fichier | Contenu complet |
|---------|-----------------|
| [maintenir.md](contribuer/maintenir.md) | `validate.py`, arborescence `ops/`, checklist doc, **règles IA** |

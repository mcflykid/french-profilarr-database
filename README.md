# Guide de Configuration Profilarr : Architecture Optimisée pour les Trackers Francophones

Ce dépôt contient une base de données de configuration **Profilarr** (compatible avec Radarr et Sonarr) entièrement optimisée pour la scène francophone et ses trackers (comme *La Cale* ou autres plateformes privées FR).

L'objectif de cette configuration est d'automatiser entièrement la recherche, le téléchargement, le renommage et la mise à niveau (upgrade) de vos films et séries avec une précision chirurgicale, sans accumuler de fichiers inutiles ("fichiers fantômes").

---

## 1. Philosophie et Architecture du Dépôt

Contrairement aux configurations standards (souvent calquées sur la scène anglophone), cette architecture a été pensée pour répondre spécifiquement aux règles et habitudes de la scène francophone.

### Structure des Dossiers
* **`/regex_patterns`** : Contient les briques de détection de base (les expressions régulières). C'est le "cerveau" qui sait lire et analyser les titres des releases.
* **`/custom_formats`** : Assemble les regex pour créer des règles métiers compréhensibles par Radarr et Sonarr.
* **`/profiles`** : Définit vos profils de qualité (4K, 1080p, 720p) pour Radarr et Sonarr, en leur attribuant des scores précis.
* **`/media_management`** : Regroupe la configuration globale pour le renommage parfait (`naming.yml`) et les limites de taille par résolution (`quality_definitions.yml`).

---

## 2. Logique de Scoring Linguistique

La priorité absolue de cette configuration est de vous garantir des médias en français de la meilleure qualité possible, tout en gérant intelligemment la version originale sous-titrée (VOSTFR).

| Format | Score | Rôle & Justification |
| :--- | :--- | :--- |
| **`FR - MULTI.VF2`** | `+60 000` | Priorité maximale. Contient la version originale, la vraie VF (VFF) **et** la version québécoise de qualité (VF2/VFQ). Idéal pour la compatibilité maximale. |
| **`FR - MULTI.VFF`** | `+50 000` | Version préférée. Contient la version originale et la vraie piste de doublage française (TrueFrench/VFF). |
| **`FR - VF2`** | `+40 000` | Releases contenant uniquement les pistes françaises VFF + VFQ (sans VO). |
| **`FR - VFF`** | `+30 000` | Releases contenant uniquement la vraie VF (sans VO et sans VFQ). |
| **`FR - VOSTFR`** | `+10 000` | Accepté en guise de secours (fallback) si aucune version doublée en français n'est encore disponible sur les trackers. |
| **`FR - VFQ` (Seul)** | `-999 999` | Bloqué. Évite le téléchargement de releases contenant uniquement le doublage québécois (accent prononcé, expressions locales non adaptées à l'exploitation en France). |

---

## 3. Classification des Groupes de Release (Tiers FR)

Afin d'éviter le téléchargement de fichiers mal encodés, nous avons classé les teams de la scène francophone en deux grands Tiers simplifiés. Cela permet à Radarr/Sonarr de choisir la release d'une team réputée si deux fichiers ont la même taille et la même langue.

### Tier 01 : L'Élite (Score : `+1800`)
Regroupe les teams les plus actives, rigoureuses sur le débit vidéo (bitrate), le respect des couleurs (gamut) et le traitement audio.
* **Teams incluses** : `TFA`, `FW` (FORWARD), `THESYNDICATE`, `TyHD`, `Slay3R`, `AMEN`, `BOUBA`, `BOUC`, `OZEF`, `QTZ`, `GKS`, `KAAZA`, `TayTO`, `M@x`, `B@tman`.

### Tier 02 : La Scène & Qualité secondaire (Score : `+1700`)
Regroupe les équipes secondaires très correctes ainsi que la scène Warez historique francophone.
* **Teams incluses** : `ENIGMA`, `NEOSTARK`, `HYPERION`, `TOXIC`, `N3ZUKO`, `J4CK`, `Maxadonf`, `D4RK`, `R3MIX`, `Themouche`, `SUPERFLU`, `TLC`, `LKT`, `ZTM`, `TMB`, `TSR`, `COCAIN`, `ATE` ainsi que la scène classique (`LOST`, `PRESTiGE`, `GORE`, `MULTiPLY`...).

---

## 4. Traitement Technique (Audio, HDR et Sécurité)

### Vidéo & HDR (Profils 4K)
Le profil 4K favorise grandement les formats HDR dynamiques pour exploiter pleinement les téléviseurs modernes :
* **`Dolby Vision`** (`+3000`) et **`HDR10+`** (`+2000`) sont fortement valorisés.
* **`AV1`** (`-999 999`) : **Bloqué**. Bien que ce codec soit très performant, une grande majorité de clients matériels (anciennes TV, Box Android d'entrée de gamme) ne possèdent pas de décodeur matériel AV1, provoquant des saccades ou du transcodage CPU inutile sur Plex/Jellyfin.
* **`x264 (2160p)`** (`-999 999`) : **Bloqué**. Le 4K doit impérativement utiliser le codec x265/HEVC sous peine de générer des fichiers inutilement lourds et mal optimisés.

### Audio spatialisé et Lossless
Le système cherche d'abord le meilleur son possible pour votre Home-Cinéma :
* **`TrueHD Atmos` / `DTS:X`** (`+1000`)
* **`TrueHD` / `DTS-HD MA`** (`+900`)

---

## 5. Fiabilité : Gestion des Repacks

Dans le monde du partage, une release peut parfois être publiée avec un bug (décalage de sous-titres, piste audio manquante). Les teams publient alors des correctifs.
Notre configuration surveille et attribue un score progressif aux tags de correction :
* **`Repack3`** / **`V4`** (`+8`)
* **`Repack2`** / **`V3`** (`+7`)
* **`Repack1`** / **`PROPER`** / **`REPACK`** / **`V2`** (`+6`)

*Pourquoi des scores si petits (+6, +7, +8) ?* Cela permet de dépasser la version originale buggée d'un cheveu, déclenchant ainsi un téléchargement de mise à jour automatique sans perturber le reste de la logique de score linguistique ou de team.

---

## 6. Naming & Standardisation Plex/Jellyfin

Le fichier `media_management/naming.yml` applique une structure de nommage rigoureuse.

### Avantages :
1. **Compatibilité à 100%** : Inclusion systématique de l'ID unique (TMDB pour les films, TVDB pour les séries) dans les noms de dossiers. Plex ou Jellyfin identifieront vos médias instantanément sans jamais faire d'erreur d'association.
2. **Transparence** : Injection automatique des Custom Formats détectés (ex: `[FR - MULTI.VFF]`) directement dans le nom de fichier final pour savoir en un coup d'œil ce qui se trouve sur votre stockage.
3. **Respect du Partage** : Le nom du groupe de release final (le "Release Group" à la fin du fichier, ex: `-TFA`) est conservé. C'est indispensable pour pouvoir continuer de partager (seeder) vos fichiers sur vos trackers privés sans enfreindre les règles de nommage.

### Exemple de rendu :
* **Film** : `/Insaisissables (2013) {tmdb-117251}/Insaisissables (2013) {tmdb-117251} [FR - MULTI.VFF][Bluray-1080p][h264][DTS-HD MA 5.1]-TFA.mkv`
* **Série** : `/Severance (2022) {tvdb-368294}/Season 01/Severance - S01E01 - Good News About Hell [FR - MULTI.VFF][WEBDL-1080p][h264][EAC3 5.1]-FW.mkv`

# French Profilarr Database

Base **[PCD](https://github.com/Dictionarry-Hub/schema) 1.1.0** pour **[Profilarr v2](https://v2.dictionarry.dev)** — Radarr et Sonarr, orientée **scène française privée** (releases francophones, tags et habitudes d’encodage des trackers privés FR, sans calquer les profils « internationaux » génériques).

| | |
|---|---|
| **Format** | `pcd.json` + `ops/*.sql` uniquement (comme [Dumpstarr/Database](https://github.com/Dumpstarr/Database)) |
| **Profilarr** | ≥ 2.0.0 |
| **Version PCD** | 2.0.0 |
| **Contenu** | ~65 custom formats · ~69 regex · 10 profils qualité · presets media · delays · tests parser |

Ce dépôt n’est **pas** un fork Dictionarry « à peine retouché » : la couche **FR** (langue, équipes, signatures scène, exclusions) et l’articulation avec les profils ont été pensées **quasi depuis zéro**, en s’appuyant sur la technique audio/HDR/codec de [Dictionarry-Hub/database](https://github.com/Dictionarry-Hub/database). Des cas limites ou incohérences sont possibles — les [issues](https://github.com/mcflykid/french-profilarr-database/issues) sont les bienvenues.

---

## Table des matières

1. [Objectif et public](#objectif-et-public)
2. [Historique du dépôt](#historique-du-dépôt)
3. [Démarrage Profilarr](#démarrage-profilarr)
4. [Structure du dépôt](#structure-du-dépôt)
5. [Philosophie de conception](#philosophie-de-conception)
6. [Langue française (custom formats)](#langue-française-custom-formats)
7. [Équipes et paliers](#équipes-et-paliers)
8. [Signatures scène (4KLight, HDLight, Hybrid)](#signatures-scène-4klight-hdlight-hybrid)
9. [Technique : HDR, audio, codecs](#technique--hdr-audio-codecs)
10. [Profils qualité `FR-*`](#profils-qualité-fr-)
11. [Media management et delays](#media-management-et-delays)
12. [Scoring : ce que Radarr fait (et ne fait pas)](#scoring--ce-que-radarr-fait-et-ne-fait-pas)
13. [Créneaux catalogue (slots) et tailles cibles](#créneaux-catalogue-slots-et-tailles-cibles)
14. [Ce qu’on a volontairement rejeté](#ce-quon-a-volontairement-rejeté)
15. [Tests et validation](#tests-et-validation)
16. [Références](#références)

---

## Objectif et public

**But** : quand Radarr ou Sonarr choisit une release sur un indexeur, le **score custom format** reflète ce que la scène FR valorise :

- **Langue** : MULTI avec VF2/VFF/VFQ/VOQ, puis VF mono, puis VOSTFR en secours.
- **Format** : encodes HEVC compacts en 4K (4KLight, WEB 2160p « HC optimisé »), pas des remplissages x264@UHD ni des remux massifs.
- **Qualité annoncée** : DV, HDR10+, audio premium quand le **titre** de la release le mentionne.
- **Équipe** : bonus pour les groupes documentés (QTZ, TyHD, AMEN, Slay3R, etc.) sans maintenir ~900 fichiers regex « un par team ».

**Public** : utilisateurs de **trackers privés francophones** (avec ou sans « slots » catalogue), souvent en **cross-seed** (même fichier, noms parfois différents selon l’indexeur).

**Hors périmètre** : profils « internationaux » type TRaSH/Dumpstarr purs, usenet-first, remux-first, ou chartes qui **bannissent** certains tags (ex. VFQ) que cette base **accepte** volontairement.

---

## Historique du dépôt

Le projet a évolué en plusieurs étapes (commits Git ; anciennes archives `backup/` supprimées du dépôt car redondantes) :

| Phase | Forme | Notes |
|-------|--------|--------|
| v1 | YAML (`regex_patterns/`, `custom_formats/`, `profiles/`) | Profilarr v1, annotations FR |
| v2.5 → v3 | PCD + `ops/*.sql` | Migration schema 1.1.0 |
| v4 / **2.0.0 actuel** | Racine = `pcd.json` + `ops/` + `scripts/` + README | Alignement [Dumpstarr](https://github.com/Dumpstarr/Database) (seuils profil) |

Pour retrouver d’anciennes copies (snapshot, squelette PCD vierge, pre-reset) : `git log` puis `git show <commit>:backup/...` (ex. commit `c1d52ee` avant suppression du dossier).

**À importer dans Profilarr** : uniquement la **racine** du dépôt.

---

## Démarrage Profilarr

### 1. Base Git (dépôt PCD)

1. Lier `https://github.com/mcflykid/french-profilarr-database`
2. **Pull** — importe les 11 fichiers `ops/*.sql` (log `updated:11` = OK)
3. **Compile** — **obligatoire** : remplit le cache (profils, delays, presets `FR-Media-Radarr` visibles dans l’UI)

Sans **Compile**, les listes déroulantes peuvent rester vides ou obsolètes.

### 2. Sync par instance Radarr / Sonarr

Le **Pull** sur la base **ne configure pas** Radarr/Sonarr. Menu **Arr** → ton instance → onglet **Sync** (ce n’est pas le Pull de la base).

Le bandeau *« Quality profiles require media management settings and a delay profile »* = sections **non sauvegardées** (cliquer **Save** sur chaque bloc).

**Ordre obligatoire** (tant qu’une section est « dirty », l’avertissement reste) :

```text
1. Media Management  →  Save
2. Delay profile     →  Save
3. Quality profiles  →  Save  →  Sync
```

#### Media Management — un preset par application

Ce n’est **pas** un preset par profil `FR-Films-1080p`. **Un seul triplet** pour toute l’instance Radarr (ou Sonarr) :

| Menu Profilarr | Radarr | Sonarr |
|----------------|--------|--------|
| Naming | **`FR-Media-Radarr`** | **`FR-Media-Sonarr`** |
| Quality definitions | **`FR-Media-Radarr`** | **`FR-Media-Sonarr`** |
| Media settings | **`FR-Media-Radarr`** | **`FR-Media-Sonarr`** |

Les **trois** menus doivent pointer vers le **même** nom (préfixe `FR-` comme les profils `FR-Films-4K`, `FR-Series-1080p`, etc.).

#### Delay profile

| Instance | Choisir puis **Save** |
|----------|----------------------|
| Radarr | **`FR-Delay-Radarr`** |
| Sonarr | **`FR-Delay-Sonarr`** |

#### Profils qualité — cases à cocher

Exemples Radarr : `FR-Films-1080p`, `FR-Films-4K`, `FR-Films-720p`, `FR-Films-Any`  
Exemples Sonarr : `FR-Series-1080p`, `FR-Series-4K`, `FR-Anime-1080p`, etc.

**Save**, puis **Sync** sur la carte instance (ou Pull → Compile → Sync si la base Git vient de changer).

#### Logs `arr.sync.* (skipped)`

Après un Pull, tu peux voir :

```text
arr.sync.qualityProfiles (skipped)
arr.sync.delayProfiles (skipped)
arr.sync.mediaManagement (skipped)
```

Profilarr a lancé les jobs, mais **aucune config Sync n’est enregistrée** pour cette instance — ce n’est **pas** une erreur SQL du dépôt.

**À faire :** Arr → Radarr/Sonarr → **Sync** → configurer chaque bloc → **Save** → **Sync**. Tant que les logs affichent `skipped` au lieu de `qualityProfiles: N item(s)`, la config instance n’est pas sauvegardée.

#### Checklist Radarr

- [ ] Base : **Pull** + **Compile**
- [ ] Arr → Radarr → Sync → Media : `FR-Media-Radarr` sur les **3** menus → **Save**
- [ ] Delay : **`FR-Delay-Radarr`** → **Save**
- [ ] Quality profiles : au moins un `FR-Films-*` → **Save**
- [ ] Bouton **Sync** sur l’instance

#### Checklist Sonarr

- [ ] Base : **Pull** + **Compile**
- [ ] Arr → Sonarr → Sync → Media : `FR-Media-Sonarr` × 3 → **Save**
- [ ] Delay : **`FR-Delay-Sonarr`** → **Save**
- [ ] Quality profiles : `FR-Series-*` / `FR-Anime-*` → **Save**
- [ ] **Sync**

### 3. Docker Compose (homelab, optionnel)

Exemple [Profilarr v2](https://v2.dictionarry.dev/profilarr-setup/installation) + parser pour tests CF/QP. Migration v1 : sauvegarder l’appdata Profilarr puis repartir vide.

Variables utiles : `DOCKERDIR`, `PROFILARR_PORT` (défaut 6868), `TZ`, `PUID`, `PGID`. Derrière reverse proxy : définir `ORIGIN`. Sans parser : retirer le service `profilarr-parser`, `depends_on`, `PARSER_HOST` et `PARSER_PORT`.

```yaml
name: profilarr

services:
  profilarr-parser:
    image: ghcr.io/dictionarry-hub/profilarr-parser:latest
    container_name: profilarr-parser
    cpus: 0.25
    mem_limit: 256m
    mem_reservation: 64m
    security_opt:
      - no-new-privileges:true
    restart: unless-stopped
    networks:
      - homelab_apps
    expose:
      - "5000"
    healthcheck:
      test: ["CMD-SHELL", "wget -qO- http://127.0.0.1:5000/health >/dev/null 2>&1 || exit 1"]
      interval: 30s
      timeout: 5s
      retries: 3
      start_period: 10s

  profilarr:
    image: ghcr.io/dictionarry-hub/profilarr:latest
    container_name: profilarr
    cpus: 0.5
    mem_limit: 512m
    mem_reservation: 128m
    security_opt:
      - no-new-privileges:true
    restart: unless-stopped
    networks:
      - homelab_apps
    ports:
      - "${PROFILARR_PORT:-6868}:6868/tcp"
    volumes:
      - "${DOCKERDIR}/appdata/profilarr:/config"
      - /etc/localtime:/etc/localtime:ro
    environment:
      TZ: ${TZ:-Europe/Paris}
      PUID: ${PUID:-1000}
      PGID: ${PGID:-1000}
      UMASK: "022"
      AUTH: on
      PARSER_HOST: profilarr-parser
      PARSER_PORT: "5000"
    depends_on:
      profilarr-parser:
        condition: service_healthy
    healthcheck:
      test: ["CMD-SHELL", "curl -sf http://127.0.0.1:6868/api/v1/health || exit 1"]
      interval: 1m
      timeout: 10s
      retries: 3
      start_period: 45s

networks:
  homelab_apps:
    external: true
```

---

## Structure du dépôt

```text
pcd.json                 # Métadonnées PCD (nom, version, schema 1.1.0)
ops/
  01-tags.sql            # Tags UI + catégories CF
  02-regex.sql           # Motifs (pattern = détection ; description = aide UI)
  03-custom-formats.sql  # Définitions CF (include_in_rename = 0 partout)
  04-custom-format-conditions.sql  # Conditions + liaisons regex
  05-custom-format-tags.sql        # Tags par CF
  06-quality-profiles.sql          # Profils FR-* + scores + tags profil
  07-media-management.sql          # FR-Media-Radarr, FR-Media-Sonarr, FR-Delay-Radarr
  09-profile-media-bundles.sql     # FR-Delay-Sonarr uniquement
  10-profile-ui-tags.sql           # Tags Radarr/Sonarr/Films/Series (pas tag SQL "anime")
  11-custom-format-tests.sql       # Tests parser CF (optionnel UI)
  12-quality-profile-tests.sql     # Simulations profil (Momie, POI, etc.)
scripts/
  validate.py            # Intégrité + compile + regex Sonarr-safe
```

**Préfixe `FR-`** : tout ce qui est **spécifique marché français** (langue, teams, blockers, signatures, repacks). Le reste reprend les noms Dictionarry (`HDR10+`, `Dolby Vision`, `Remux`, …) pour rester compatible et rebaseable.

**Descriptions regex** : texte **sans astérisque `*`** — Profilarr peut concaténer description + pattern vers Sonarr et provoquer des erreurs de sync.

---

## Philosophie de conception

### Couche technique vs couche FR

| Couche | Source | Exemples |
|--------|--------|----------|
| **Technique** | Dictionarry / TRaSH | HDR10+, DV, DTS-HD MA, x265, streamers NF/AMZN, Full Disc |
| **FR** | Conventions scène privée | `FR-MULTI-VFF`, `FR-4KLight`, `FR-Team-QTZ`, `FR-Blockers` |

On a **fusionné** des regex Dictionarry en bundles projet (`FR-Regex-Streamers-Premium`, `FR-Regex-Atmos-Bundle`, …) pour limiter la duplication sans changer la sémantique de détection.

### Principes tenus sur toute la base

| Choix | Pourquoi |
|-------|----------|
| **`rename = 0`** | Conserver le nom d’annonce tel quel (habitude trackers FR, cross-seed, lisibilité ratio) |
| **Remux / Full Disc / AV1 / Upscaled à -999999** | Encodes domestiques uniquement ; compat matériel ; pas de remplissage catalogue |
| **`propers_repacks = doNotPrefer`** | Les repacks sont gérés par **`FR-Repack`** / **`FR-Repack-2`** / **`FR-Repack-3`** (scores CF), pas l’option native Radarr |
| **Torrent only, délai 0** | `FR-Delay-Radarr` / `FR-Delay-Sonarr` : `only_torrent`, `torrent_delay = 0`, bypass si déjà meilleure qualité |
| **x265 favorisé en 1080p/720p** | Contrairement à Dumpstarr qui pénalise souvent HEVC sous 2160p — la scène FR pousse les encodes compacts |
| **Pas de ban VFQ** | VFQ/VOQ passent par **`FR-VF2`** / **`FR-MULTI-VF2`** ; politique ajustable par scores, pas par exclusion aveugle |
| **Un preset media par app** | Modèle Profilarr v2 + Dictionarry : `FR-Media-Radarr` / `FR-Media-Sonarr`, pas un bundle par profil `FR-Films-4K` |

### Seuils profil (alignement Dumpstarr)

Héritage [Dumpstarr/Database](https://github.com/Dumpstarr/Database) pour les **seuils Radarr/Sonarr natifs** ; la **priorité FR** reste dans les **scores CF** :

| Profil type | `minimum_custom_format_score` | `upgrade_until_score` |
|-------------|--------------------------------|------------------------|
| Films 1080p | **750** | 10000 |
| Films / Series / Anime **4K** | **1000** | 10000 |
| Series / Anime 1080p/720p, Films 720p/Any | **0** | 10000 |

Ancienne base interne utilisait `minimum = 20000` et `upgrade_until = 888888` — remplacé pour coller à Dumpstarr et éviter des upgrades bloqués de façon absurde.

---

## Langue française (custom formats)

### Hiérarchie des scores (tous profils `FR-*`)

Ordre de priorité **langue** (scores identiques sur Films / Series / Anime ; la résolution change surtout les malus codec) :

| Custom format | Score | Condition (résumé) |
|---------------|------:|---------------------|
| **FR-MULTI-VF2** | 100 000 | `MULTI` **et** (`VF2` \| `VFQ` \| `VOQ`) |
| **FR-MULTI-VFF** | 90 000 | `MULTI` **et** tag FR hors VF2/VFQ/VOQ |
| **FR-VF2** | 70 000 | VF2 / VFQ / VOQ sans MULTI obligatoire |
| **FR-VFF** | 60 000 | VFF, TRUEFRENCH, VFI, VOF, FRENCH, etc. |
| **FR-VOSTFR** | 20 000 | VOSTFR, SUBFRENCH, FANSUB, FASTSUB |

**Règle importante** : `FR-MULTI-VF2` et `FR-MULTI-VFF` sont **mutuellement exclusifs** sur une même release (deux conditions AND différentes). Une release `MULTI.VFF` ne doit **pas** matcher les deux — les tests parser (`ops/11`) vérifient ce point.

### Regex langue (`ops/02`)

| Regex | Rôle |
|-------|------|
| **FR-Regex-MULTI** | `MULTI`, `MULTI.FRENCH`, `MULTI.TRUEFRENCH`, `MULTITRUEFRENCH` ; `\bMULTI\b` seul (évite `MultiVerse`) |
| **FR-Regex-VFF** | VFF, TRUEFRENCH, VFI, VOF, FRENCH, `MULTI.FRENCH`, VF générique (hors VFQ/VF2) |
| **FR-Regex-VF2** | VF2, VFQ, VOQ |
| **FR-Regex-VOSTFR** | VOSTFR, SUBFRENCH, FANSUB, FASTSUB |

**Variantes cross-indexeurs** couvertes : `MULTI.VFF`, `MULTI.FRENCH`, `MULTI.TRUEFRENCH`, `MULTITRUEFRENCH`, `TRUEFRENCH` seul, etc. — cas réel **La Momie** (même rip, titres C411 vs autre tracker).

**Limite connue** : Radarr ne lit que le **titre d’annonce**. Deux indexeurs peuvent nommer différemment la même release → écarts de score (voir [Scoring](#scoring--ce-que-radarr-fait-et-ne-fait-pas)).

---

## Équipes et paliers

### Deux niveaux (choix architecture)

| Niveau | CF | Rôle |
|--------|-----|------|
| **Équipes documentées** | `FR-Team-*` (15 groupes) | Bonus **fort** et stable (QTZ, AMEN, TyHD, Slay3R, TFA, …) |
| **Longue traîne** | `FR-Tier-01`, `FR-Tier-02` | Petits bonus pour encodeurs listés en regex compacte |

On **n’a pas** adopté le modèle [Profilarr-database-french-regex](https://github.com/Jojont54/Profilarr-database-french-regex) (~1 regex / team × ~900 fichiers) : maintenance lourde, rebase Dictionarry difficile, peu de gain sur les cas réels observés (ex. Momie : même groupe, tags HDR différents).

### Scores équipes (identiques sur tous les profils)

| Équipe | Score | Profil typique |
|--------|------:|----------------|
| **FR-Team-QTZ** | 12 000 | 4KLight Bluray, référence qualité/taille |
| **FR-Team-AMEN** | 9 500 | WEB 2160p compact DV/HDR10+ |
| **FR-Team-BONBON** | 9 200 | 4KLight / WEBRip ~2,5–5 Go |
| **FR-Team-TyHD** | 9 000 | WEB/WEBRip 2160p HEVC compact |
| **FR-Team-THESYNDiCATE** | 8 000 | WEB 2160p x265 |
| **FR-Team-SUPPLY** | 7 800 | WEB 2160p premium Atmos |
| **FR-Team-BOUC** | 7 700 | WEB 2160p premium MULTI |
| **FR-Team-TFA** | 7 500 | WEB 2160p catalogue |
| **FR-Team-FW** | 7 200 | Forward, volume |
| **FR-Team-ENIGMA** | 6 200 | VFQ, blockbusters |
| **FR-Team-TOXIC** | 6 400 | 1080p HDLight |
| **FR-Team-PopHD** | 6 500 | 1080p compact x264 |
| **FR-Team-Slay3R** | 5 500 | WEB 2160p volume / exclus |
| **FR-Team-HYPERION** / **OZEF** | 2 000 | Remux — détectés mais **jamais retenus** (-999999 Remux) |
| **FR-Tier-01** | 2 000 | Longue traîne haute (BOUBA, NEOSTARK, …) |
| **FR-Tier-02** | 1 000 | Longue traîne basse + **DELIRIUS** (séries `MULTI.FRENCH`) |

Détection groupe : suffixe `-TEAM` en fin de titre (`(?<=^|[\s.-])TEAM\b`) — pas de condition `release_group` séparée pour l’instant (le groupe est en général déjà dans le nom d’annonce FR).

### Équipes « remux only »

**HYPERION**, **OZEF** : reconnus pour transparence et logs, mais **Remux = -999999** sur tous les profils → aucun impact pratique sur la sélection.

---

## Signatures scène (4KLight, HDLight, Hybrid)

Tags **métier** de la scène FR (pas Dictionarry générique) :

| CF | Détection | Usage scoring |
|----|-----------|----------------|
| **FR-4KLight** | `4KLight`, `4K.Light` | Fort bonus **4K** (+2500 sur `FR-Films-4K`) — cible cinéma maison compact |
| **FR-HDLight** | `HDLight` | Bonus 720p/1080p/Any ; neutre/malus relatif en 4K |
| **FR-Hybrid** | `HYBRID` | Bonus modéré UHD premium |
| **FR-Repack** / **-2** / **-3** | PROPER, REPACK, REAL… | Corrections qualité dans le titre |

**QTZ** est traité à la fois comme **équipe** (score team) et souvent associé aux sorties **4KLight** dans la pratique — pas de CF séparé `FR-Team-QTZ-4KLight` : un CF par **créneau**, pas par team×créneau (roadmap éventuelle : signatures dédiées sans retirer les tiers).

---

## Technique : HDR, audio, codecs

### Pack audio (héritage Dictionarry)

Une seule « famille » audio comptée par release : conditions **Exclure :** entre AAC, Dolby, DTS, TrueHD, FLAC, etc. — évite de cumuler +2000 DD et +1500 DTS sur la même ligne.

### HDR en 4K (`FR-Films-4K`, `FR-Series-4K`, `FR-Anime-4K`)

| CF | Score | Note |
|----|------:|------|
| Dolby Vision | 4500 | Priorité forte |
| Dolby Vision (Without Fallback) | -500 | DV « orphelin » dans le titre |
| **HDR10+** | **2000** | Resserré (était 2500) |
| HDR10 | 1000 | |
| **HDR** (générique) | **1000** | Relevé (était 500) — réduit l’écart quand un tracker omet `HDR10+` |
| Dolby Digital + | 400 | |
| **Dolby Digital** | **100** | Resserré (était 200) — AC3 parfois absent du titre |

**Cas d’usage** : même fichier **La Momie** — `…HDR10PLUS.AC3…` vs `…HDR…TRUEFRENCH…` sur deux indexeurs → écart de score **divisé ~par deux** tout en gardant la release mieux taguée devant.

### Codecs et exclusions

| CF | Comportement |
|----|----------------|
| **AV1** | -999999 partout (compat TV/box) |
| **x264 (2160p)** | -999999 en 4K (fake 4K AVC) |
| **x265** / **h265** | Bonus positifs (250 / 220 en 4K Films) |
| **VP9** | Malus léger (-200) |
| **Xvid** | Malus fort sur HD (-500) |
| **FR-Blockers** | -999999 — YIFY, FGT, NVENC, REMUX+x264 incohérent, etc. |

### Streamers

| CF | Contenu |
|----|---------|
| **FR-Streamer-Premium** | NF, AMZN, DSNP, ATVP, HBO Max, Paramount+ |
| **FR-Streamer-Standard** | NOW, Crunchyroll, iTunes WEB — **pas** Hulu/Peacock (peu de catalogue FR) |

---

## Profils qualité `FR-*`

### Tableau d’usage

| Profil | App | Usage recommandé |
|--------|-----|------------------|
| **FR-Films-1080p** | Radarr | Films 1080p — point de départ |
| **FR-Films-4K** | Radarr | Films 4K — DV/HDR, 4KLight, équipes WEB |
| **FR-Films-720p** | Radarr | Encodes compacts |
| **FR-Films-Any** | Radarr | Secours toutes résolutions (SD → Raw-HD), **sans remux** |
| **FR-Series-1080p** | Sonarr | Séries 1080p, Season Pack |
| **FR-Series-4K** | Sonarr | Séries 4K |
| **FR-Series-720p** | Sonarr | Séries compactes |
| **FR-Anime-1080p** | Sonarr | Animé 1080p (type Anime) |
| **FR-Anime-4K** | Sonarr | Animé 4K |
| **FR-Anime-720p** | Sonarr | Animé 720p |

Chaque profil **exclut** : Remux, Full Disc, AV1, Upscaled (+ x264@2160p sur 4K). **`FR-Films-Any`** garde langue/équipes mais n’impose pas une résolution.

### Tags profil UI (`ops/06` + `ops/10`)

Tags **Radarr**, **Sonarr**, **Films**, **Series**, résolutions **1080p** / **2160p** / **720p**, **French**, **anime** (filtre Sonarr type Anime — le tag SQL s’appelle `anime` en minuscule volontairement, pas de doublon avec `ops/10`).

---

## Media management et delays

### Presets media (`ops/07`)

Deux presets distincts (plus de gabarit `FR-Media-Base` ni de doublon « French - Radarr » dans la liste Profilarr) :

- **`FR-Media-Radarr`** — les **3** menus Profilarr Radarr (Naming, Quality definitions, Media settings) pointent sur ce nom.
- **`FR-Media-Sonarr`** — idem pour Sonarr.

### Tailles 2160p (choix scène compacte)

| Qualité | `preferred_size` (Mo/h) — Radarr & Sonarr |
|---------|-------------------------------------------|
| Bluray-2160p | **55** |
| WEBDL-2160p / WEBRip-2160p | **60** |

Objectif : favoriser les **encodes compacts** (4KLight, TyHD, AMEN ~2,5–8 Go) plutôt que des WEB-DL ~15 Go ou remux — aligné créneaux **HC OPTI** / **4KLight** du catalogue privé FR.

`ops/09` ne contient **que** `FR-Delay-Sonarr` ; **`FR-Delay-Radarr`** est dans `ops/07`.

**Ancien modèle** (commits Git antérieurs) : un bundle media **par profil** (`FR-Films-4K` = nom preset). Abandonné — Profilarr v2 impose **une config media par instance** (`FR-Media-Radarr` / `FR-Media-Sonarr`).

---

## Scoring : ce que Radarr fait (et ne fait pas)

| Situation | Profilarr / Radarr | qBittorrent cross-seed |
|-----------|-------------------|-------------------------|
| **Même titre** sur 2 trackers | **Même score** | Cross-seed OK |
| **Même fichier, titres différents** (HDR, TRUEFRENCH, AC3…) | **Scores différents** | Souvent OK si taille identique |
| **Tailles différentes** | Scores + qualité peuvent diverger | À vérifier manuellement |
| **`.mkv` dans le nom** | Peut changer le parsing | Hors scope CF |

**Ce n’est pas un bug Profilarr** : le score est calculé sur la **chaîne release_title** de l’indexeur, pas sur le hash ni le MediaInfo du fichier.

**Tests de référence** (`ops/12`) :

- **La Momie** (TMDB 564) — QTZ 4KLight vs Slay3R WEB vs TyHD vs Remux vs AV1
- Variante **TRUEFRENCH / HDR** (même taille Slay3R) pour cross-indexeur
- **Person of Interest** — `MULTI.FRENCH` (DELIRIUS)
- **Incendies** — VOQ sans MULTI vs MULTI.VOQ
- **Demon Slayer** — WEB CR MULTI VFF

---

## Créneaux catalogue (slots) et tailles cibles

Sur une partie de la scène FR, les indexeurs avec **catalogue à slots** organisent l’UHD en créneaux (noms indicatifs) :

| Créneau | Indications typiques | Alignement profil |
|---------|---------------------|-------------------|
| **COMPAT** | x264 1080p, large compat | Plutôt `FR-Films-1080p` / éviter en 4K |
| **HC OPTI** | HEVC 2160p compact (~2,5–8 Go), DV/HDR10+ | **Cible `FR-Films-4K`** — TyHD, AMEN, BONBON |
| **OPTI** | Gros WEB-DL 2160p (~15 Go, HDR10+, EAC3) | Accepté mais pas « rempli » par les preferred_size bas |

Trackers **sans slots** : même logique via **tags** (`MULTI.VFF`, `MULTI.FRENCH`, `4KLight`, …) — la base ne dépend pas d’un nom de tracker.

---

## Ce qu’on a volontairement rejeté

| Piste | Verdict |
|-------|---------|
| Fork ~1200 fichiers style Jojont54 | Non — autre produit, maintenance ×10 |
| **Ban VFQ** comme certaines bases FR | Non — VFQ/VOQ gérés par VF2/MULTI-VF2 |
| **`release_group`** en plus du titre | Pas urgent — le groupe est quasi toujours dans le nom FR |
| Tiers WEB vs Bluray séparés | Pas urgent — seed surtout du WEB |
| Bundles media par profil qualité | Remplacé par **FR-Media-Radarr/Sonarr** (Profilarr v2) |
| Éditions / CF « Banned* » internationaux redondants | Supprimés au profit de **FR-Blockers** |
| Repack natif Radarr « Prefer » | **doNotPrefer** + CF **FR-Repack*** |
| Noms de trackers dans la doc publique | Remplacé par **« scène française privée »** (charte, pas marque) |

**Roadmap interne** (non implémentée) : CF **signatures par créneau** (`FR-Signature-4KLight`, …) en **ajout** aux tiers, regex atomiques par team dans fichiers séparés — voir discussions projet ; ne pas retirer les tiers d’un coup.

---

## Tests et validation

### Validation locale (mainteneurs)

```bash
python3 scripts/validate.py
```

Contrôles :

- Intégrité `ops/` (doublons, FK, profils, presets `FR-Media-Radarr` / `FR-Media-Sonarr`)
- Compile SQLite simulé (schema 1.1.0 + tous les `ops/*.sql`)
- Descriptions regex sans `*` (sync Sonarr)

### Tests dans Profilarr (UI)

- **`ops/11`** : ~424 tests parser par CF (`doit` / `ne doit pas correspondre`)
- **`ops/12`** : entités TMDB + releases pour simulation profil qualité

Après modification : **Pull → Compile** sur la base, puis revérifier les tests dans l’UI Profilarr.

---

## Références

- [Profilarr v2 — Installation](https://v2.dictionarry.dev/profilarr-setup/installation)
- [Dictionarry-Hub/schema 1.1.0](https://github.com/Dictionarry-Hub/schema)
- [Dictionarry-Hub/database](https://github.com/Dictionarry-Hub/database)
- [Dumpstarr/Database](https://github.com/Dumpstarr/Database)
- [Issues](https://github.com/mcflykid/french-profilarr-database/issues)

---

*Base maintenue par [mcflykid](https://github.com/mcflykid) — inspirée par la communauté FR (TRaSH FR, bases contributives), sans être un fork officiel Dictionarry.*

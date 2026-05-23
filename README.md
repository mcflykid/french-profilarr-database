# French Profilarr Database

Base **[PCD](https://github.com/Dictionarry-Hub/schema) 1.1.0** pour **[Profilarr v2](https://v2.dictionarry.dev)** — Radarr et Sonarr orientés **scène française privée** (releases francophones, tags et habitudes d’encodage des trackers privés FR, pas un profil « international » générique recollé).

| | |
|---|---|
| **Format** | `pcd.json` + `ops/*.sql` ([modèle Dumpstarr](https://github.com/Dumpstarr/Database)) |
| **Profilarr** | ≥ 2.0.0 |
| **Version dépôt** | 2.0.0 |
| **Contenu** | 66 custom formats · 70 regex · 10 profils qualité · presets media · delays · ~443 tests parser |

Ce dépôt n’est **pas** un fork Dictionarry « à peine retouché » : la couche **FR** (langue, équipes, signatures, exclusions) est pensée **pour la scène privée francophone**, en réutilisant la technique audio/HDR/codec de [Dictionarry-Hub/database](https://github.com/Dictionarry-Hub/database). Retours terrain bienvenus via [issues](https://github.com/mcflykid/french-profilarr-database/issues).

---

## Tu arrives ici — par où commencer ?

1. **Utilisateur Profilarr** → [Démarrage rapide](#démarrage-rapide-profilarr) puis [Checklist Radarr/Sonarr](#checklist-radarr--sonarr).
2. **Comprendre les choix** → [En une minute](#en-une-minute) puis [Tous les choix expliqués](#tous-les-choix-expliqués).
3. **Mainteneur / contributeur** → [Structure du dépôt](#structure-du-dépôt) + [Tests](#tests-et-validation) + **[Maintien du README](#maintien-du-readme-obligatoire)**.

```text
Indexeur (titre release) → Radarr parse le titre → score = somme des Custom Formats
                        → comparaison qualité native + taille (preset media)
                        → release retenue ou upgrade
```

---

## Table des matières

1. [En une minute](#en-une-minute)
2. [Démarrage rapide Profilarr](#démarrage-rapide-profilarr)
3. [Tous les choix expliqués](#tous-les-choix-expliqués)
4. [Langue française](#langue-française)
5. [Équipes et paliers](#équipes-et-paliers)
6. [Signatures scène](#signatures-scène-4klight-hdlight-hybrid-repack)
7. [Technique : HDR, audio, codecs](#technique--hdr-audio-codecs)
8. [Profils qualité `FR-*`](#profils-qualité-fr-)
9. [Media management : tailles et delays](#media-management--tailles-et-delays)
10. [Calibrage sur releases réelles](#calibrage-sur-releases-réelles-workflow-principal)
11. [Scoring : limites Radarr](#scoring--limites-radarr)
12. [Créneaux catalogue (slots)](#créneaux-catalogue-slots)
13. [Ce qu’on rejette volontairement](#ce-quon-rejette-volontairement)
14. [Tests et validation](#tests-et-validation)
15. [Structure du dépôt](#structure-du-dépôt)
16. [Maintien du README (obligatoire)](#maintien-du-readme-obligatoire)
17. [Historique du dépôt](#historique-du-dépôt)
18. [Références](#références)

---

## En une minute

**Problème** : les profils TRaSH/Dumpstarr « internationaux » ne reflètent pas ce que la scène FR privée valorise (MULTI.VFF, 4KLight compact, équipes WEB, pas de remux catalogue).

**Solution** : des **Custom Formats** qui ajoutent des points au **titre de la release** tel que l’indexeur l’affiche :

| Priorité | Exemple de critère | Ordre de grandeur |
|----------|-------------------|-------------------|
| 1 | Langue (`FR-MULTI-VF2` > `FR-MULTI-VFF` > `FR-VFF` > `FR-VOSTFR`) | 20k–100k |
| 2 | Équipe documentée (`FR-Team-QTZ`, `Winks`, `Slay3R`, …) | 1k–12k |
| 3 | Signature / HDR / audio dans le titre | 100–4,5k |
| 4 | Exclusions dures | **-999999** (Remux, AV1, blockers) |

**Public** : utilisateurs de **trackers privés francophones**, souvent en **cross-seed** (même fichier, noms parfois différents selon l’indexeur).

**Hors périmètre** : usenet-first, remux-first, chartes qui **bannissent VFQ** (ici VFQ passe par `FR-VF2` / `FR-MULTI-VF2`).

---

## Démarrage rapide Profilarr

### Base Git (dépôt PCD)

1. Lier `https://github.com/mcflykid/french-profilarr-database`
2. **Pull** — importe les 11 fichiers `ops/*.sql` (`updated:11` = OK)
3. **Compile** — **obligatoire** : remplit le cache (profils, delays, presets `FR-Media-*` visibles dans l’UI)

Sans **Compile**, les listes peuvent rester vides ou obsolètes.

### Sync par instance (Radarr / Sonarr)

Le **Pull** sur la base **ne configure pas** Radarr/Sonarr. Menu **Arr** → instance → onglet **Sync** (≠ Pull de la base).

Bandeau *« Quality profiles require media management settings and a delay profile »* = section **non sauvegardée** → **Save** sur chaque bloc.

**Ordre obligatoire** :

```text
1. Media Management  →  Save
2. Delay profile     →  Save
3. Quality profiles  →  Save  →  Sync
```

#### Media Management — un preset par application

**Un seul triplet** par instance (pas un preset par profil `FR-Films-4K`) :

| Menu Profilarr | Radarr | Sonarr |
|----------------|--------|--------|
| Naming | **`FR-Media-Radarr`** | **`FR-Media-Sonarr`** |
| Quality definitions | **`FR-Media-Radarr`** | **`FR-Media-Sonarr`** |
| Media settings | **`FR-Media-Radarr`** | **`FR-Media-Sonarr`** |

Les **trois** menus doivent pointer vers le **même** nom.

#### Delay profile

| Instance | Choisir puis **Save** |
|----------|----------------------|
| Radarr | **`FR-Delay-Radarr`** (`ops/07`) |
| Sonarr | **`FR-Delay-Sonarr`** (`ops/09`) |

#### Profils qualité

Radarr : `FR-Films-1080p`, `FR-Films-4K`, `FR-Films-720p`, `FR-Films-Any`  
Sonarr : `FR-Series-*`, `FR-Anime-*` → **Save** → **Sync**.

Logs `arr.sync.* (skipped)` = config instance **pas encore enregistrée** — pas une erreur SQL du dépôt.

### Checklist Radarr / Sonarr

**Radarr**

- [ ] Base : **Pull** + **Compile**
- [ ] Sync → Media : `FR-Media-Radarr` sur les **3** menus → **Save**
- [ ] Delay : `FR-Delay-Radarr` → **Save**
- [ ] Quality profiles : au moins un `FR-Films-*` → **Save** → **Sync**

**Sonarr**

- [ ] Base : **Pull** + **Compile**
- [ ] Sync → Media : `FR-Media-Sonarr` × 3 → **Save**
- [ ] Delay : `FR-Delay-Sonarr` → **Save**
- [ ] Quality profiles : `FR-Series-*` / `FR-Anime-*` → **Save** → **Sync**

### Docker Compose (optionnel)

Exemple [installation Profilarr v2](https://v2.dictionarry.dev/profilarr-setup/installation) + parser pour tests CF. Variables : `DOCKERDIR`, `PROFILARR_PORT` (6868), `TZ`, `PUID`, `PGID`. Derrière reverse proxy : `ORIGIN`. Sans parser : retirer `profilarr-parser`, `depends_on`, `PARSER_HOST`, `PARSER_PORT`.

<details>
<summary>Exemple compose (cliquer pour déplier)</summary>

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

</details>

---

## Tous les choix expliqués

Chaque ligne = une décision **assumée** dans ce dépôt. Si tu ne partages pas l’objectif (encodes compacts FR, pas remux), ce dépôt n’est probablement pas pour toi.

| Choix | On ne fait pas | Pourquoi |
|-------|----------------|----------|
| **Scores CF dominants** | Tout miser sur la qualité native seule | La scène FR se lit dans le **titre** (MULTI, 4KLight, équipe) |
| **`rename = 0`** | Renommage Radarr agressif | Habitude trackers FR, cross-seed, lisibilité ratio |
| **Remux / Full Disc / AV1 / Upscaled → -999999** | Catalogue remux / AV1 | Encodes domestiques, compat TV/box |
| **`propers_repacks = doNotPrefer`** | Repack natif « Prefer » | Géré par **FR-Repack** / **-2** / **-3** dans le titre |
| **Torrent only, délai 0** | Usenet / délais longs | `FR-Delay-*` : torrent, `torrent_delay = 0` |
| **x265 favorisé en 1080p/720p** | Malus HEVC sous 4K (Dumpstarr) | Scène FR = encodes compacts HEVC |
| **VFQ / VOQ acceptés** | Ban VFQ | Passent par **FR-VF2** / **FR-MULTI-VF2** (scores, pas exclusion) |
| **16 équipes `FR-Team-*`** | ~900 regex « une par team » | Maintenance tenable, rebase Dictionarry possible |
| **Un preset media par app** | Bundle media par profil `FR-Films-4K` | Exigence Profilarr v2 + une config taille par instance |
| **Seuils profil type Dumpstarr** | `minimum = 20000` (ancienne base) | Évite upgrades bloqués ; priorité FR reste dans les CF |

### Seuils profil natifs (`ops/06`)

| Profil type | `minimum_custom_format_score` | `upgrade_until_score` |
|-------------|------------------------------:|----------------------:|
| Films 1080p | **750** | 10000 |
| Films / Series / Anime **4K** | **1000** | 10000 |
| Series / Anime 1080p/720p, Films 720p/Any | **0** | 10000 |

---

## Langue française

### Hiérarchie des scores (tous profils `FR-*`)

| Custom format | Score | Détection (résumé) |
|---------------|------:|---------------------|
| **FR-MULTI-VF2** | 100 000 | `MULTI` **et** (`VF2` \| `VFQ` \| `VOQ`) |
| **FR-MULTI-VFF** | 90 000 | `MULTI` **et** tag FR hors VF2/VFQ/VOQ |
| **FR-VF2** | 70 000 | VF2 / VFQ / VOQ sans MULTI obligatoire |
| **FR-VFF** | 60 000 | VFF, TRUEFRENCH, VFI, VOF, FRENCH, … |
| **FR-VOSTFR** | 20 000 | VOSTFR, SUBFRENCH, FANSUB, FASTSUB |

**Règle** : `FR-MULTI-VF2` et `FR-MULTI-VFF` sont **mutuellement exclusifs** (deux AND différents). `MULTI.VFF` ne doit pas matcher les deux — vérifié dans `ops/11`.

### Regex langue (`ops/02`)

| Regex | Rôle |
|-------|------|
| **FR-Regex-MULTI** | `MULTI`, `MULTI.VFF`, **`MULTIVFF`** (collé C411), `MULTITRUEFRENCH`, `MULTI.FRENCH`, `\bMULTI\b` seul (évite `MultiVerse`) |
| **FR-Regex-VFF** | VFF, TRUEFRENCH, VFI, VOF, **`MULTIVFF`**, `MULTI.VFF`, VF générique (hors VF2/VFQ) |
| **FR-Regex-VF2** | VF2, VFQ, VOQ, **`MULTIVF2`** (collé) |
| **FR-Regex-VOSTFR** | VOSTFR, SUBFRENCH, FANSUB, FASTSUB |

**Variantes cross-indexeurs** : `MULTI.TRUEFRENCH`, `MULTI.FRENCH`, `TRUEFRENCH` seul, etc. — cas **La Momie** (même rip, titres différents).

**Limite** : Radarr ne lit que **`release_title`**, pas le MediaInfo ni le hash → voir [Scoring](#scoring--limites-radarr).

---

## Équipes et paliers

### Architecture

| Niveau | CF | Rôle |
|--------|-----|------|
| **Équipes** | `FR-Team-*` (16 groupes) | Bonus fort, calibrés sur releases réelles |
| **Longue traîne** | `FR-Tier-01`, `FR-Tier-02` | Petits bonus (regex compacte) |

Détection : suffixe **`-TEAM`** dans le titre (`(?<=^|[\s.-])TEAM\b`, insensible à la casse → `SLAY3R` = `Slay3R`).

On **n’utilise pas** le modèle [Profilarr-database-french-regex](https://github.com/Jojont54/Profilarr-database-french-regex) (~900 fichiers / team) : coût de maintenance >> gain sur les cas observés.

### Scores équipes (identiques sur les 10 profils)

| Équipe | Score | Profil typique / calibrage |
|--------|------:|----------------------------|
| **FR-Team-QTZ** | 12 000 | 4KLight Bluray, référence 4K |
| **FR-Team-AMEN** | 9 500 | WEB 2160p compact DV/HDR10+ |
| **FR-Team-BONBON** | 9 200 | 4KLight / WEBRip ~2,5–5 Go |
| **FR-Team-TyHD** | 9 000 | WEB 2160p HEVC compact |
| **FR-Team-THESYNDiCATE** | 8 000 | WEB 2160p x265 |
| **FR-Team-SUPPLY** | 7 800 | WEB 2160p premium Atmos |
| **FR-Team-BOUC** | 7 700 | WEB 2160p premium MULTI |
| **FR-Team-TFA** | 7 500 | WEB 2160p catalogue |
| **FR-Team-FW** | 7 200 | Forward, volume |
| **FR-Team-Winks** | 6 600 | 1080p BluRay/WEB x265 MULTI (~4–5,5 Go) |
| **FR-Team-PopHD** | 6 500 | 1080p HDLight x264 |
| **FR-Team-TOXIC** | 6 400 | 1080p HDLight |
| **FR-Team-ENIGMA** | 6 200 | WEB 1080p/2160p, VFQ |
| **FR-Team-Slay3R** | 6 000 | WEB 1080p/2160p/720p, H264/H265, exclus |
| **FR-Team-HYPERION** / **OZEF** | 2 000 | Remux détectés mais **jamais retenus** |
| **FR-Tier-01** | 2 000 | BOUBA, NEOSTARK, … |
| **FR-Tier-02** | 1 000 | Longue traîne + DELIRIUS (`MULTI.FRENCH`) |

**Remux only** (HYPERION, OZEF) : reconnus pour logs, **Remux = -999999** → aucun impact sur la sélection.

---

## Signatures scène (4KLight, HDLight, Hybrid, Repack)

| CF | Détection | Scoring |
|----|-----------|---------|
| **FR-4KLight** | `4KLight`, `4K.Light` | Fort bonus **4K** (+2500 sur `FR-Films-4K`) |
| **FR-HDLight** | `HDLight` | Bonus 720p/1080p ; neutre/malus relatif en 4K |
| **FR-Hybrid** | `HYBRID` | Bonus UHD premium |
| **FR-Repack** / **-2** / **-3** | PROPER, REPACK, REAL… | Corrections dans le titre |

**QTZ** = équipe **et** souvent 4KLight en pratique — pas de CF `FR-Team-QTZ-4KLight` (un CF par **créneau**, pas par team×créneau).

---

## Technique : HDR, audio, codecs

### Audio — une seule famille comptée

Conditions **Exclure :** entre AAC, Dolby, DTS, TrueHD, FLAC, etc. → pas de cumul absurde (+DD **et** +DTS sur la même ligne).

| Regex / CF | Détecte (exemples scène FR) |
|------------|----------------------------|
| **Dolby Digital** | `DD`, `AC3`, **`AC3.5.1`**, **`AC-3`**, **`AC-3.5.1`** (Torr9) — **pas** `E-AC-3` |
| **Dolby Digital +** | `DD+`, `EAC3`, **`EAC3.5.1`**, **`E-AC-3`**, **`E-AC-3.5.1`** |
| **FR-Regex-Atmos-Bundle** | `ATMOS`, `DDPA`, `TrueHD.A`, **`Atmos.5.1`** (WEB) |

### HDR en 4K

| CF | Score | Note |
|----|------:|------|
| Dolby Vision | 4500 | |
| DV (Without Fallback) | -500 | DV sans HDR lisible dans le titre |
| **HDR10+** | **2000** | |
| HDR10 | 1000 | |
| **HDR** (générique) | **1000** | Quand un indexeur omet `HDR10+` |
| Dolby Digital + | 400 | |
| Dolby Digital | 100 | AC3 parfois absent du titre |

**La Momie** : `…HDR10PLUS…` vs `…HDR…TRUEFRENCH…` → écart de score réduit tout en gardant la meilleure release devant.

### Codecs

| CF | Comportement |
|----|----------------|
| **AV1** | -999999 |
| **x264 (2160p)** | -999999 en 4K |
| **x265** / **h265** | Bonus 4K ; regex inclut **`H265`** / **`H264`** / **`AVC`** (naming C411) |
| **VP9** | Malus léger |
| **Xvid** | Malus fort HD |
| **FR-Blockers** | -999999 — YIFY, NVENC, REMUX+x264 incohérent, … |

### Streamers

| CF | Contenu |
|----|---------|
| **FR-Streamer-Premium** | NF, AMZN, DSNP, ATVP, HBO Max, Paramount+ |
| **FR-Streamer-Standard** | NOW, Crunchyroll, iTunes WEB — pas Hulu/Peacock (peu FR) |

---

## Profils qualité `FR-*`

| Profil | App | Usage |
|--------|-----|--------|
| **FR-Films-1080p** | Radarr | Films 1080p — point de départ |
| **FR-Films-4K** | Radarr | 4K — DV/HDR, 4KLight, équipes WEB |
| **FR-Films-720p** | Radarr | Compacts |
| **FR-Films-Any** | Radarr | Secours toutes résolutions, **sans remux** |
| **FR-Series-1080p** | Sonarr | Séries 1080p + Season Pack |
| **FR-Series-4K** | Sonarr | Séries 4K |
| **FR-Series-720p** | Sonarr | Séries compactes |
| **FR-Anime-1080p/4K/720p** | Sonarr | Animé (type Anime) |

Chaque profil **exclut** : Remux, Full Disc, AV1, Upscaled (+ x264@2160p sur 4K).

Tags UI (`ops/06` + `ops/10`) : Radarr, Sonarr, Films, Series, 1080p/2160p/720p, French, **anime** (filtre Sonarr — tag SQL minuscule volontaire).

---

## Media management : tailles et delays

### Principe

Les champs `min_size` / `preferred_size` / `max_size` dans **`ops/07`** (Radarr) et **`ops/09`** (delay Sonarr) guident Radarr/Sonarr vers des **tailles cohérentes avec la scène FR** (encodes compacts), en complément des scores CF.

**Deux presets** (Profilarr v2) :

- **`FR-Media-Radarr`** — Naming + Quality definitions + Media settings (3 menus identiques)
- **`FR-Media-Sonarr`** — idem Sonarr

Ancien modèle abandonné : un bundle media **par** profil `FR-Films-4K`.

### Tableau des tailles (valeurs actuelles)

Unité telle que définie dans Radarr/Sonarr pour les quality definitions (affichée **MB/h** dans l’UI). Les fourchettes ci-dessous sont des **ordres de grandeur** pour un long métrage ~2 h ; les épisodes Sonarr sont plus courts.

#### Radarr — `FR-Media-Radarr`

**Limite API Radarr** : `max_size` (et en pratique `min` / `preferred` / `max`) **≤ 2000** par qualité — au-delà, sync Profilarr → Radarr échoue (`Max Size must be less than or equal to '2000'`).

| Qualité | min | preferred | max | Calibré sur |
|---------|-----|-----------|-----|-------------|
| **Bluray-1080p** | 900 | 1750 | **2000** | BluRay x265 compact (**Winks** ~4–5,5 Go) |
| **WEBDL/WEBRip-1080p** | 600 | 1650 | **2000** | WEB **Slay3R** ~4–5 Go (cible) ; gros WEB ~9 Go non pénalisables via `max` au-delà de 2000 |
| **Bluray-2160p** | 0 | 55 | 2000 | 4KLight, TyHD, AMEN (~2,5–8 Go) |
| **WEBDL/WEBRip-2160p** | 40 | 70 | 2000 | WEB 4K compact ~7–8 Go, blockbusters ~15–23 Go (**Slay3R**) |
| **Bluray-720p** | 800 | 1000 | 900 | *(inchangé)* |

#### Sonarr — `FR-Media-Sonarr`

| Qualité | min | preferred | max | Calibré sur |
|---------|-----|-----------|-----|-------------|
| **Bluray-1080p** | 500 | 750 | 1200 | Épisodes / features courts |
| **WEBDL/WEBRip-1080p** | 150 | 400 | 650 | Épisodes **Slay3R** ~2,4–3 Go |
| **Bluray-2160p** | 0 | 55 | 1000 | Aligné Radarr 4K compact |
| **WEBDL/WEBRip-2160p** | 0 | 60 | 1000 | WEB 4K série |

### Delays

| Preset | Fichier | Comportement |
|--------|---------|--------------|
| **FR-Delay-Radarr** | `ops/07` | Torrent only, délai 0, bypass si déjà meilleure qualité |
| **FR-Delay-Sonarr** | `ops/09` | Idem Sonarr |

---

## Calibrage sur releases réelles (workflow principal)

**Releases réelles** = listes ou captures de ton **indexeur privé** (noms de fichiers + tailles en Go), comme pour **Winks** ou **Slay3R**. On ajuste la base pour coller à ce que tu vois vraiment, pas seulement à la théorie TRaSH/Dictionarry.

### Ce que tu envoies (modèle)

Pour une **équipe** ou un **tracker**, envoie par message :

1. **Captures** ou liste de **5–30 titres** complets (ex. `Film.2024.MULTI.VFF.1080p.WEB.AC3.5.1.H264-Slay3R`).
2. Les **tailles** affichées (Go) — min / typique / max si possible.
3. **Résolution** dominante (1080p WEB, 2160p, BluRay, …).
4. Optionnel : indexeur (C411, Torr9) — reste interne, pas obligatoire dans le README public.

### Ce qu’on fait dans le dépôt

| Étape | Fichiers |
|-------|----------|
| Grammaire des titres | `ops/02`, `ops/04` |
| Nouvelle équipe | `ops/03`, `ops/04`, `ops/06` |
| Tailles media (Radarr **max ≤ 2000**) | `ops/07` |
| Tests sur vrais titres | `ops/11` (description avec **C411**, **Torr9**, **Calibrage**, ou nom d’équipe) |
| Doc | ce README + [journal](#journal-des-calibrages-récents) |

Puis : `python3 scripts/validate.py` → commit → **Pull → Compile → Sync** sur Radarr/Sonarr.

### Journal des calibrages récents

| Date | Élément | Changement principal |
|------|---------|----------------------|
| 2026-05 | **Winks** (C411) | `FR-Team-Winks` 6600 ; Bluray-1080p 900/1750/2000 |
| 2026-05 | **Audio** C411/Torr9 | `AC3.5.1`, `E-AC-3`, `MULTIVFF` ; exclusion E-AC-3 du CF DD classique |
| 2026-05 | **Slay3R** (C411) | Score 6000 ; WEB 1080p 600/1650/2000 ; regex **H264/H265/AVC** |
| 2026-05 | **Fix Radarr** | `max_size` plafonné à **2000** (limite API) — corrige l’erreur sync Media Management |

*(Ajouter une ligne ici à chaque calibrage releases réelles.)*

---

## Pages Profilarr (instance Radarr)

| Page | Rôle |
|------|------|
| **Sync** | Pousse presets media, delay, profils qualité vers Radarr |
| **Drift** | Alerte si quelqu’un modifie Radarr à la main (optionnel) |
| **Upgrades** | Re-cherche de meilleures releases en bibliothèque — utile **après** un gros Sync de scores |
| **Delay profile** | `FR-Delay-Radarr` : torrent, délai 0 (voir README section delays) |

**Score `150 470 / 10 000`** dans la bibliothèque : le **10 000** est `upgrade_until_score` du profil, **pas** un plafond de note. La langue seule peut dépasser 100 000 — c’est voulu.

---

## Scoring : limites Radarr

| Situation | Comportement |
|-----------|--------------|
| Même titre, deux trackers | Même score CF |
| Même fichier, **titres différents** | Scores différents (normal) |
| Tailles différentes | Qualité native + preset media divergent |
| `.mkv` dans le nom | Parsing parfois altéré |

**Ce n’est pas un bug Profilarr** : tout part du **titre indexeur**.

### Tests de référence (`ops/12`)

- **La Momie** (TMDB 564) — QTZ 4KLight vs Slay3R WEB vs TyHD vs Remux vs AV1
- Variante TRUEFRENCH / HDR (cross-indexeur)
- **Person of Interest** — `MULTI.FRENCH` (DELIRIUS)
- **Incendies** — VOQ sans MULTI vs MULTI.VOQ
- **Demon Slayer** — WEB CR MULTI VFF

---

## Créneaux catalogue (slots)

Sur une partie de la scène FR (indexeurs à **slots** UHD) :

| Créneau | Indications | Profil aligné |
|---------|-------------|---------------|
| **COMPAT** | x264 1080p | `FR-Films-1080p` |
| **HC OPTI** | HEVC 2160p ~2,5–8 Go, DV/HDR10+ | **`FR-Films-4K`** (TyHD, AMEN, BONBON) |
| **OPTI** | Gros WEB-DL ~15 Go | Accepté ; `preferred_size` 4K favorise plutôt le compact |

Trackers **sans slots** : même logique via tags (`MULTI.VFF`, `4KLight`, …).

---

## Ce qu’on rejette volontairement

| Piste | Verdict |
|-------|---------|
| ~900 regex / team (Jojont54) | Non — maintenance ×10 |
| Ban VFQ | Non — VF2 / MULTI-VF2 |
| `release_group` séparé | Pas urgent — groupe dans le titre FR |
| Bundles media par profil qualité | Remplacé par `FR-Media-Radarr/Sonarr` |
| Repack natif « Prefer » | `doNotPrefer` + **FR-Repack*** |
| Noms de trackers dans la doc | « Scène française privée » + calibrages anonymisables |

**Roadmap** (non implémentée) : CF signatures par créneau en **ajout** aux tiers ; pas de suppression des tiers d’un coup.

---

## Tests et validation

```bash
python3 scripts/validate.py
```

Vérifie : intégrité `ops/`, compile SQLite (schema 1.1.0), descriptions regex sans `*`, **tests calibrage** (`ops/11` titres C411/Torr9/équipes).

CI GitHub : workflow **Validate PCD** sur chaque push/PR vers `main`.

| Fichier | Rôle |
|---------|------|
| **`ops/11`** | ~443 tests parser par CF (titres réels / C411 / Torr9) |
| **`ops/12`** | Simulations profil (Momie, POI, …) |

Après modification SQL : **Pull → Compile** sur la base, puis revérifier les tests dans l’UI Profilarr.

---

## Structure du dépôt

```text
pcd.json                 # Métadonnées PCD 2.0.0
ops/
  01-tags.sql            # Tags UI
  02-regex.sql           # 70 motifs (pattern = détection)
  03-custom-formats.sql  # 66 CF (include_in_rename = 0)
  04-custom-format-conditions.sql
  05-custom-format-tags.sql
  06-quality-profiles.sql   # 10 profils FR-* + scores
  07-media-management.sql   # FR-Media-Radarr, FR-Delay-Radarr
  09-profile-media-bundles.sql  # FR-Delay-Sonarr
  10-profile-ui-tags.sql
  11-custom-format-tests.sql
  12-quality-profile-tests.sql
scripts/
  validate.py            # Pipeline CI locale
  normalize_descriptions.py
  verify_ops_integrity.py
  verify_pcd_compile.py
```

**Préfixe `FR-`** : spécifique marché français. Le reste reprend Dictionarry (`HDR10+`, `Remux`, …) pour rester **rebaseable**.

---

## Maintien du README (obligatoire)

**Règle du dépôt** : toute modification fonctionnelle dans `ops/` ou `scripts/` qui change un comportement visible doit **mettre à jour ce README** dans le **même commit** (ou immédiatement après).

### Checklist mainteneur

- [ ] Tableau ou section concernée (langue, équipe, tailles, audio, …) à jour
- [ ] Ligne ajoutée dans [Journal des calibrages](#journal-des-calibrages-récents) si calibrage releases réelles
- [ ] Compteurs (CF, regex, tests) cohérents si le volume a changé
- [ ] `python3 scripts/validate.py` OK
- [ ] Mention **Pull → Compile → Sync** si changement déployable

### Ce qu’il faut documenter

| Type de changement | Où dans le README |
|--------------------|------------------|
| Nouvelle équipe `FR-Team-*` | [Équipes](#équipes-et-paliers) + journal |
| Regex langue / audio | [Langue](#langue-française) ou [Technique](#technique--hdr-audio-codecs) |
| `ops/07` tailles | [Media management](#media-management--tailles-et-delays) + journal |
| Score profil / CF | Tableaux scores + journal si motivation terrain |
| Nouveau profil `FR-*` | [Profils](#profils-qualité-fr-) |

Les **agents / contributeurs** qui modifient ce dépôt doivent appliquer cette checklist sans rappel supplémentaire.

---

## Historique du dépôt

| Phase | Forme | Notes |
|-------|--------|--------|
| v1 | YAML | Profilarr v1 |
| v2.5 → v3 | PCD + `ops/*.sql` | Schema 1.1.0 |
| **2.0.0 actuel** | Racine = `pcd.json` + `ops/` + `scripts/` | Alignement Dumpstarr (seuils profil) |

Anciennes archives `backup/` : `git show <commit>:backup/...` (ex. `c1d52ee`).

**À importer dans Profilarr** : uniquement la **racine** du repo.

---

## Références

- [Profilarr v2 — Installation](https://v2.dictionarry.dev/profilarr-setup/installation)
- [Dictionarry-Hub/schema 1.1.0](https://github.com/Dictionarry-Hub/schema)
- [Dictionarry-Hub/database](https://github.com/Dictionarry-Hub/database)
- [Dumpstarr/Database](https://github.com/Dumpstarr/Database)
- [Issues](https://github.com/mcflykid/french-profilarr-database/issues)

---

*Base maintenue par [mcflykid](https://github.com/mcflykid) — communauté FR (TRaSH FR, bases contributives), sans fork officiel Dictionarry.*

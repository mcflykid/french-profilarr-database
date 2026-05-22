# French Profilarr Database

![CI](https://github.com/mcflykid/french-profilarr-database/actions/workflows/ci.yml/badge.svg)
![Profilarr](https://img.shields.io/badge/Profilarr-%E2%89%A52.0.0-blue)
![PCD](https://img.shields.io/badge/PCD-2.5.0-green)

Base **[Profilarr](https://github.com/Dictionarry-Hub/Profilarr) v2** au format **[PCD](https://github.com/Dictionarry-Hub/schema)** pour **Radarr** et **Sonarr**, pensée pour la **scène française** : langues (MULTI, VFF, VF2, VOSTFR), équipes d’encodeurs, tags scène (`4KLight`, `HDLight`) et critères techniques (HDR, audio, codec).

Radarr et Sonarr ne classent une release qu’à partir du **nom** renvoyé par l’indexeur. Ce dépôt encode cette logique en custom formats, scores et réglages media — tout le spécifique FR est préfixé **`FR-`**.

| | |
|---|---|
| **Format** | PCD — `pcd.json` + `ops/*.sql` |
| **Profilarr** | ≥ 2.0.0 |
| **Schema** | [Dictionarry-Hub/schema](https://github.com/Dictionarry-Hub/schema) **1.1.0** |
| **Contenu** | 66 custom formats · 70 regex · 10 profils · **sans Remux** |
| **Licence** | MIT |

> **Profilarr v2 uniquement** — source de vérité : `ops/*.sql` + `pcd.json` (plus de YAML dans le dépôt). Workflow : **Compile** → **Sync**.

---

## Démarrage rapide

### 1. Lier la base dans Profilarr v2

1. Installer [Profilarr v2](https://v2.dictionarry.dev/profilarr-setup/installation) (ex. [`docs/compose-profilarr-v2.yml`](docs/compose-profilarr-v2.yml)).
2. Lier le dépôt : `https://github.com/mcflykid/french-profilarr-database` (PAT GitHub si privé).
3. **Pull** → **Compile** → **Sync** vers chaque instance Radarr / Sonarr.

Le schéma `1.1.0` est tiré automatiquement de la dépendance déclarée dans `pcd.json`.

### 2. Configurer media + delay (obligatoire en v2)

Profilarr affiche souvent : *« Quality profiles require media management settings and a delay profile »*. Ce n’est pas un bug : la v2 exige ces blocs **en plus** des profils qualité.

| Instance | Delay (réglage global) | Profils qualité + Media Management |
|----------|------------------------|-------------------------------------|
| **Radarr** | `FR-Delay-Radarr` | `FR-Films-4K`, `FR-Films-1080p`, `FR-Films-720p`, `FR-Films-Any` |
| **Sonarr** | `FR-Delay-Sonarr` | `FR-Series-*`, `FR-Anime-*` |

**Règle :** pour chaque bibliothèque, le **nom du profil qualité** = le **nom du preset Media Management** (ex. `FR-Films-4K` partout). Ne pas assigner `FR-Media-Base` (modèle technique interne).

Guide détaillé : [`docs/PROFILARR-V2.md`](docs/PROFILARR-V2.md).

### 3. Assigner les profils

| Usage | Profil recommandé |
|-------|-------------------|
| Films 4K | `FR-Films-4K` |
| Films 1080p | `FR-Films-1080p` |
| Films 720p | `FR-Films-720p` |
| Films (secours) | `FR-Films-Any` |
| Séries 4K / 1080p / 720p | `FR-Series-4K`, `FR-Series-1080p`, `FR-Series-720p` |
| Animé (Sonarr, type **Anime**) | `FR-Anime-4K`, `FR-Anime-1080p`, `FR-Anime-720p` |

### 4. Mettre à jour la base

```text
Modifier ops/ → commit → push → Profilarr Pull → Compile → Sync
```

---

## Convention de noms (se repérer dans l’UI)

Tout commence par **`FR-`** pour regrouper les entrées dans Profilarr :

```text
FR-Delay-Radarr     délai torrent (instance Radarr)
FR-Delay-Sonarr     délai torrent (instance Sonarr)

FR-Media-Base       modèle interne — ne pas assigner

FR-Films-4K         profil Radarr = bundle media (même nom)
FR-Films-1080p
FR-Films-720p
FR-Films-Any

FR-Series-4K        profil Sonarr (séries)
FR-Series-1080p
FR-Series-720p

FR-Anime-4K         profil Sonarr (animé)
FR-Anime-1080p
FR-Anime-720p
```

Tags sur les profils (`ops/10`) : `Radarr`, `Sonarr`, `Films`, `Series`, `anime`, plus `French`, `2160p`, etc.

---

## Structure du dépôt

```text
pcd.json                          manifest PCD
ops/
  01-tags.sql                     tags (filtres UI, CF)
  02-regex.sql                    expressions régulières
  03-custom-formats.sql           définitions des CF
  04-custom-format-conditions.sql liaison CF ↔ regex / source / résolution
  05-custom-format-tags.sql       tags par custom format
  06-quality-profiles.sql         profils qualité + scores
  07-media-management.sql         FR-Media-Base, tailles, nommage (rename=0), FR-Delay-Radarr
  09-profile-media-bundles.sql    un bundle media par profil FR-*
  10-profile-ui-tags.sql          tags Radarr / Films / Series sur les profils
  11-custom-format-tests.sql      ~450 tests CF (parser)
  12-quality-profile-tests.sql    simulations profil (Momie, POI, animé, Incendies)
tweaks/                           ajustements locaux (voir README)
scripts/
  check.sh                        toutes les vérifications PCD v2
  verify_pcd_v2.py                structure + métadonnées FR
  verify_team_tests.py            chaque FR-Team-* a un test positif
  verify_expected_scores.py       politique Remux / AV1 / blocages
  verify_profile_scores.py        compare scores entre profils
  normalize_fr_metadata.py        uniformise descriptions / annotations FR
  validate_regex_ops.py           regex compilables
  generate_cf_tests_sql.py          fusionne ops/11 + scène FR
  generate_profile_media_ops.py   regénère ops/09
docs/
  DECISIONS-METADONNEES-FR.md     conventions libellés UI + décisions « pourquoi »
  PROFILARR-V2.md                 installation, dépannage, workflow UI
  streamers-audit.md              comparaison trash-pcd
  BASES-PARALLELES.md             ce dépôt vs Dictionarry / trash-pcd
  exemples-releases.md            titres de référence
  compose-profilarr-v2.yml        exemple Docker
```

**Chaîne logique :** regex (`02`) → custom format (`03`–`05`) → score dans le profil (`06`).

---

## Comment une release est classée

| Couche | Exemples | Effet |
|--------|----------|--------|
| **Langue** | `FR-MULTI-VF2`, `FR-MULTI-VFF`, `FR-VFF`, `FR-VOSTFR` | Priorité dominante (~20k–100k) |
| **Teams** | `FR-Team-QTZ`, `FR-Team-AMEN`, … | Bonus encodeur (5,5k–12k) |
| **Tags scène** | `FR-4KLight`, `FR-HDLight`, `FR-Hybrid` | Formats compacts FR |
| **Technique** | HDR, TrueHD, Atmos, `x265`, … | Qualité annoncée dans le titre |
| **Tiers** | `FR-Tier-01`, `FR-Tier-02` | Longue traîne (2k / 1k) |
| **Tailles** | `ops/07` / `09` | Favorise 4K compacts (~55–60 Mo/min) |
| **Exclusions** | `AV1`, `Remux`, `Full Disc`, `FR-Blockers` | **-999999** sur profils stricts |

**Limite connue :** deux indexeurs peuvent proposer le **même fichier** avec des **titres différents** (`MULTI.VFF` vs `MULTI.TRUEFRENCH`, `HDR10+` vs `HDR`). Le score change ; ce n’est pas un bug Profilarr. Les scores HDR 4K ont été resserrés pour limiter l’écart.

Radarr ne lit **pas** : taille réelle, seeders, slot catalogue, hash.

---

## Philosophie

- **Scène FR d’abord** — teams, `4KLight` / `HDLight`, cross-seed ; pas un copier-coller TRaSH international.
- **Regex + CF + score séparés** — testable et ajustable par profil dans Profilarr v2.
- **Teams documentées hors tiers** — pas de double bonus team + tier sur la même release.
- **AV1 proscrit** en 4K strict — compat matériel domestique ; HEVC/x265 visé.
- **VFQ / VF2 non bannis** — cohérent avec le catalogue francophone.
- **Remux reconnus mais exclus** sur profils stricts (`OZEF`, `HYPERION` → score symbolique, `Remux` à -999999).

Base [Dictionarry v2](https://github.com/Dictionarry-Hub/database/tree/v2) ou [trash-pcd](https://github.com/Dictionarry-Hub/trash-pcd) en **option** (2ᵉ base liée) ; ce dépôt reste **autonome** pour tout `FR-*`.

---

## Profils qualité

| Profil | App | Cible |
|--------|-----|--------|
| `FR-Films-4K` | Radarr | Films 2160p HEVC, HDR, audio premium |
| `FR-Films-1080p` | Radarr | Films 1080p équilibrés |
| `FR-Films-720p` | Radarr | Films légers |
| `FR-Films-Any` | Radarr | Secours multi-qualité |
| `FR-Series-4K` | Sonarr | Séries 2160p |
| `FR-Series-1080p` | Sonarr | Séries 1080p (+ HDTV) |
| `FR-Series-720p` | Sonarr | Séries 720p |
| `FR-Anime-4K` | Sonarr | Animé 2160p (type Anime) |
| `FR-Anime-1080p` | Sonarr | Animé 1080p |
| `FR-Anime-720p` | Sonarr | Animé 720p |

**Langue (ordre) :** `FR-MULTI-VF2` > `FR-MULTI-VFF` > `FR-VF2` > `FR-VFF` > `FR-VOSTFR`.

Profils 4K stricts : **AV1**, **Remux**, **Full Disc**, **x264@2160p** fortement pénalisés ou exclus.

---

## Équipes documentées

Scores **identiques** sur films, séries et anime. Ordre typique à techno égale :

**QTZ → AMEN → BONBON → TyHD → THESYNDiCATE → SUPPLY → BOUC → TFA → FW → ENIGMA → TOXIC → PopHD → Slay3R** → OZEF / HYPERION* → **FR-Tier-01 → FR-Tier-02**

\* Remux : reconnus mais non retenus sur profils stricts.

| Team | Score | Créneau |
|------|------:|---------|
| QTZ | 12 000 | Bluray 4KLight, DV/HDR |
| AMEN | 9 500 | WEB 2160p compact |
| BONBON | 9 200 | WEB/WEBRip 4KLight |
| TyHD | 9 000 | WEB HC optimisé |
| THESYNDiCATE | 8 000 | WEB 2160p HEVC |
| SUPPLY | 7 800 | WEB 2160p premium |
| BOUC | 7 700 | WEB 2160p catalogue |
| TFA | 7 500 | WEB 2160p volume |
| FW | 7 200 | WEB 2160p Forward |
| ENIGMA | 6 200 | WEB 1080p/2160p, VFQ |
| TOXIC | 6 400 | 1080p HDLight x264 |
| PopHD | 6 500 | 1080p HDLight |
| Slay3R | 5 500 | WEB 2160p volume / filet |
| OZEF / HYPERION | 2 000 | Remux (bloqués en strict) |
| Tier-01 / Tier-02 | 2 000 / 1 000 | BOUBA, NEOSTARK, TLC, … |

Exemples de titres : [`docs/exemples-releases.md`](docs/exemples-releases.md).

### MULTI.FRENCH et tags langue

Une release `MULTI.FRENCH` peut matcher **`FR-MULTI-VFF`** (MULTI + tag FR) et parfois aussi **`FR-VFF`** selon le titre — c’est le comportement du parser sur l’indexeur, pas un doublon à supprimer. Priorité assurée par les scores (MULTI-VFF > VFF).

### Politique Remux

**Tous les profils `FR-*`**, y compris `FR-Films-Any`, appliquent **Remux** et **Full Disc** à **-999999**. Seuls les encodes (WEB, 4KLight, x265…) sont visés. Voir [`docs/DECISIONS-METADONNEES-FR.md`](docs/DECISIONS-METADONNEES-FR.md).

---

## Développer et valider

### Modifier les scores

`ops/06-quality-profiles.sql` — table `quality_profile_custom_formats` :

```sql
INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT 'FR-Films-4K', 'FR-Team-QTZ', 'all', 12000
FROM quality_profiles qp WHERE qp.name = 'FR-Films-4K';
```

Pour des retouches ponctuelles, préférer des `UPDATE` idempotents (voir [Change-Driven Development](https://github.com/Dictionarry-Hub/schema)).

### Modifier regex / conditions

- `ops/02-regex.sql` — motifs
- `ops/04-custom-format-conditions.sql` — conditions par CF

### Scripts

```bash
./scripts/check.sh                       # recommandé avant commit
python3 scripts/verify_pcd_v2.py           # structure v2 + libellés FR
python3 scripts/normalize_fr_metadata.py # ré-appliquer descriptions / annotations FR
python3 scripts/validate_regex_ops.py    # regex valides
python3 scripts/verify_team_tests.py       # couverture FR-Team-*
python3 scripts/generate_cf_tests_sql.py   # fusion ops/11 + extras scène
python3 scripts/generate_profile_media_ops.py  # regénère ops/09
```

Conventions des textes affichés dans Profilarr (descriptions, annotations de conditions, tests) : [`docs/DECISIONS-METADONNEES-FR.md`](docs/DECISIONS-METADONNEES-FR.md).

### Tests dans Profilarr

- `ops/11-custom-format-tests.sql` — tests **custom formats** (titres réels).
- `ops/12-quality-profile-tests.sql` — simulations **profil qualité** (Momie 4K, POI, Demon Slayer, Incendies VOQ).

Nécessite le service **parser** dans Profilarr. **Renommage désactivé** (`rename = 0` dans les presets media).

Tu peux aussi ajuster via les **customisations** locales Profilarr (couche séparée du dépôt upstream).

---

## Dépannage rapide

| Problème | Piste |
|----------|--------|
| Message media / delay manquant | Choisir `FR-Delay-Radarr` ou `FR-Delay-Sonarr` + bundle media = nom du profil |
| Sonarr `PUT customformat` Fatal | Regex invalide dans `02` → `validate_regex_ops.py` puis re-sync |
| Écart de score entre indexeurs | Tags différents dans le **titre** — normal |
| Compile échoue | Vérifier dépendance schema `1.1.0` dans `pcd.json` |

Plus de détails : [`docs/PROFILARR-V2.md`](docs/PROFILARR-V2.md).

---

## Contribution

Ouvre une [issue](https://github.com/mcflykid/french-profilarr-database/issues) avec :

- noms de releases **copiés-collés** ;
- profil visé (`FR-Films-4K`, etc.) ;
- si possible : même titre sur deux indexeurs ou deux teams (corrélation taille / score).

Nouvelle team : 3–10 noms de release complets + créneau visé (4KLight, WEB compact, …).

---

## FAQ

| Question | Réponse |
|----------|---------|
| Par où commencer ? | Lier le repo → Compile → Sync → `FR-Films-4K` + `FR-Series-4K` + delays |
| Dictionarry obligatoire ? | **Non** pour le FR ; optionnel en 2ᵉ base |
| trash-pcd / TRaSH ? | [trash-pcd](https://github.com/Dictionarry-Hub/trash-pcd) en parallèle possible ; logique différente (ne pas fusionner) |
| Remux ? | **Refusé** sur tous les profils (`-999999`) |
| Renommage Radarr/Sonarr ? | **Désactivé** (`rename = 0`) |

---

## Liens

- [Profilarr v2](https://v2.dictionarry.dev/devlogs/profilarr-v2)
- [Schema PCD](https://github.com/Dictionarry-Hub/schema)
- [Installation Profilarr v2](https://v2.dictionarry.dev/profilarr-setup/installation)
- [Issues](https://github.com/mcflykid/french-profilarr-database/issues)

# french-profilarr-database

Configuration **Profilarr v1** (Radarr / Sonarr) orientée **scène FR stricte**
pour les trackers privés francophones (**C411**, **La Cale**, **Gemini**, **YGGtorrent**).

Ce dépôt est un **fork allégé et adapté** de
[Dictionarry-Hub/database](https://github.com/Dictionarry-Hub/database) :
- la base technique (audio, codec, HDR, sources, streamers) vient de l'officiel ;
- la couche métier FR (langue, teams, blockers, repack consolidé) est **propre au projet**
  et préfixée `FR-` pour bien la distinguer.

Objectif : automatiser la sélection de releases en priorisant dans l'ordre
1. la **langue FR** (MULTI VF2 > MULTI VFF > VF2 > VFF > VOSTFR),
2. la **qualité technique utile** (HDR, audio premium, codec efficient),
3. la **fiabilité des groupes** (teams FR Tier 1 à 4),
4. le **respect des contraintes** (compatibilité matériel, charte tracker, seeding).

---

## Convention de nommage : `FR-` = à nous

| Préfixe | Origine | Exemples |
|---|---|---|
| **`FR-*`** | **Propre au projet** — logique métier scène FR | `FR-Regex-VFF`, `FR-Blockers`, `FR-Tier-01`, `FR-Repack-3` |
| *autre* | Importé / aligné Dictionarry officiel | `Atmos`, `Dolby Vision`, `x265`, `AAC`, `IMAX` |

**Nom de fichier :** chaque `regex_patterns/*.yml` et `custom_formats/*.yml` a un
stem **identique** au champ YAML `name:` (espaces, `+` et parenthèses inclus) — même
convention que le dépôt Dictionarry.

Si tu modifies un fichier officiel pour l'adapter au marché FR, **renomme-le `FR-...`**
(fichier **et** `name:`) et mets à jour les références dans les profils / conditions.

---

## Compatibilité Profilarr v1

- Schéma `regex_patterns/*` : `name`, `pattern`, `description`, `tags`, `tests`
- Schéma `custom_formats/*` : `name`, `description`, `tags`, `conditions`, `tests`
- Schéma test (les 2 dossiers) : `id`, `input`, `expected` (`tests: []` autorisé)
- Profils : `name`, `description`, `tags`, `upgradesAllowed`, `minCustomFormatScore`,
  `upgradeUntilScore`, `minScoreIncrement`, `custom_formats`, `qualities`,
  `upgrade_until`, `language`

Mélanger les schémas v1 et v2 dans `tests:` peut afficher `Unexpected Error` dans l'UI.

---

## Ce qui est strict vs éditorial

### Strict (à ne pas casser)
- Schéma des tests `regex_patterns/` et `custom_formats/` : `id`, `input`, `expected`.
- Références valides :
  - `custom_formats.conditions[].pattern` -> `regex_patterns.name`
  - `profiles.custom_formats[].name` -> `custom_formats.name`
- YAML valide dans tous les dossiers importés.
- Hiérarchie langue **strictement décroissante** :
  `FR-MULTI-VF2 > FR-MULTI-VFF > FR-VF2 > FR-VFF > FR-VOSTFR`.

### Éditorial (modifiable selon ta politique)
- Listes teams `FR-Tier-01` … `FR-Tier-04` et blocklist `FR-Blockers`.
- Pondération fine des bonus/malus (hors hiérarchie langue).
- Choix de compatibilité matériel (ex : malus AV1, exclusion Remux/Full Disc).
- Liste des streamers à scorer (NF, AMZN, DSNP, ATVP, etc.).
- Pas de custom formats « Missing » (malus pour étiquettes absentes) : le tri repose
  sur des bonus lorsque le titre contient explicitement les motifs (HDR, audio, etc.).

---

## Structure du dépôt

### `regex_patterns/` (58 fichiers)
Motifs regex nommés. Détectent : langue, codecs, HDR, audio, source, edition,
teams (FR + patterns internationaux pour traçabilité), repacks, blockers.

Fichiers **propres au projet** (préfixe `FR-`) :
- `FR-Regex-VFF`, `FR-Regex-VF2`, `FR-Regex-MULTI`, `FR-Regex-VOSTFR`
- `FR-Regex-Blockers`, `FR-Regex-HDLight`, `FR-Regex-4KLight`, `FR-Regex-Hybrid`
- `FR-Regex-Streamers-Premium`, `FR-Regex-Streamers-Standard`, `FR-Regex-Atmos-Bundle`
- `FR-Tier-01`, `FR-Tier-02`, `FR-Tier-03`, `FR-Tier-04`, `FR-Repack`, `FR-Repack-2`, `FR-Repack-3`

### `custom_formats/` (55 fichiers)
Règles consommées par Radarr/Sonarr. Chaque custom format référence une regex
via `conditions[].pattern`.

Custom formats **propres au projet** :
- Langue : `FR-VFF`, `FR-VF2`, `FR-VOSTFR`, `FR-MULTI-VFF`, `FR-MULTI-VF2`
- Scène : `FR-Blockers`, `FR-Tier-01` … `FR-Tier-04`, `FR-Repack`, `FR-Repack-2`, `FR-Repack-3`,
  `FR-HDLight`, `FR-4KLight`, `FR-Hybrid`, `FR-Streamer-Premium`, `FR-Streamer-Standard`

### `profiles/` (7 fichiers)
Profils FR films/séries — **tous préfixés `FR-`** :
- `FR-Films-720p`, `FR-Films-1080p`, `FR-Films-4K`, `FR-Films-Any`
- `FR-Series-720p`, `FR-Series-1080p`, `FR-Series-4K`

### `media_management/`
- `quality_definitions.yml` : bornes min/max/preferred (Radarr max ≤ 2000, Sonarr max ≤ 1000)
- `naming.yml` : templates de nommage
- `misc.yml` : options techniques annexes

---

## Philosophie de scoring

### Hiérarchie langue (priorité absolue)
| Custom Format | Score |
|---|---|
| `FR-MULTI-VF2` | 100000 |
| `FR-MULTI-VFF` | 90000 |
| `FR-VF2` | 70000 |
| `FR-VFF` | 60000 |
| `FR-VOSTFR` | 20000 (= `minCustomFormatScore`) |

Les écarts sont **volontairement grands** pour qu'aucun bonus secondaire
(team, HDR, audio, repack) ne fasse basculer la priorité linguistique.

### Teams FR (scores types dans les profils films/séries)
- `FR-Tier-01` : +2400
- `FR-Tier-02` : +2000
- `FR-Tier-03` : +1600
- `FR-Tier-04` : +1000

### Bonus techniques (variable selon profil)
- HDR : Dolby Vision > HDR10+ > HDR10 > HDR (poids fort en 4K, modéré en 1080p)
- Audio premium : Atmos / TrueHD / DTS-X / DTS-HD MA / DTS-HD HRA / DTS-ES /
  Dolby Digital + / Dolby Digital / FLAC / PCM / Opus / AAC
- Codec : x265 / h265 (+), VP9 / Xvid (-)
- Édition : IMAX / IMAX Enhanced / Theatrical (films)
- Source 4K downscale 1080p : `UHD Bluray` (HDR basique annoncé dans le titre)
- Streamers : `FR-Streamer-Premium` (Netflix, Prime, Disney+, Apple TV+, HBO Max/Max, Paramount+)
  et `FR-Streamer-Standard` (NOW, Crunchyroll, iTunes WEB)
- Séries : Season Pack, TV Extras
- Repacks : `FR-Repack-3` (PROPER3/REPACK3), `FR-Repack-2` (PROPER2/REPACK2, REAL…PROPER), `FR-Repack` (PROPER / REPACK / RERIP / REAL simple)

### Exclusions fortes (score -999999)
- `FR-Blockers` (groupes bannis, NVENC/QSV/AMF, incohérences codec)
- `AV1` (compatibilité matériel)
- `Upscale` / `Upscaled` (faux upscales / IA)
- `Remux`, `Full Disc` (sauf `FR-Films-Any`)
- `x264 (2160p)` (4K uniquement, incohérence charte C411)

> `FR-Films-Any` est **volontairement permissif** : il accepte Remux / Full Disc
> pour servir de filet de sécurité quand le 1080p/4K strict ne trouve rien.

---

## Limites connues

- Les tests regex reposent uniquement sur le **titre de release**.
- Pas de garantie sur les paramètres réels (bitrate, profil DV, piste audio).
- Les listes teams/blockers FR sont éditoriales : à entretenir avec la scène.
- 7 regex officielles utilisent des lookbehinds variables (Python OK, Ruby refuse) —
  fonctionnel dans Profilarr (Python).

---

## Maintenance recommandée

Ordre de travail :
1. `README.md`
2. `media_management/quality_definitions.yml`
3. `regex_patterns/` (vérifier les FR-* d'abord)
4. `custom_formats/` (vérifier les FR-* d'abord)
5. `profiles/` (FR-* uniquement)

À chaque changement :
- vérifier le schéma des tests v1,
- vérifier la cohérence des références (`pattern` ↔ regex, `name` ↔ custom),
- valider le YAML avant import Profilarr.

---

## Checklist avant import Profilarr

- [ ] Tous les fichiers YAML sont parseables.
- [ ] Les tests `regex_patterns` utilisent `id/input/expected` (ou `tests: []`).
- [ ] Les tests `custom_formats` utilisent `id/input/expected` (ou `tests: []`).
- [ ] Tous les `pattern` de `custom_formats` existent dans `regex_patterns`.
- [ ] Tous les `name` de `profiles.custom_formats` existent dans `custom_formats`.
- [ ] Hiérarchie langue respectée :
      `FR-MULTI-VF2 > FR-MULTI-VFF > FR-VF2 > FR-VFF > FR-VOSTFR`.
- [ ] `FR-Films-Any` permissif (pas d'exclusion Remux / Full Disc).
- [ ] Profils 4K excluent `x264 (2160p)`, `AV1`, `Remux`, `Full Disc`.
- [ ] Profils 1080p / 720p excluent `Remux`, `AV1`.
- [ ] `quality_definitions.yml` respecte `max ≤ 2000` (Radarr) et `max ≤ 1000` (Sonarr).

---

## Origine et crédits

- Base technique : [Dictionarry-Hub/database](https://github.com/Dictionarry-Hub/database)
  (audio, codec, HDR, sources, streamers, edition).
- Couche FR : **propre au projet** — préfixée `FR-*`, basée sur la charte C411 et
  les usages observés sur La Cale / Gemini / YGGtorrent.
- Profils 100% personnels : 7 profils FR films + séries (720p / 1080p / 4K / Any).

# Profilarr v2 — installation

Ce dépôt est une base **PCD** (SQL dans `ops/`) pour **Profilarr ≥ 2.0.0** uniquement.

## Références

- [Profilarr v2](https://v2.dictionarry.dev/devlogs/profilarr-v2)
- [Installation](https://v2.dictionarry.dev/profilarr-setup/installation)
- [Schema PCD](https://github.com/Dictionarry-Hub/schema)

## Lier ce dépôt

1. **Profilarr v2** (image `ghcr.io/dictionarry-hub/profilarr`, voir `docs/compose-profilarr-v2.yml`).
2. UI → lier `https://github.com/mcflykid/french-profilarr-database` (PAT GitHub si privé).
3. **Compile** puis **Sync** vers Radarr / Sonarr.
4. Assigner les profils `FR-Films-*`, `FR-Series-*`, `FR-Anime-*`.

Le manifest `pcd.json` dépend de `https://github.com/Dictionarry-Hub/schema` en **1.1.0**.

## Convention de noms (se repérer dans l’UI v2)

Tout est préfixé **`FR-`**. Dans les listes Profilarr, les entrées se regroupent et se lisent comme une famille :

```text
FR-Delay-Radarr          ← délai (une fois par instance Radarr)
FR-Delay-Sonarr          ← délai (une fois par instance Sonarr)

FR-Media-Base            ← modèle interne — ne pas assigner aux bibliothèques

FR-Films-4K              ← profil qualité Radarr = bundle media (même nom)
FR-Films-1080p
FR-Films-720p
FR-Films-Any

FR-Series-4K             ← profil Sonarr (séries live)
FR-Series-1080p
FR-Series-720p

FR-Anime-4K              ← profil Sonarr (type Anime)
FR-Anime-1080p
FR-Anime-720p
```

**Règle simple :** le nom du **profil qualité** = le nom du **preset Media Management**. Ne pas assigner **`FR-Media-Base`** aux bibliothèques.

Tags filtres (`ops/10`) : `Radarr` / `Sonarr` / `Films` / `Series` / `anime` sur les profils.

| Fichier | Rôle |
|---------|------|
| `ops/06` | Profils qualité + scores CF |
| `ops/07` | `FR-Media-Base` + `FR-Delay-Radarr` |
| `ops/09` | Clone media par profil + `FR-Delay-Sonarr` |
| `ops/10` | Tags UI (Radarr, Films, …) |
| `ops/11` | Tests custom formats (parser) |
| `ops/12` | Simulations profil qualité (`test_entities` / `test_releases`) |

Regénérer les clones media : `python3 scripts/generate_profile_media_ops.py`

### Renommage et Remux

- **Renommage désactivé** : tous les presets `FR-*` héritent de `rename = 0` (`ops/07` / `ops/09`). Les noms de fichiers restent ceux de l’indexeur.
- **Pas de Remux** : `Remux` et `Full Disc` sont à **-999999** sur **tous** les profils, y compris `FR-Films-Any`.

### Animé Sonarr

Les profils `FR-Anime-*` partagent la même logique media que `FR-Series-*` (un bundle par nom de profil). Sonarr ne synchronise pas un onglet « Anime » séparé pour les tailles : les valeurs 2160p dans `ops/09` s’appliquent aussi aux bibliothèques de type Anime.

## Message « Quality profiles require media management settings and a delay profile »

Profilarr v2 exige un **bundle media** par profil et un **delay** par instance. Ce dépôt aligne les noms pour que ce soit évident dans l’UI.

### À choisir dans Profilarr

| Instance | Delay profile (réglage global) | Profil + Media (par bibliothèque) |
|----------|--------------------------------|-----------------------------------|
| **Radarr** | `FR-Delay-Radarr` | `FR-Films-4K`, `FR-Films-1080p`, … |
| **Sonarr** | `FR-Delay-Sonarr` | `FR-Series-*`, `FR-Anime-*` |

**Workflow :** Pull → Compile → Sync → delay `FR-Delay-Radarr` ou `FR-Delay-Sonarr` → sync des profils `FR-*` (media du même nom).

## Repack et upgrades

- Media : `doNotPrefer` (repack géré par les CF `FR-Repack`, `FR-Repack-2`, `FR-Repack-3`).
- Upgrades Radarr/Sonarr : `upgrades_allowed` sur les profils, scores CF pour choisir la meilleure release.

## Tests

Tests CF : `ops/11-custom-format-tests.sql`. Simulations profil : `ops/12-quality-profile-tests.sql` (Momie, POI, animé, Incendies). Nécessite le service **parser**.

Vérification locale :

```bash
./scripts/check.sh
```

## Personnalisation locale (tweaks)

Pour des scores ou CF locaux sans fork : voir [`tweaks/README.md`](../tweaks/README.md). Ne pas activer le renommage ni autoriser Remux si tu restes aligné avec ce dépôt.

## Dépannage Sonarr `PUT customformat` Fatal

Souvent une **regex invalide** dans `ops/02-regex.sql`. Corriger puis :

```bash
python3 scripts/validate_regex_ops.py
```

Puis Profilarr : Pull → Compile → Sync.

## Customisations Profilarr

Couche optionnelle dans l’UI v2 pour ajuster scores ou CF **sans** modifier le dépôt upstream — utile pour tests personnels ; documenter les écarts si tu remontes une suggestion en issue.

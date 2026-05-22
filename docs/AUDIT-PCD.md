# Audit PCD — Profilarr v2 / schema 1.1.0

Dernière vérification : `python3 scripts/validate.py` (intégrité + compile + regex Sonarr + audit doc).

Références : [Profilarr v2](https://v2.dictionarry.dev) · [Schema 1.1.0](https://github.com/Dictionarry-Hub/schema) · [PROFILARR-V2.md](PROFILARR-V2.md)

## Synthèse

| Élément | Résultat |
|---------|----------|
| `pcd.json` | OK — schema `1.1.0`, `profilarr.minimum_version` `2.0.0`, `radarr` + `sonarr` |
| Compile (schema + ops) | OK |
| Sync Sonarr (regex descriptions) | OK — pas d’astérisque dans les descriptions `02` |
| `ops/11`–`12` | Absents — **optionnel** (conteneur parser) |

## Fichier par fichier

### `pcd.json`

| Critère doc | Statut |
|-------------|--------|
| Dépendance `Dictionarry-Hub/schema` **1.1.0** | OK |
| `profilarr.minimum_version` ≥ 2.0.0 | OK |
| `arr_types` radarr + sonarr | OK |

### `ops/01-tags.sql`

| Critère | Statut |
|---------|--------|
| `INSERT OR IGNORE` (idempotent) | OK |
| 28 tags, pas de doublon | OK |
| Tous les tags référencés dans `05` et `06` existent | OK |

### `ops/02-regex.sql`

| Critère | Statut |
|---------|--------|
| 69 motifs (une entrée = un nom unique) | OK |
| Description **sans `*`** (concaténation Sonarr) | OK |
| Chaque regex utilisée dans `04` (`re.name = …`) | OK — `7.1 Surround` retiré (orphelin, jamais branché en `04`) |

### `ops/03-custom-formats.sql`

| Critère | Statut |
|---------|--------|
| 65 CF, noms uniques | OK |
| `include_in_rename = 0` partout (repacks via `FR-Repack*`) | OK |
| Pas de markdown `**` / backticks | OK |

### `ops/04-custom-format-conditions.sql`

| Critère | Statut |
|---------|--------|
| 65 CF avec au moins une condition | OK |
| Regex `02` référencées toutes présentes | OK |
| Négations « Exclure : » (convention dépôt) | OK (~100) |

### `ops/05-custom-format-tags.sql`

| Critère | Statut |
|---------|--------|
| 65 CF liés à des tags | OK |
| `INSERT OR IGNORE` | OK |
| Tags ⊆ `01` | OK |

### `ops/06-quality-profiles.sql`

| Critère | Statut |
|---------|--------|
| 10 profils `FR-*` (4 films, 3 séries, 3 animé) | OK |
| `Remux`, `Full Disc`, `AV1`, `Upscaled`, `FR-Blockers` → **-999999** sur chaque profil | OK |
| Tags profil (`Radarr`/`Sonarr`/`Films`/`Series`/`anime`/`French`/résolution) dans `06` uniquement | OK |
| Pas de doublon `quality_profile_tags` | OK |
| Scores → CF connus (`03`) | OK (561 lignes) |

### `ops/07-media-management.sql`

| Critère | Statut |
|---------|--------|
| `FR-Media-Base` (modèle interne, **ne pas assigner** dans l’UI) | OK |
| `propers_repacks = doNotPrefer` (v2, pas `preferAndUpgrade`) | OK |
| `rename = 0` Radarr + Sonarr sur `FR-Media-Base` | OK |
| `FR-Delay-Radarr` : torrent, délai 0, bypass qualité | OK |
| Qualités = noms schema (`qualities`) | OK |
| Pas de `FR-Delay-Sonarr` ici | OK |

### `ops/09-profile-media-bundles.sql`

| Critère | Statut |
|---------|--------|
| 4 bundles Radarr = profils films | OK |
| 6 bundles Sonarr = séries + animé | OK |
| Nom bundle = nom profil qualité (doc media management v2) | OK |
| Clones naming/defs depuis `FR-Media-Base` | OK |
| `FR-Delay-Sonarr` uniquement ici | OK |

### `ops/10-profile-ui-tags.sql`

| Critère | Statut |
|---------|--------|
| Fichier vide (pas de `INSERT`) | OK — évite UNIQUE avec `06` (correctif compile v4) |

### `ops/11-custom-format-tests.sql`

| Critère | Statut |
|---------|--------|
| 424 tests, 56 CF couverts | OK |
| Optionnel sans conteneur parser | OK (doc v2 §8) |

### `ops/12-quality-profile-tests.sql`

| Critère | Statut |
|---------|--------|
| Momie, POI, animé, Incendies | OK |
| Optionnel sans conteneur parser | OK |

## Workflow Profilarr (rappel doc)

1. **Link** le dépôt → import `ops/*.sql`
2. **Pull** après chaque push Git
3. **Compile** (obligatoire — cache RAM)
4. **Sync** : CF, profils, media, delays
5. Instances : delay `FR-Delay-Radarr` / `FR-Delay-Sonarr` ; media = `FR-Films-4K`, etc.

## Fonctionnel (Profilarr après compile)

Vérification « chaque fichier sert à quelque chose dans l’UI / au Sync » :

```bash
python3 scripts/verify_functional.py
```

| Fichier | Rôle fonctionnel |
|---------|------------------|
| `pcd.json` | Lien dépôt, schema 1.1.0, cible Profilarr 2.x |
| `01` | Tags en base (FK + filtres) |
| `02` | Regex branchées sur des CF (sync sans orphelins) |
| `03`–`05` | CF exportables, tagués, filtrables |
| `06` | Profils assignables + scoring |
| `07` | Modèle media + **FR-Delay-Radarr** |
| `09` | **10 presets** (= noms profils) + **FR-Delay-Sonarr** |
| `10` | Vide (évite erreur compile) |
| `11`–`12` | Tests UI si conteneur **parser** actif |

## Commandes

```bash
python3 scripts/validate.py       # tout-en-un (recommandé avant push)
python3 scripts/audit_pcd_docs.py # règles doc uniquement
python3 scripts/verify_functional.py
```

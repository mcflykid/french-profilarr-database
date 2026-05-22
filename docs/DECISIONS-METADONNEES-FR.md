# Métadonnées FR — conventions Profilarr v2

Ce document explique **comment lire** les libellés dans l’UI Profilarr v2 pour cette base PCD.

## Où apparaît quoi

| Fichier | Champ UI | Rôle |
|---------|----------|------|
| `ops/02-regex.sql` | **Description** de la regex | Motif détecté + pourquoi on l’utilise |
| `ops/03-custom-formats.sql` | **Description** du format personnalisé | Comportement + impact scoring (« Pourquoi ») |
| `ops/04-custom-format-conditions.sql` | **Nom** de la condition | Annotation courte dans l’éditeur de conditions |
| `ops/06-quality-profiles.sql` | **Description** du profil | Objectif, priorités, exclusions |
| `ops/11-custom-format-tests.sql` | **Description** du test | Résultat attendu du parser (`doit` / `ne doit pas correspondre`) |
| `ops/12-quality-profile-tests.sql` | Entités + releases | Simulation profil qualité dans l’UI |

## Conventions uniformes

### Conditions (`ops/04`)

- **Détection positive** : nom du critère (`AAC`, `FR-Regex-VFF`, `Palier 01 — longue traîne haute`).
- **Exclusion (negate)** : préfixe **`Exclure :`** + nom du codec/format à ne pas cumuler (ex. `Exclure : TrueHD`).

### Formats personnalisés (`ops/03`)

- **Langue / scène FR** : phrase « Détecte… » + « Pourquoi : … » (priorité sur indexeurs FR).
- **Équipes `FR-Team-*`** : « Équipe X — profil typique » + pourquoi le bonus existe + renvoi scores `ops/06`.
- **Remux teams (HYPERION, OZEF)** : rappel que **Remux = -999999** sur nos profils → non retenues malgré la détection.
- **Blocages** : `AV1`, `FR-Blockers`, `Upscaled` documentent le **-999999** ou malus fort.

### Profils qualité (`ops/06`)

Structure commune :

1. **Profil** Radarr/Sonarr + résolution + contexte trackers FR.
2. **Objectif** : ce que le profil cherche (HEVC 4K, compact 720p, secours Any…).
3. **Priorité** : ordre langue / équipes (quand pertinent).
4. **Exclut** : ce qui est à -999999 ou refusé explicitement.

### Tests parser (`ops/11`)

- `Test parser — {CF} : doit correspondre` / `ne doit pas correspondre`
- Captures scène (`Momie`, `qBit`, etc.) : libellé libre en français, conservé tel quel.

## Scripts

```bash
python3 scripts/validate.py           # validation dépôt (mainteneurs)
# uniformisation historique : backup/scripts/normalize_fr_metadata.py
```

## Décisions notables (pourquoi)

| Décision | Pourquoi |
|----------|----------|
| Repack via CF, `doNotPrefer` en media | Profilarr v2 : les repack/proper sont notés par **FR-Repack***, pas par l’option native Radarr/Sonarr |
| Un bundle media par profil (`ops/09`) | Profilarr v2 exige media + delay ; le **nom du profil = nom du preset** |
| `FR-Films-Any` sans Remux | Secours « toute qualité » mais **encodes uniquement** — Remux / Full Disc à -999999 comme les autres profils |
| Renommage `rename = 0` | Les noms d’indexeur restent intacts ; pas de `[Custom Formats]` injecté par Radarr/Sonarr |
| Exclure : * sur l’audio | Héritage Dictionarry : une seule « famille » audio comptée par release |
| Streamers premium vs standard | Premium = catalogues majeurs FR ; standard = NOW, Crunchyroll, iTunes — Hulu/Peacock exclus |

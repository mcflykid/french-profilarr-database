# Changelog

Format basé sur [Keep a Changelog](https://keepachangelog.com/). Versions alignées sur `pcd.json`.

## [Unreleased]

### Modifié

- `docs/PROFILARR-V2.md` — guide unique aligné [v2.dictionarry.dev](https://v2.dictionarry.dev) (Pull → Compile → Sync, delays, media, 500).
- README — structure `docs/` allégée, workflow corrigé.

### Supprimé

- Docs redondants : `DEPANNAGE-500-CACHE`, `RELEASE-2.5.0`, `BASES-PARALLELES`, `exemples-releases`, `streamers-audit`.
- `tweaks/exemple-pas-de-remux.sql` (politique déjà dans `ops/`).

## [2.5.0] — 2025-05-19

### Ajouté

- `scripts/verify_team_tests.py` — chaque `FR-Team-*` a un test parser positif.
- `ops/12` enrichi : Momie (QTZ / Slay3R / TyHD vs Remux), POI, Demon Slayer, Incendies VOQ.
- Tests langue : VOQ sans MULTI (`FR-VF2` oui, `FR-MULTI-VF2` non).
- Dépannage compile / cache : [`docs/PROFILARR-V2.md`](docs/PROFILARR-V2.md).

### Supprimé (fin du support v1 dans le dépôt)

- Dossiers YAML : `profiles/`, `custom_formats/`, `regex_patterns/`, `media_management/`.
- `scripts/verify_yaml_migration.py`, `scripts/convert_yaml_to_pcd.py`, `docs/archive/`.
- Dépendance PyYAML (plus nécessaire).

### Modifié

- `generate_cf_tests_sql.py` — fusion `ops/11` + extras scène (sans git YAML).
- README / `PROFILARR-V2.md` — documentation 100 % PCD v2.

## [2.4.0] — 2025-05-19

### Ajouté

- CI GitHub Actions (`verify_pcd_v2`, regex, scores, parité YAML).
- `requirements.txt`, `CONTRIBUTING.md`, `scripts/check.sh`.
- `scripts/verify_expected_scores.py`, `scripts/verify_profile_scores.py`.
- `ops/12-quality-profile-tests.sql` (simulations Momie / POI).
- `docs/DECISIONS-METADONNEES-FR.md`, `docs/exemples-releases.md`, `docs/BASES-PARALLELES.md`, `docs/streamers-audit.md`.
- `tweaks/` — couche d’ajustements locaux (exemple sans Remux).
- Modèles d’issues GitHub.

### Modifié

- **Remux interdit sur tous les profils** (y compris `FR-Films-Any`) : `Remux` et `Full Disc` à -999999.
- Tests CF déplacés en `ops/11-custom-format-tests.sql`.
- Métadonnées FR uniformisées (descriptions, annotations `Exclure : …`).
- Tests `FR-Team-TyHD` ajoutés.

### Politique

- **Renommage Radarr/Sonarr désactivé** (`rename = 0`) — inchangé, documenté explicitement.

## [2.3.0] — 2025-05-19

- Descriptions et annotations en français ; script `normalize_fr_metadata.py`.

## [2.2.0] — 2025-05-19

- Bundles media par profil, delays `FR-Delay-*`, README v2.

## [2.1.0]

- Tests CF avec titres de release réels (`ops/08` → désormais `ops/11`).

# Contribution

Merci de contribuer à la base PCD **Profilarr v2** pour la scène française.

## Avant d’ouvrir une PR

```bash
python3 scripts/validate.py
```

(`./scripts/check.sh` est un alias.) Le CI exécute la même commande : intégrité `ops/`, compile PCD (schema 1.1.0), regex compatibles Sonarr.

Sans compile OK, Profilarr affiche **500 database cache not available** sur Media / Naming — voir [`docs/PROFILARR-V2.md`](docs/PROFILARR-V2.md).

## Conventions

- Préfixe **`FR-`** pour tout le spécifique scène FR.
- **Descriptions et annotations en français** — voir [`docs/DECISIONS-METADONNEES-FR.md`](docs/DECISIONS-METADONNEES-FR.md).
- **Pas de Remux** : tous les profils `FR-*` doivent garder `Remux` et `Full Disc` à **-999999** (encodes uniquement).
- **Pas de renommage actif** : `rename = 0` dans les presets media (`ops/07`, `ops/09`) — ne pas activer sans décision explicite du dépôt.
- Ordre des fichiers `ops/` : `01` … `12` (tests CF en `11`, simulations profil en `12`).
- **`ops/10-profile-ui-tags.sql`** : tags UI (`Radarr`, `Sonarr`, `Films`, `Series`) uniquement — **ne pas** réinsérer des tags déjà dans `ops/06` (`anime`, `French`, `2160p`, …).
- **`ops/11`** : une seule ligne par triplet `(custom_format, title, movie|series)` — `generate_cf_tests_sql.py` déduplique automatiquement.

## Types de changements

| Demande | Fichiers typiques |
|---------|-------------------|
| Nouvelle équipe | `ops/02-regex.sql`, `ops/03`, `ops/04`, `ops/06`, `ops/11` (test) |
| Score profil | `ops/06-quality-profiles.sql` |
| Regex / CF | `ops/02`–`05`, regénérer tests si besoin : `scripts/maintain/generate_cf_tests_sql.py` |
| Media / tailles | `ops/07`, `scripts/maintain/generate_profile_media_ops.py` |

## Issues

Utilise les modèles GitHub (bug regex, demande d’équipe, score).

## Questions

Ouvre une [issue](https://github.com/mcflykid/french-profilarr-database/issues) avec un **titre de release réel** quand c’est un problème de matching.

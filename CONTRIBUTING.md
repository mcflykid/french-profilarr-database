# Contribution

Merci de contribuer à la base PCD **Profilarr v2** pour la scène française.

## Avant d’ouvrir une PR

```bash
./scripts/check.sh
```

Le CI GitHub exécute les mêmes vérifications.

## Conventions

- Préfixe **`FR-`** pour tout le spécifique scène FR.
- **Descriptions et annotations en français** — voir [`docs/DECISIONS-METADONNEES-FR.md`](docs/DECISIONS-METADONNEES-FR.md).
- **Pas de Remux** : tous les profils `FR-*` doivent garder `Remux` et `Full Disc` à **-999999** (encodes uniquement).
- **Pas de renommage actif** : `rename = 0` dans les presets media (`ops/07`, `ops/09`) — ne pas activer sans décision explicite du dépôt.
- Ordre des fichiers `ops/` : `01` … `12` (tests CF en `11`, simulations profil en `12`).

## Types de changements

| Demande | Fichiers typiques |
|---------|-------------------|
| Nouvelle équipe | `ops/02-regex.sql`, `ops/03`, `ops/04`, `ops/06`, `ops/11` (test) |
| Score profil | `ops/06-quality-profiles.sql` |
| Regex / CF | `ops/02`–`05`, regénérer tests si besoin : `generate_cf_tests_sql.py` |
| Media / tailles | `ops/07`, `generate_profile_media_ops.py` |

## Issues

Utilise les modèles GitHub (bug regex, demande d’équipe, score).

## Questions

Ouvre une [issue](https://github.com/mcflykid/french-profilarr-database/issues) avec un **titre de release réel** quand c’est un problème de matching.

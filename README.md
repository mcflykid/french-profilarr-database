# French Profilarr Database

Base [Profilarr v2](https://v2.dictionarry.dev) / [PCD schema 1.1.0](https://github.com/Dictionarry-Hub/schema) pour la **scène française** (`FR-*`, sans Remux, `rename = 0`).

Profilarr ne lit que **`pcd.json`** et **`ops/*.sql`** ([template PCD](https://github.com/Dictionarry-Hub/database-template)).

Docs : [`docs/PROFILARR-V2.md`](docs/PROFILARR-V2.md) · [`docs/AUDIT-PCD.md`](docs/AUDIT-PCD.md) · [`docs/PROFILARR-RESET.md`](docs/PROFILARR-RESET.md)

## `ops/` (ordre d’import)

| Fichier | Rôle |
|---------|------|
| `01-tags.sql` | Tags |
| `02-regex.sql` | Regex (descriptions sans `*`) |
| `03`–`05` | Custom formats, conditions, tags CF |
| `06-quality-profiles.sql` | Profils + scores |
| `07` + `09` | Media (`FR-Media-Base`), delays, bundles (= nom profil) |
| `10-profile-ui-tags.sql` | Réservé vide |
| `11` / `12` | Tests parser (optionnel) |

## Validation

```bash
python3 scripts/validate.py
```

## Profilarr

Après push : **Pull → Compile → Sync**. Delays : `FR-Delay-Radarr` / `FR-Delay-Sonarr`. Media : même nom que le profil (`FR-Films-4K`, etc.) — pas `FR-Media-Base`.

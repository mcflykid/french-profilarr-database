# Contribution

```bash
python3 scripts/validate.py
```

Modifications typiques : `ops/02`–`06`. Conventions : [`docs/DECISIONS-METADONNEES-FR.md`](docs/DECISIONS-METADONNEES-FR.md).

- Préfixe **`FR-`**
- **Remux** / **Full Disc** à **-999999** sur tous les profils
- **`rename = 0`** dans les presets media
- **`ops/10`** : pas de tag déjà présent dans **`ops/06`** (ex. `anime`)

Régénération rare : `scripts/maintain/rebuild_ops.py` (depuis `backup/snapshot-2.5/`).

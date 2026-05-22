# Changelog

## [3.0.0] — 2025-05-22

### Changement majeur

- Réécriture du dépôt : contenu actif = `pcd.json` + `ops/` uniquement.
- Ancienne arborescence entière dans **`backup/snapshot-2.5/`**.
- `ops/` reconstruits fichier par fichier (en-têtes v3, regex Sonarr-safe, `ops/10` sans doublon `anime`).
- Validation unique : `python3 scripts/validate.py`.

### Contenu inchangé (logique FR)

- 10 profils `FR-*`, 65 custom formats, politique anti-Remux et `rename = 0`.

## Historique

Versions **2.x** : voir [`backup/snapshot-2.5/CHANGELOG.md`](backup/snapshot-2.5/CHANGELOG.md).

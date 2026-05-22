# Backup — ancienne arborescence

Tout ce qui existait avant la réécriture **v3.0.0** est dans [`snapshot-2.5/`](snapshot-2.5/) :

| Contenu | Description |
|---------|-------------|
| `snapshot-2.5/ops/` | Anciens SQL (base de la réécriture v3) |
| `snapshot-2.5/docs/`, `scripts/`, `README.md`, … | Doc et outils d’origine |
| `snapshot-2.5/backup-nested/` | Scripts archivés (migration YAML, etc.) |
| `profiles/`, `custom_formats/`, … | YAML v1 s’ils étaient encore présents |

**Dépôt actif (Profilarr) :** uniquement `pcd.json` + `ops/` à la racine.

Pour régénérer `ops/` depuis le snapshot : `python3 scripts/maintain/rebuild_ops.py`

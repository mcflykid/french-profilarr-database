# Release 2.5.0 — PCD v2 natif

## Résumé

- Dépôt **100 % Profilarr v2 (PCD/SQL)** : suppression des anciens dossiers YAML (`profiles/`, `custom_formats/`, `regex_patterns/`, `media_management/`).
- **Remux interdit** sur tous les profils `FR-*`, y compris `FR-Films-Any`.
- Tests enrichis : `ops/11` (parser CF), `ops/12` (simulations profil Momie / POI / animé / Incendies).
- CI : structure v2, regex, scores, **couverture équipes**, métadonnées FR.

## Après mise à jour

1. Profilarr : **Pull → Compile → Sync**
2. Vérifier delay `FR-Delay-Radarr` / `FR-Delay-Sonarr` et bundles media = nom du profil
3. Tester simulations dans l’UI (`ops/12`) avec profil `FR-Films-4K`

## Scripts locaux

```bash
./scripts/check.sh
```

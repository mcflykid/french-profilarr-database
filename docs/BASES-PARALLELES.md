# Bases PCD en parallèle (ne pas fusionner)

| Base | Rôle | Lien |
|------|------|------|
| **french-profilarr-database** (ce dépôt) | Scène FR : langues VFF/VF2, équipes C411, 4KLight, profils `FR-*`, **sans Remux** | Ici |
| [Dictionarry database v2](https://github.com/Dictionarry-Hub/database/tree/v2) | Évolution technique globale (codec, HDR, audio) | Optionnel en 2ᵉ base |
| [trash-pcd](https://github.com/Dictionarry-Hub/trash-pcd) | Logique TRaSH / streamers US, branche `french` = MULTi.VO différent | Référence uniquement |

## Pourquoi pas une seule base ?

- Noms de profils et scores **incompatibles** (TRaSH `French` vs `FR-MULTI-VFF`).
- Politique **anti-Remux** ici ; TRaSH autorise souvent Remux sur certains profils.
- La scène FR (C411, tags 4KLight/HDLight, équipes QTZ…) est **spécifique** à ce PCD.

## Usage recommandé

1. Lier **ce dépôt** comme base principale Profilarr v2.
2. Optionnel : second repo Dictionarry pour mises à jour regex audio/HDR — **sans écraser** les scores `FR-*`.
3. Comparer [streamers-audit.md](streamers-audit.md) avant d’importer des regex trash-pcd.

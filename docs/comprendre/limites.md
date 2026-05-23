# Limites de Radarr

**En bref** : Radarr ne lit que le **nom** affiché sur le tracker (+ la taille du fichier). Pas le MediaInfo, pas les règles « slots » de C411. Deux indexeurs peuvent donner **des points différents** pour le même fichier si le **titre** change.

[← Index doc](../README.md) · [Calibrage](calibrage.md)

---

| Même release, scores différents entre indexeurs | Titre différent (YGG ajoute `.FRENCH`) ou **`MULTI` seul** sur un indexeur : seul le titre **conforme C411** (`MULTI.VFF`, etc.) reçoit le bonus langue. Colonne **Langue** Radarr = métadonnée indexeur, pas le score CF. |

| Situation | Comportement |
|-----------|--------------|
| Même titre, deux trackers | Même score CF |
| Même fichier, **titres différents** | Scores différents (normal) |
| Tailles différentes | Qualité native + preset media divergent |
| `.mkv` dans le nom | Parsing parfois altéré |

**Ce n’est pas un bug Profilarr** : tout part du **titre indexeur**.

### Tests de référence (`ops/12`)

- **La Momie** (TMDB 564) — QTZ 4KLight vs Slay3R WEB vs TyHD vs Remux vs AV1
- Variante TRUEFRENCH / HDR (cross-indexeur)
- **Person of Interest** — `MULTI.FRENCH` (DELIRIUS)
- **Incendies** — VOQ sans MULTI vs MULTI.VOQ
- **Demon Slayer** — WEB CR MULTI VFF

---

---

[← Index doc](../README.md) · [← README](../../README.md)

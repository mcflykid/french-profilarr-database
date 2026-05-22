# Exemples de releases (référence tests)

Titres réels utilisés dans `ops/11` et `ops/12` — **sans nom de tracker**.

## Langue / MULTI

| Titre | Cas testé |
|-------|-----------|
| `La.Momie.1999.MULTI.VFF.2160p.WEB.DV.HDR10PLUS.AC3.5.1.H265-Slay3R` | MULTI + VFF + DV + HDR10+ |
| `Person.Of.Interest.S05.MULTI.FRENCH.1080p.WEBRip.x265-DELIRIUS` | MULTI.FRENCH (série) |
| `La.Momie.1999.MULTI.TRUEFRENCH.2160p.WEB.DV.HDR...` | MULTITRUEFRENCH / variante |

## Équipes

| Team | Exemple |
|------|---------|
| QTZ | `1917.2019.MULTI.VFF.2160p.BluRay.4KLight...-QTZ` |
| Slay3R | `Caught.Stealing.2025.MULTI.VF2.2160p.WEB.DV.HDR10Plus...-Slay3R` |
| TyHD | `La.Momie.1999.MULTI.VFF.2160p.WEB...-TyHD` |
| THESYNDiCATE | `Destins.croises.2026.MULTI.VFF.2160p.WEB...-THESYNDiCATE` |

## À rejeter (profils FR-*)

| Type | Exemple |
|------|---------|
| **Remux** | `...UHD.BluRay.Remux.TrueHD...` |
| **AV1** | `...AV1-THESYNDiCATE` |
| **Full Disc** | `...COMPLETE BLURAY...` / `BR-DISK` |

## Simulations profil (`ops/12`)

- Film **La Momie** (TMDB 564) : WEB Slay3R vs 4KLight QTZ vs Remux (doit perdre).
- Série **Person of Interest** (TMDB 1411) : MULTI.FRENCH vs Remux épisode.

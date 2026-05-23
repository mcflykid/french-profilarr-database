# Image et son

**En bref** : bonus si le titre annonce **Dolby Vision**, **HDR10+**, **Atmos**, **x265**… Une seule famille audio compte (pas DD + DTS en double). **AV1** et **x264 en 4K** sont refusés.

[← Index doc](../README.md) · [Principes](principes.md)

---

### Audio — une seule famille comptée

Conditions **Exclure :** entre AAC, Dolby, DTS, TrueHD, FLAC, etc. → pas de cumul absurde (+DD **et** +DTS sur la même ligne).

| Regex / CF | Détecte (exemples scène FR) |
|------------|----------------------------|
| **Dolby Digital** | `DD`, `AC3`, **`AC3.5.1`**, **`AC-3`**, **`AC-3.5.1`** (Torr9) — **pas** `E-AC-3` |
| **Dolby Digital +** | `DD+`, `EAC3`, **`EAC3.5.1`**, **`E-AC-3`**, **`E-AC-3.5.1`** |
| **FR-Regex-Atmos-Bundle** | `ATMOS`, `DDPA`, `TrueHD.A`, **`Atmos.5.1`** (WEB) |

### HDR en 4K

| CF | Score | Note |
|----|------:|------|
| Dolby Vision | 4500 | |
| DV (Without Fallback) | -500 | DV sans HDR lisible dans le titre |
| **HDR10+** | **2000** | |
| HDR10 | 1000 | |
| **HDR** (générique) | **1000** | Quand un indexeur omet `HDR10+` |
| Dolby Digital + | 400 | |
| Dolby Digital | 100 | AC3 parfois absent du titre |

**La Momie** : `…HDR10PLUS…` vs `…HDR…TRUEFRENCH…` → écart de score réduit tout en gardant la meilleure release devant.

### Codecs

| CF | Comportement |
|----|----------------|
| **AV1** | -999999 |
| **x264 (2160p)** | -999999 en 4K |
| **x265** / **h265** | Bonus 4K ; regex inclut **`H265`** / **`H264`** / **`AVC`** (naming C411) |
| **VP9** | Malus léger |
| **Xvid** | Malus fort HD |
| **FR-Blockers** | -999999 — YIFY, NVENC, REMUX+x264 incohérent, … |

### Streamers

| CF | Contenu |
|----|---------|
| **FR-Streamer-Premium** | NF, AMZN, DSNP, ATVP, HBO Max, Paramount+ |
| **FR-Streamer-Standard** | NOW, Crunchyroll, iTunes WEB — pas Hulu/Peacock (peu FR) |

---

---

[← Index doc](../README.md) · [← README](../../README.md)

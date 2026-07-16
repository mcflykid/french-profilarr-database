# Équipes et tags scène

**En bref** : un bonus si le **groupe** est dans le titre (`-SUPPLY`, `-QTZ`…). Les tags **4KLight**, **HDLight**, **WEBRip** (malus 4K) et **Repack** ajoutent aussi des points.

[← Index doc](../README.md) · [Image et son](image-son.md)

---

## Équipes

### Architecture

| Niveau | CF | Rôle |
|--------|-----|------|
| **Équipes** | `FR-Team-*` (17 groupes) | Bonus fort, calibrés sur releases réelles |
| **Longue traîne** | `FR-Tier-01`, `FR-Tier-02` | Petits bonus (regex compacte) |

Détection : suffixe **`-TEAM`** dans le titre (`(?<=^|[\s.-])TEAM\b`, insensible à la casse → `SLAY3R` = `Slay3R`).

On **n’utilise pas** le modèle [Profilarr-database-french-regex](https://github.com/Jojont54/Profilarr-database-french-regex) (~900 fichiers / team) : coût de maintenance >> gain sur les cas observés.

### Scores équipes (identiques sur les 10 profils)

| Équipe | Score | Profil typique / calibrage |
|--------|------:|----------------------------|
| **FR-Team-QTZ** | 5 500 | 4KLight Bluray, référence 4K |
| **FR-Team-Neostark** | 5 300 | **Uniquement** si `4KLight` **dans le titre** (C411 ~3–5 Go) ; WEBRip/WEB sans tag → pas de bonus équipe |
| **FR-Team-AMEN** | 5 200 | WEB 2160p compact DV/HDR10+ |
| **FR-Team-BONBON** | 5 000 | 4KLight / WEBRip ~2,5–5 Go |
| **FR-Team-TyHD** | 4 900 | WEB 2160p HEVC compact |
| **FR-Team-THESYNDiCATE** | 4 500 | WEB 2160p x265 |
| **FR-Team-SUPPLY** | 4 000 | WEB 2160p premium DV/HDR (C411). **Baissé de 4 800 (2026-07)** : `.mkv` interne générique (perd VFF/EAC3 → écart grab-vs-import, cf. churn HotD). Leur H264 perd désormais face à une équipe H265 au fichier propre (ex. ENIGMA) ; leur H265 reste devant |
| **FR-Team-BOUC** | 4 300 | WEB 2160p premium MULTI |
| **FR-Team-TFA** | 4 200 | WEB 2160p catalogue |
| **FR-Team-FW** | 4 000 | Forward, volume |
| **FR-Team-Winks** | 3 600 | 1080p BluRay/WEB x265 MULTI (~4–5,5 Go) |
| **FR-Team-PopHD** | 3 500 | 1080p HDLight x264 |
| **FR-Team-TOXIC** | 3 400 | 1080p HDLight |
| **FR-Team-ENIGMA** | 3 300 | WEB 1080p/2160p, VFQ |
| **FR-Team-Slay3R** | 3 200 | WEB 1080p/2160p/720p, H264/H265, exclus |
| **FR-Team-HYPERION** / **OZEF** | 800 | Remux détectés mais **jamais retenus** |
| **FR-Tier-01** | 800 | BOUBA, … (Neostark → `FR-Team-Neostark`) |
| **FR-Tier-02** | 400 | Longue traîne + DELIRIUS (`MULTI.FRENCH`) |

**Remux only** (HYPERION, OZEF) : reconnus pour logs, **Remux = -999999** → aucun impact sur la sélection.

---


## Signatures scène

| CF | Détection | Scoring |
|----|-----------|---------|
| **FR-4KLight** | `4KLight`, `4K.Light` | Fort bonus **4K** (**+3000** sur `FR-Films-4K` / Series / Anime) — avantage sur WEBRip seul (−750) |
| **FR-HDLight** | `HDLight` | Bonus 720p/1080p ; neutre/malus relatif en 4K |
| **FR-Hybrid** | `HYBRID` | Bonus UHD premium |
| **FR-Repack** / **-2** / **-3** | PROPER, REPACK, REAL… | Corrections dans le titre |
| **FR-WEBRip** | `WEBRip`, `WEB.Rip` | Malus **-750** profils **4K** (C411 : préférer WEB-DL) |
**Neostark** : bonus équipe **+5300** seulement avec tag **4KLight** dans le nom du torrent (~**8 300** cumulé avec `FR-4KLight` en 4K). Sans tag → **0** bonus Neostark ; les autres équipes (SUPPLY, TyHD, QTZ…) prennent le relais.

**QTZ** = équipe **et** souvent 4KLight en pratique — pas de CF `FR-Team-QTZ-4KLight` (un CF par **créneau**, pas par team×créneau).

---

---

[← Index doc](../README.md) · [← README](../../README.md)

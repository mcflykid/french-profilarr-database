# Image et son

**En bref** : bonus si le titre annonce **Dolby Vision**, **HDR10+**, **Atmos**, **x265**… Une seule famille audio compte (pas DD + DTS en double). **AV1** et **x264 en 4K** sont refusés.

**Lecture Plex** : **TrueHD** est **malusé** (éviter transcodage audio sur Apple TV 4K) ; privilégier **EAC3 / DD+ / Atmos** dans le titre (Direct Play fréquent).

[← Index doc](../README.md) · [Principes](principes.md)

---

### Plex, Apple TV 4K et Shield

| Lecteur | TrueHD en pratique |
|---------|-------------------|
| **Apple TV 4K** (v1/v2) — foyer principal | Plex transcode souvent TrueHD → FLAC/AC3 : **malus TrueHD** |
| **Freebox** (app Plex / DLNA) | Souvent transcode aussi — même logique |
| **Nvidia Shield 2017** | TrueHD Direct Play **plus souvent** possible — mais la base cible le **foyer ATV** |

À **langue / équipe / HDR égaux**, une release `…EAC3.5.1.Atmos…` ou `…DD+.Atmos…` passe devant `…TrueHD.7.1.Atmos…`.

### Foyers de référence (calibrage terrain)

Chaîne commune : **Apple TV 4K → Plex → HDMI → TV** (pas de barre son, pas d’AVR 7.1). Fiches constructeur / revendeurs (2025–2026).

| | **Foyer principal** | **Foyer mère** |
|--|----------------------|----------------|
| **TV** | **Toshiba 58U2963DG** (58", LED) | **TCL 55QLED780K** (55", QLED 2025) |
| **Image** | 4K, **Dolby Vision**, HDR10, HLG | 4K, **Dolby Vision**, HDR10+ (souvent meilleur contraste / HDR) |
| **HDMI** | 3× **HDMI 2.0**, **ARC** (HDMI 2) | 3× **HDMI 2.1**, **eARC** |
| **Son intégré (fiche)** | **Dolby Audio** + **Sound by Onkyo** ; DTS / TruSurround — **pas de Dolby Atmos** annoncé sur la gamme U2963DG | **2.1** (2×10 W + 15 W), **Dolby Atmos virtuel** + **DTS Virtual:X** (~35 W) |
| **7.1 / plafond** | Non — haut-parleurs TV classiques | Non — virtualisation sur TV + petit sub, pas de vrais canaux Atmos |
| **Plex + ATV** | TrueHD souvent **transcodé** ; flux Atmos WEB en **DD+/EAC3** plutôt Direct Play | Même logique Radarr ; la TCL *peut* virtualiser un flux Atmos reçu, mais Plex passe encore souvent par transcode sur TrueHD lourd |

**Atmos « dans l’oreille »** : sur la **Toshiba**, l’immersion Atmos **n’existe pas** côté TV. Sur la **TCL**, c’est du **Atmos marketing / virtuel** (2.1) — mieux qu’une TV 2.0 pure, mais **rien à voir** avec un salon Atmos (barre avec reflexion ou AVR). Les deux foyers n’ont **pas** de raison d’acheter des releases **`TrueHD 7.1 Atmos`** Blu-ray pour le son.

### Pourquoi on **garde** le bonus CF **Atmos** (pas de malus)

| Raison | Détail |
|--------|--------|
| **Pas un malus « coût »** | Le tag **Atmos** en scène FR WEB = souvent **`DDP5.1.Atmos` / `EAC3 Atmos 5.1`** — **léger**, même taille qu’un DD+ sans Atmos ; pas comme TrueHD + 7.1 sur Remux. |
| **Signal de bonne variante** | À langue / équipe / HDR égaux, `…WEB…DDP…Atmos…` doit rester devant `…BluRay…TrueHD.7.1.Atmos…` — c’est le cœur du calibrage Plex. |
| **Enlever ou maluser Atmos** | Favoriserait **par erreur** les gros Blu-ray TrueHD / 7.1 — exactement ce qu’on évite avec § TrueHD et **FR-Audio-71**. |
| **Pas de doublon inutile** | Pas besoin d’un CF « 5.1 » en plus : **5.1** est déjà dans DD+ / DD ; **7.1** est malusé ; **Atmos** reste le repère **WEB premium**. |
| **Quand revoir** | Barre **Atmos** ou **AVR** branché en eARC/ARC sur un foyer → recalibrer (TCL déjà en **eARC** si ajout matériel). |

**Décision** : **conserver Atmos +2500 (4K)** — aucune raison actuelle de l’enlever ni de le passer en malus.

### Audio — une seule famille comptée

Conditions **Exclure :** entre AAC, Dolby, DTS, TrueHD, FLAC, etc. → pas de cumul absurde (+DD **et** +DTS sur la même ligne).

| Regex / CF | Détecte (exemples scène FR) |
|------------|----------------------------|
| **Dolby Digital** | `DD`, `AC3`, **`AC3.5.1`**, **`AC-3`**, **`AC-3.5.1`** (Torr9) — **pas** `E-AC-3` |
| **Dolby Digital +** | `DD+`, `EAC3`, **`EAC3.5.1`**, **`E-AC-3`**, **`E-AC-3.5.1`** |
| **FR-Regex-Atmos-Bundle** | `ATMOS`, `DDPA`, `TrueHD.A`, **`Atmos.5.1`** (WEB) |

### Scores audio (profils 4K / 1080p)

| CF | 4K | 1080p | Note |
|----|---:|------:|------|
| **Atmos** (bundle) | 2500 | 800 | **Conservé** — repère WEB, pas malus (voir ci-dessus) |
| **Dolby Digital +** | 500 | 350 | WEB FR typique (EAC3) |
| **TrueHD** | **-800** | **-500** | Malus Plex / Apple TV |
| **FR-Audio-71** (titre `7.1`) | **-400** | **-400** | Pas de setup **7.1** — TV normale seulement |
| **Dolby Digital** | 120 | 80 | AC3 / **5.1** dans le titre |

**5.1 vs 7.1** : pas de CF bonus « 5.1 » (déjà couvert par `EAC3.5.1` / `AC3.5.1` → DD+ / DD). Le malus **`7.1`** reflète l’usage réel : **aucun matériel surround 7.1**, lecture sur **TV classique** — une piste 7.1 n’améliore pas l’écoute, elle favorise souvent les gros Blu-ray (`TrueHD 7.1`). On préfère les variantes **`EAC3 5.1`** quand elles existent.

### HDR en 4K

| CF | Score | Note |
|----|------:|------|
| Dolby Vision | 3500 | |
| DV (Without Fallback) | -50 | DV sans HDR lisible dans le titre |
| **HDR10+** | **2200** | |
| HDR10 | 1300 | |
| **HDR** (générique) | **1300** | Quand un indexeur omet `HDR10+` |
| Dolby Digital + | 500 | |
| Dolby Digital | 120 | AC3 parfois absent du titre |

**La Momie** : `…HDR10PLUS…` vs `…HDR…TRUEFRENCH…` → écart de score réduit tout en gardant la meilleure release devant.

### Codecs

| CF | Comportement |
|----|----------------|
| **AV1** | -999999 |
| **x264 (2160p)** | -999999 en 4K |
| **x265** / **h265** | Exclusifs : `x265` = tag littéral (+`DS4K`), `h265` = `H265` / `HEVC` — pas de cumul ; bonus sous 4K (à 2160p, HEVC est la norme, pas de bonus) |
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

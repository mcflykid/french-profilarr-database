# Hors scope

**En bref** : ce dépôt vise les **encodes compacts FR**, pas le remux catalogue ni l’usenet. Les **slots** C411 ne sont pas comptés dans Radarr — seulement des préférences entre titres.

[← Index doc](../README.md)

---

## Slots (créneaux UHD)

Sur une partie de la scène FR (indexeurs à **slots** UHD) :

| Créneau | Indications | Profil aligné |
|---------|-------------|---------------|
| **COMPAT** | x264 1080p | `FR-Films-1080p` |
| **HC OPTI** | HEVC 2160p ~2,5–8 Go, DV/HDR10+ | **`FR-Films-4K`** (TyHD, AMEN, BONBON) |
| **OPTI** | Gros WEB-DL ~15 Go | Accepté ; `preferred_size` 4K favorise plutôt le compact |

Trackers **sans slots** : même logique via tags (`MULTI.VFF`, `4KLight`, …).

---


## Ce qu’on rejette volontairement (et pourquoi)

| Piste | Verdict | Pourquoi ce n’est pas dans la base |
|-------|---------|-------------------------------------|
| ~900 regex / team (Jojont54) | **Non** | Maintenance ×10, PR énormes ; 17 teams + tiers couvrent les cas **observés** sur C411. |
| Ban VFQ | **Non** | Beaucoup de bibliothèques FR ont du VFQ ; on le **sous-classe** sous VFF, on ne l’interdit pas. |
| `release_group` séparé | **Pas urgent** | La scène FR met le groupe **dans le titre** ; condition `release_group` en doublon peu utile aujourd’hui. |
| Bundle media par profil qualité | **Non** | Profilarr v2 = un preset par **app** (Radarr / Sonarr / animé), pas par `FR-Films-4K`. |
| Repack natif « Prefer » | **Non** | Les REPACK sont dans le **titre** → CF `FR-Repack*` plus précis que le réglage Radarr générique. |
| CF **MUET** | **Non** | Radarr ne fiabilise pas la piste muette sans MediaInfo ; faux sentiment de règle C411. |
| Compteur de **slots** C411 | **Non** | Impossible dans Radarr : on **préfère** des créneaux (4KLight, WEB-DL) sans compter les doublons catalogue. |
| Noms de trackers dans la doc publique | **Évité** | « Scène FR privée » + calibrages **anonymisables** ; les noms restent dans les tests `ops/11` si besoin. |

Détail des décisions acceptées : [pourquoi.md](pourquoi.md).

**Roadmap** (non implémentée) : CF signatures par **créneau** en **ajout** aux tiers ; pas de suppression des tiers d’un coup.

---

---

[← Index doc](../README.md) · [← README](../../README.md)

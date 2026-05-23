# Torr9.net — règles tracker et alignement PCD

**En bref** : Torr9 impose une **nomenclature** proche de C411 (`MULTI`, `FRENCH`, `TRUEFRENCH`, `VOSTFR`). La base PCD est déjà calibrée sur des titres Torr9 (Damsel `MULTI` seul, DELIRIUS `MULTI.FRENCH`, TyHD, AC-3/E-AC-3). Cette page documente le tracker pour les calibrages futurs — **sans secrets** (passkey, cookie).

[← Index doc](../README.md) · [Calibrage](calibrage.md) · [Langue](langue.md) · [Équipes](equipes.md)

---

## Sécurité API / RSS

| Règle | Détail |
|-------|--------|
| **Limite** | **15 requêtes / minute** sur l’API Torr9 |
| **RSS freeleech** | `https://api.torr9.net/api/v1/rss/freeleech?passkey=VOTRE_PASSKEY&limit=100` |
| **Ne jamais committer** | Passkey, URL complète avec clé, ou identifiants dans `ops/` ou la doc publique |

Si une passkey a été exposée (chat, capture, commit), **la régénérer** dans le profil Torr9.

---

## Formats acceptés (tracker) vs PCD (Radarr)

| Domaine | Règle Torr9 | Choix PCD | Pourquoi l’écart |
|---------|-------------|-----------|----------------|
| **Conteneurs** | MKV, MP4, AVI, ISO (ISO seulement BluRay) | MKV/MP4 via qualités Radarr ; **Full Disc / ISO** exclus (−999999 / profil) | Objectif bibliothèque **encode**, pas image disque — voir [pourquoi.md](pourquoi.md) |
| **Vidéo** | x264, x265, AV1 ; XviD toléré (vieux) | x265 bonus ; **AV1 −999999** ; **Xvid** malus | Compat TV/box ; AV1 encore rare en scène FR privée chez nous |
| **Audio** | DTS:X, DTS-HD MA, DTS, TrueHD, EAC3, AC3, AAC, PCM, FLAC, **OPUS** | CF dédiés (Dolby, DTS, TrueHD, FLAC, **Opus**, …) | Aligné ; `AC-3.5.1` / `E-AC-3.5.1` testés Torr9 dans `ops/11` |
| **Sous-titres** | PGS, SRT, ASS, SSA | Non lus par Radarr à la sélection | Hors scope parser — [limites.md](limites.md) |

**Bitrate** (Torr9 recommande vidéo ≥ 800 kbps, seuils audio AAC/AC3/DTS) : **non vérifié** par Radarr — seulement la **taille fichier** via [tailles.md](../installer/tailles.md) (Mo/min).

---

## Nomenclature des titres

Modèle officiel Torr9 (points entre blocs) :

| Type | Modèle |
|------|--------|
| **Film** | `Titre.Année.Langue.Résolution.Source.CodecV.Audio-Groupe` |
| **Série** | `Titre.SXXEXX.Langue.Résolution.Source.CodecV.Audio-Groupe` |
| **Concert** | `Artiste.Spectacle.Année.Langue.Résolution.Source.CodecV.Audio-Groupe` |
| **Documentaire / TV** | Comme film ou série |

**Tags langue Torr9** : `FRENCH`, `VOSTFR`, `MULTI`, `TRUEFRENCH` selon les cas.  
**À éviter** sur le tracker : accents et parenthèses dans les noms.

### Correspondance PCD (langue)

| Tag Torr9 (exemples) | CF PCD | Note |
|----------------------|--------|------|
| `MULTI` seul | **FR-MULTI-ambig** (5,5k) | Cas **Damsel** — pas `FR-MULTI-VFF` |
| `MULTI.FRENCH` | **FR-MULTI-VFF** (7k) | Cas **Person of Interest** / DELIRIUS |
| `TRUEFRENCH` / `FRENCH` | **FR-VFF** ou **FR-MULTI-VFF** selon `MULTI` | `TRUEFRENCH` → regex VFF |
| `VOSTFR` | **FR-VOSTFR** | |
| Suffixe `.FRENCH` seul (YGG/Torr9) | Ne remplace pas `MULTI.VFF` | Tests Damsel dans `ops/11` |

Détail : [langue.md](langue.md).

---

## Équipes Torr9

### Présentes sur le tracker (liste officielle)

| Équipe Torr9 | Couverture PCD actuelle |
|--------------|-------------------------|
| **THESYNDiCATE** | **FR-Team-THESYNDiCATE** (score dédié) |
| **TyHD** | **FR-Team-TyHD** |
| **Delirius** | **FR-Tier-02** (regex `DELIRIUS`) — pas encore `FR-Team-*` dédié |
| **HeavyWeight**, **HK31**, **N3tFliX**, **BaDeVeL**, **BULiTT**, **GENESiS**, **SHADOW**, **REBiRTH**, **AnimesForAll**, **KTH**, **KAF**, **Blap** | Partiellement **FR-Tier-02** si nom dans la regex (ex. **KAF**) ; sinon **pas de bonus équipe** tant qu’aucun calibrage `ops/11` |

Pour ajouter une équipe au palier **FR-Team-*** : envoyer **5–30 titres** + tailles (workflow [calibrage.md](calibrage.md)).

### Interdites sur Torr9 → PCD

| Équipe | PCD |
|--------|-----|
| **k0RE** | **FR-Blockers** (−999999) — déjà dans `FR-Regex-Blockers` |
| **Dread-Team** | **FR-Blockers** (ajout regex) |
| **EXTREME** | **FR-Blockers** (ajout regex, suffixe groupe) |

---

## Différences assumées Torr9 ↔ ce dépôt

| Sujet | Torr9 | Ce PCD |
|-------|-------|--------|
| **AV1** | Accepté | **Exclu** (−999999) |
| **ISO BluRay** | Accepté | **Full Disc** exclu des profils `FR-*` |
| **MULTI** sans précision | Toléré tracker | **FR-MULTI-ambig**, pas 7k VFF |
| **Équipes non calibrées** | Présentes | Bonus **0** ou **tier** seulement |
| **Slots / modération** | Règles humaines | Non reproduits — [calibrage.md](calibrage.md) |

---

## Calibrage : quoi envoyer pour Torr9

1. **Captures** ou liste de titres complets (format ci-dessus).
2. **Tailles** en Go (min / typique / max).
3. **Équipe** et résolution dominante.
4. Préciser **Torr9** dans la description des tests `ops/11`.

Exemples déjà dans la base : DELIRIUS POI, Damsel `MULTI`, Mario TyHD / BATGirl, tests audio `AC-3.5.1` / `E-AC-3.5.1`.

---

## Pour les IA

Avant d’ajouter une regex « pour Torr9 » : vérifier un **titre réel**, documenter ici ou dans [calibrage.md](calibrage.md#journal-des-calibrages-récents), et ne **jamais** committer de passkey.

---

[← Index doc](../README.md) · [← README](../../README.md)

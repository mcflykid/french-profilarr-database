# Profils qualité

**En bref** : un profil = une résolution + des règles de points. Films Radarr : souvent `FR-Films-1080p` ou `FR-Films-4K`. Séries Sonarr : `FR-Series-*`. Animé : `FR-Anime-*`.

[← Index doc](../README.md) · [Guide](guide.md)

---

| Profil | App | Usage |
|--------|-----|--------|
| **FR-Films-1080p** | Radarr | Films 1080p — point de départ |
| **FR-Films-720p** | Radarr | Compacts (peu utilisé, symétrie) |
| **FR-Films-Any** | Radarr | Secours toute qualité, SD → 4K, **sans remux** |
| **FR-Films-4K** | Radarr | 4K — DV/HDR, 4KLight, équipes WEB |
| **FR-Series-1080p** | Sonarr | Séries 1080p + Season Pack |
| **FR-Series-4K** | Sonarr | Séries 4K |
| **FR-Series-720p** | Sonarr | Séries compactes |
| **FR-Anime-1080p/4K/720p** | Sonarr | Animé (type Anime) |

**Base de scoring commune aux 10 profils** (`ops/06`) : hiérarchie de langue FR (8k max) et scores équipes, avec pondérations techniques selon la résolution (ex. **Dolby Vision 3 500** en `FR-Films-4K` / `FR-Series-4K`, **1 200** en 1080p). Le bonus composé QTZ + 4KLight **+4 000** est propre à `FR-Films-4K`. **`upgrade_until_score` = 60 000** et **`upgrade_score_increment` = 1400** partout : à qualité équivalente, un remplacement fondé sur les formats personnalisés exige au moins **+1400 points** (voir [tailles.md](tailles.md)). Un passage vers un groupe de qualité supérieur, avant le cutoff, ne dépend pas de cet incrément ; les autres critères d'acceptation restent applicables.

Chaque profil **exclut** : Remux, Full Disc, AV1, Upscaled (+ x264@2160p sur 4K).

**Ordre des qualités** : dans Radarr/Sonarr, le haut de la liste est prioritaire. Les profils 4K affichent donc **2160p**, puis **1080p**, puis **720p** ; les profils 1080p affichent **1080p**, puis **720p**. Cet ordre permet l'upgrade `WEBDL-720p → Bluray-1080p` tant que le cutoff 2160p n'est pas atteint.

### Audit des dix profils — 20 septembre 2026

Ordre vérifié dans la base compilée, du plus prioritaire au moins prioritaire :

| Profil | Ordre des groupes | Mise à niveau jusqu'à |
|--------|-------------------|------------------------|
| `FR-Films-4K` | 2160p > 1080p > 720p | 2160p |
| `FR-Series-4K` | 2160p > 1080p > 720p | 2160p |
| `FR-Anime-4K` | 2160p > 1080p > 720p | 2160p |
| `FR-Films-1080p` | 1080p > 720p | 1080p |
| `FR-Series-1080p` | 1080p > 720p | 1080p |
| `FR-Anime-1080p` | 1080p > 720p | 1080p |
| `FR-Films-720p` | 720p uniquement | 720p |
| `FR-Series-720p` | 720p uniquement | 720p |
| `FR-Anime-720p` | 720p uniquement | 720p |
| `FR-Films-Any` | 2160p > 1080p > 720p > SD | 2160p |

Les dix profils autorisent les mises à niveau. Les profils **720p** restent volontairement limités au 720p : pour monter en résolution, attribuer un profil 1080p/4K au film ou à la série. Le dernier groupe de `FR-Films-Any` comprend aussi `Unknown`, conformément à son rôle de secours.

L'audit couvre **22 groupes et 87 membres** : ordre, groupes activés, cutoff unique sur la cible, résolutions des membres, absence de doublons, correspondances API Radarr/Sonarr et seuils CF. Il est exécuté à chaque validation, y compris sans parser. Ce résultat porte sur le dépôt compilé ; il ne confirme pas l'état des instances sur Nexus.

Après **Pull → Compile → Sync** vers **Radarr et Sonarr**, vérifier l'ordre ci-dessus dans leurs réglages. Une modification locale dans Profilarr ou un conflit de synchronisation peut empêcher le résultat du dépôt d'être appliqué ; consulter les différences signalées par Profilarr si l'ordre reste inversé. Les scores de simulation d'une release ne suffisent pas à valider les mises à niveau d'un fichier déjà présent.

Tags UI (`ops/06` + `ops/10`) : Radarr, Sonarr, Films, Series, 1080p/2160p/720p, French, **anime** (filtre Sonarr — tag SQL minuscule volontaire).

---

---

[← Index doc](../README.md) · [← README](../../README.md)

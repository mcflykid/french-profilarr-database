# French Profilarr Database

![CI](https://github.com/mcflykid/french-profilarr-database/actions/workflows/ci.yml/badge.svg)
![PCD](https://img.shields.io/badge/PCD-3.0.1-green)

Base **[PCD](https://github.com/Dictionarry-Hub/schema) 1.1.0** pour **[Profilarr v2](https://v2.dictionarry.dev)** — Radarr et Sonarr, **scène française** (`FR-*`), **sans Remux**, **`rename = 0`**.

| | |
|---|---|
| Version PCD | **3.0.1** |
| Contenu | 65 CF · 70 regex · 10 profils · delays · media par profil |
| Ancienne version | archivée dans [`backup/snapshot-2.5/`](backup/snapshot-2.5/) |

---

## Utilisation (Profilarr)

**Aucun script à installer.** Dans Profilarr :

1. Lier `https://github.com/mcflykid/french-profilarr-database`
2. **Pull** → **Compile** → **Sync**
3. Par instance : delay **`FR-Delay-Radarr`** / **`FR-Delay-Sonarr`**
4. Par bibliothèque : profil = **`FR-Films-4K`**, **`FR-Series-4K`**, **`FR-Anime-4K`**, etc. (même nom pour le preset media)

Guide complet : [`docs/PROFILARR-V2.md`](docs/PROFILARR-V2.md)

---

## Fichiers `ops/` (ordre Profilarr)

| Fichier | Rôle |
|---------|------|
| `01-tags.sql` | Tags |
| `02-regex.sql` | Motifs (descriptions sans `*` pour Sonarr) |
| `03`–`05` | Custom formats |
| `06-quality-profiles.sql` | Profils + scores |
| `07-media-management.sql` | `FR-Media-Base`, `FR-Delay-Radarr` |
| `09-profile-media-bundles.sql` | Bundle media par profil + `FR-Delay-Sonarr` |
| `10-profile-ui-tags.sql` | Tags UI (Radarr, Films, Series — pas `anime`) |
| `11` / `12` | Tests parser (optionnel) |

---

## Profils

| Radarr | Sonarr |
|--------|--------|
| `FR-Films-4K`, `1080p`, `720p`, `Any` | `FR-Series-4K`, `1080p`, `720p` |
| | `FR-Anime-4K`, `1080p`, `720p` (type Anime) |

Priorité langue : `FR-MULTI-VF2` > `FR-MULTI-VFF` > `FR-VF2` > `FR-VFF` > `FR-VOSTFR`.

---

## Dépannage rapide

| Problème | Action |
|----------|--------|
| 500 cache / Media grisé | [**Reset complet**](docs/PROFILARR-RESET.md) : Unlink → Relink → **Compile** |
| Sync Sonarr HDR en erreur | Pull **v3** (regex sans `*` dans descriptions) |
| Compile `ops/10` UNIQUE | Pull v3 ; ne pas réinsérer tag `anime` dans `10` |
| Delay incorrect | `FR-Delay-Radarr` / `FR-Delay-Sonarr`, pas `fr-default` |

---

## Mainteneurs

```bash
python3 scripts/validate.py
```

Voir [`CONTRIBUTING.md`](CONTRIBUTING.md).

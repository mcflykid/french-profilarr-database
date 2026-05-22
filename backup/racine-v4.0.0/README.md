# French Profilarr Database

![CI](https://github.com/mcflykid/french-profilarr-database/actions/workflows/ci.yml/badge.svg)
![PCD](https://img.shields.io/badge/PCD-4.0.0-green)

Base **PCD 1.1.0** pour **[Profilarr v2](https://v2.dictionarry.dev)** — scène FR, profils **`FR-*`**, **sans Remux**, **`rename = 0`**.

Anciennes versions : [`backup/`](backup/).

---

## Profilarr (rien à installer sur ton PC)

1. Lier `https://github.com/mcflykid/french-profilarr-database`
2. **Unlink** l’ancienne base si elle existait déjà
3. **Link** → attendre 100 %
4. **Compile** (obligatoire, doit être vert)
5. **Sync**
6. Delays : `FR-Delay-Radarr` / `FR-Delay-Sonarr`
7. Bibliothèques : `FR-Films-4K`, `FR-Series-4K`, `FR-Anime-4K`, …

**500 « database cache »** → [`docs/PROFILARR-RESET.md`](docs/PROFILARR-RESET.md)

Guide : [`docs/PROFILARR-V2.md`](docs/PROFILARR-V2.md)

---

## Racine du dépôt

```text
pcd.json
ops/01 … 12   (seule source de vérité)
docs/
scripts/validate.py
backup/       (archives)
```

Validation mainteneurs : `python3 scripts/validate.py`

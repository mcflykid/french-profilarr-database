# Maintenir la base

**En bref** : après un changement dans `ops/`, lancer `python3 scripts/validate.py`, mettre à jour la doc (**surtout [pourquoi.md](../comprendre/pourquoi.md)** si l’intention change), puis commit.

[← Index doc](../README.md) · [Pourquoi — référence IA](../comprendre/pourquoi.md)

---

## Tests et validation

```bash
python3 scripts/validate.py
```

Vérifie : intégrité `ops/`, compile SQLite (schema 1.1.0), descriptions regex sans `*`, **tests calibrage** (`ops/11` titres C411/Torr9/équipes), **cohérence doc ↔ SQL** (`verify_doc_scores.py` : les scores cités dans langue.md / equipes.md / image-son.md et les compteurs README doivent correspondre à `ops/06` — ajouté après une dérive de 7 scores dans image-son.md).

CI GitHub : workflow **Validate PCD** sur chaque push/PR vers `main`.

| Fichier | Rôle |
|---------|------|
| **`ops/11`** | ~498 tests parser par CF (titres réels / C411 / Torr9) |
| **`ops/12`** | Simulations profil (Momie, POI, …) |

Après modification SQL : **Pull → Compile** sur la base, puis revérifier les tests dans l’UI Profilarr.

---


## Structure du dépôt

```text
pcd.json                 # Métadonnées PCD 2.0.0
ops/
  01-tags.sql            # Tags UI
  02-regex.sql           # 76 motifs (pattern = détection)
  03-custom-formats.sql  # 77 CF (include_in_rename = 0)
  04-custom-format-conditions.sql
  05-custom-format-tags.sql
  06-quality-profiles.sql   # 10 profils FR-* + scores
  07-media-management.sql   # FR-Media-Radarr, FR-Delay-Radarr
  09-profile-media-bundles.sql  # FR-Delay-Sonarr
  10-profile-ui-tags.sql
  11-custom-format-tests.sql
  12-quality-profile-tests.sql
scripts/
  validate.py            # Pipeline CI locale
  normalize_descriptions.py
  verify_ops_integrity.py
  verify_pcd_compile.py
  verify_doc_scores.py    # Cohérence doc <-> SQL (scores, compteurs)
```

**Préfixe `FR-`** : spécifique marché français. Le reste reprend Dictionarry (`HDR10+`, `Remux`, …) pour rester **rebaseable**.

**Licence** : [MIT](../../LICENSE) (alignée sur `pcd.json`). Les parties dérivées de [Dictionarry-Hub/database](https://github.com/Dictionarry-Hub/database) restent soumises à leur licence d’origine si tu les réutilises hors de ce dépôt.

---


## Maintien de la documentation

**Règle du dépôt** : toute modification fonctionnelle dans `ops/` ou `scripts/` qui change un comportement visible doit **mettre à jour la page concernée dans `docs/`** (`installer/`, `comprendre/` ou `contribuer/`) et, si besoin, le README racine, dans le **même commit** (ou immédiatement après).

### Checklist mainteneur

- [ ] **[pourquoi.md](../comprendre/pourquoi.md)** mis à jour si la **décision** change (pas seulement un score)
- [ ] Tableau ou section concernée (langue, équipe, tailles, audio, …) à jour
- [ ] Ligne ajoutée dans [Journal des calibrages](../comprendre/calibrage.md#journal-des-calibrages-récents) si calibrage releases réelles
- [ ] Compteurs (CF, regex, tests) cohérents si le volume a changé
- [ ] `python3 scripts/validate.py` OK
- [ ] Mention **Pull → Compile → Sync** si changement déployable

### Ce qu’il faut documenter

| Type de changement | Où documenter |
|--------------------|------------------|
| Changement d’**intention** / philosophie | **[pourquoi.md](../comprendre/pourquoi.md)** + page thématique |
| Nouvelle équipe `FR-Team-*` | [Équipes](../comprendre/equipes.md) + journal |
| Regex langue / audio | [Langue](../comprendre/langue.md) ou [Image et son](../comprendre/image-son.md) |
| `ops/07` tailles | [Tailles](../installer/tailles.md) + journal |
| Score profil / CF | Tableaux scores + journal si motivation terrain |
| Nouveau profil `FR-*` | [Profils](../installer/profils.md) |

Les **agents / contributeurs** qui modifient ce dépôt doivent appliquer cette checklist sans rappel supplémentaire.

### Pour les IA qui modifient ce dépôt

1. **Lire en premier** [docs/comprendre/pourquoi.md](../comprendre/pourquoi.md) — intentions, alternatives écartées, fichiers liés.
2. **Ne pas simplifier** en supprimant tableaux, regex ou tests : la doc doit rester **complète** pour les prochains changements.
3. **Expliquer le pourquoi** dans le commit / la PR : quel problème terrain, quelle alternative refusée.
4. Tout score ou regex « équipe / langue » doit avoir un **test `ops/11`** sur un titre réel (description `C411`, `Calibrage`, nom d’équipe).
5. Si tu contredis une section « Ne pas » de `pourquoi.md`, **documenter** la nouvelle décision dans cette page avant de merger.

---


## Historique du dépôt

| Phase | Forme | Notes |
|-------|--------|--------|
| v1 | YAML | Profilarr v1 |
| v2.5 → v3 | PCD + `ops/*.sql` | Schema 1.1.0 |
| **2.0.0 actuel** | Racine = `pcd.json` + `ops/` + `scripts/` | Alignement Dumpstarr (seuils profil) |

Anciennes archives `backup/` : `git show <commit>:backup/...` (ex. `c1d52ee`).

**À importer dans Profilarr** : uniquement la **racine** du repo.

---


## Références

- [Profilarr v2 — Installation](https://v2.dictionarry.dev/profilarr-setup/installation)
- [Dictionarry-Hub/schema 1.1.0](https://github.com/Dictionarry-Hub/schema)
- [Dictionarry-Hub/database](https://github.com/Dictionarry-Hub/database)
- [Dumpstarr/Database](https://github.com/Dumpstarr/Database)
- [Issues](https://github.com/mcflykid/french-profilarr-database/issues)

---

*Base maintenue par [mcflykid](https://github.com/mcflykid) — communauté FR (TRaSH FR, bases contributives), sans fork officiel Dictionarry.*

---

[← Index doc](../README.md) · [← README](../../README.md)

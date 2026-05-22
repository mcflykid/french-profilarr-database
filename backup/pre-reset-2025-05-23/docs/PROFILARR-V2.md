# Utiliser cette base avec Profilarr v2

Guide d’exploitation de **french-profilarr-database** aligné sur la [documentation Profilarr v2](https://v2.dictionarry.dev) et le comportement réel de l’application (PCD, cache en mémoire, import des `ops/`).

---

## Avant de commencer

- **Profilarr v2 n’est pas une mise à jour de v1** : installation et `/config` **neufs**. Pas de migration depuis v1 ([accueil v2](https://v2.dictionarry.dev)).
- Ce dépôt est une **base PCD** (`pcd.json` + `ops/*.sql`), pas un fork YAML TRaSH.
- Références utiles :
  - [Installation](https://v2.dictionarry.dev/profilarr-setup/installation)
  - [Profilarr v2 — annonce](https://v2.dictionarry.dev/devlogs/profilarr-v2)
  - [Media management (catalogue Dictionarry)](https://v2.dictionarry.dev/media-management)
  - [Quality profiles (philosophie)](https://v2.dictionarry.dev/quality-profile)
  - [Schema PCD](https://github.com/Dictionarry-Hub/schema) **1.1.0**
  - [Template PCD](https://github.com/Dictionarry-Hub/database-template)

---

## 1. Installer Profilarr v2

Suis [Installation](https://v2.dictionarry.dev/profilarr-setup/installation) :

- Image : `ghcr.io/dictionarry-hub/profilarr:latest` (ou tag piné).
- Volume **`/config`** dédié v2 (ne pas réutiliser l’appdata v1).
- **`ORIGIN`** si reverse proxy.
- Conteneur **`parser`** : **optionnel** (tests CF / simulations profil uniquement). Tu peux retirer `parser` + variables `PARSER_*` si tu n’utilises pas `ops/11` ni `ops/12` dans l’UI.

Exemple Compose : [`compose-profilarr-v2.yml`](compose-profilarr-v2.yml) (avec `tmpfs` sur `/app/.cache` si le conteneur est en lecture seule).

Au premier lancement : **Settings → Onboarding** (lien base, instances Arr, sync).

---

## 2. Lier ce dépôt

1. **Databases** → **Link repository**
2. URL : `https://github.com/mcflykid/french-profilarr-database`
3. PAT GitHub si privé (`repo` + `workflow` si tu modifies la CI du dépôt)
4. Laisser finir le job (clone → dépendance schema → **import des `ops/`** → **compile** si la base est activée)

Profilarr stocke une copie des fichiers `ops/*.sql` dans **sa base interne** ; la compile lit cette copie, pas Git directement.

---

## 3. Workflow obligatoire (Pull → Compile → Sync)

```text
┌─────────────┐     ┌──────────────┐     ┌─────────────┐     ┌──────────────┐
│ Pull / Sync │ ──► │   Compile    │ ──► │  Instances  │ ──► │ Sync vers    │
│   (Git)     │     │ cache mémoire│     │ Radarr/Sonarr│     │ Radarr/Sonarr│
└─────────────┘     └──────────────┘     └─────────────┘     └──────────────┘
```

| Étape | Action | Effet |
|--------|--------|--------|
| **Pull** | Récupère Git + **ré-importe** les `ops/*.sql` dans Profilarr | Met à jour le SQL en base Profilarr |
| **Compile** | Rejoue schema + ops → **cache SQLite en RAM** | Obligatoire pour ouvrir Media / Naming / Quality dans l’UI |
| **Sync** | Envoie CF, profils, media, delays vers les *arr | Radarr/Sonarr reçoivent la config |

**Piège fréquent :** si Git est déjà à jour, **Pull seul ne recompile pas**. Après chaque Pull (ou après redémarrage du conteneur), lance **Compile** jusqu’à succès.

**Après un push sur GitHub :** `Pull` → **Compile** → **Sync**.

---

## 4. Connecter Radarr et Sonarr

Dans Profilarr (**External apps** / onboarding) :

- URL + clé API **admin** pour chaque instance
- Test de connexion OK

Ce n’est pas documenté sur une page `/bridging` en v2 ; c’est dans l’**onboarding** et les réglages d’instance.

---

## 5. Delay profile (une fois par instance)

Profilarr v2 impose un **profil de délai par instance** ([delay profiles](https://github.com/Dictionarry-Hub/profilarr) — protocole, délais, bypass).

| Instance Profilarr | Choisir dans l’UI |
|--------------------|-------------------|
| **Radarr** | `FR-Delay-Radarr` |
| **Sonarr** | `FR-Delay-Sonarr` |

Défini dans `ops/07` (Radarr) et `ops/09` (Sonarr). Torrent only, délai 0, bypass si meilleure qualité.

---

## 6. Media management (même nom que le profil qualité)

Chaque profil qualité `FR-*` a un **bundle media** du **même nom** (naming + quality definitions + media settings) :

| Profil qualité = Media | Application |
|------------------------|-------------|
| `FR-Films-4K`, `FR-Films-1080p`, `FR-Films-720p`, `FR-Films-Any` | Radarr |
| `FR-Series-4K`, `FR-Series-1080p`, `FR-Series-720p` | Sonarr séries |
| `FR-Anime-4K`, `FR-Anime-1080p`, `FR-Anime-720p` | Sonarr animé |

**Ne pas assigner** `FR-Media-Base` (modèle interne dans `ops/07` / clones `ops/09`).

Politique dépôt :

- **`rename = 0`** — les noms restent ceux de l’indexeur ([media settings](https://v2.dictionarry.dev/media-management/media-settings/media-settings-radarr-radarr) : repacks gérés par CF `FR-Repack*`, pas par Sonarr/Radarr natif).
- **Pas de Remux** — `Remux` / `Full Disc` à **-999999** sur tous les profils.

---

## 7. Sync vers les *arr

Lors du **Sync**, inclure au minimum :

- Custom formats  
- Quality profiles  
- **Media management** (naming, quality definitions, media settings)  
- **Delay profiles**

Puis dans Radarr/Sonarr : assigner le **profil qualité** `FR-*` par bibliothèque (ou via Profilarr selon ton flux).

---

## 8. Parser et tests (optionnel)

| Fichier | Usage dans Profilarr |
|---------|----------------------|
| `ops/11-custom-format-tests.sql` | Tests **custom formats** (service parser) |
| `ops/12-quality-profile-tests.sql` | Simulations **profil qualité** (Momie, POI, animé, Incendies) |

Sans parser : **lier, Pull, Compile, Sync** fonctionnent quand même.

---

## 9. Customisations locales (recommandé en v2)

Profilarr v2 propose une couche **Customisations** dans l’UI ([devlog v2](https://v2.dictionarry.dev/devlogs/profilarr-v2)) : ajustements locaux **sans** fork Git, sans conflit de merge avec upstream.

Le dossier [`tweaks/`](../tweaks/) reste valide pour un **second dépôt PCD** ou des ops SQL locaux ; pour un usage simple, préfère **Customisations** dans Profilarr.

---

## 10. Plusieurs bases (animé, TRaSH, etc.)

v2 peut lier **plusieurs bases** en parallèle ([devlog](https://v2.dictionarry.dev/devlogs/profilarr-v2)) :

- **Cette base** : scène FR (`FR-*`), sans Remux, langues FR.
- Optionnel : [TRaSH PCD](https://github.com/Dictionarry-Hub/trash-pcd) pour profils animé / international — **ne pas fusionner** la logique dans ce dépôt.

---

## 11. Fichiers `ops/` de ce dépôt

| Fichier | Rôle |
|---------|------|
| `01-tags.sql` | Tags |
| `02-regex.sql` | Regex |
| `03`–`05` | Custom formats |
| `06-quality-profiles.sql` | Profils + scores |
| `07-media-management.sql` | `FR-Media-Base`, `FR-Delay-Radarr` |
| `09-profile-media-bundles.sql` | Bundle media par profil + `FR-Delay-Sonarr` |
| `10-profile-ui-tags.sql` | Tags UI Radarr/Sonarr/Films/Series |
| `11` / `12` | Tests parser |

Regénération (rare) : `python3 scripts/maintain/generate_profile_media_ops.py` → `ops/09`.

Validation locale avant commit sur le dépôt :

```bash
python3 scripts/validate.py
```

---

## 12. Erreur 500 « Database cache not available »

Procédure pas à pas : [**PROFILARR-RESET.md**](PROFILARR-RESET.md).

Message Profilarr quand le **cache compilé** n’est pas en mémoire (`getCache()` vide).

**Causes :**

1. **Compile** jamais réussie (SQL cassé avant correctif, ou base **désactivée** après échec).
2. **Pull** sans **Compile** ensuite.
3. **Redémarrage** du conteneur sans recompile (cache RAM perdu).

**Procédure :**

1. **Pull** (importe les ops corrigés depuis Git).
2. Vérifier que la base est **activée** (`enabled`) dans Profilarr.
3. **Compile** — attendre succès sans erreur.
4. Ouvrir **Media management** → preset `FR-Films-4K` (plus de 500).
5. **Sync** vers Radarr/Sonarr.

**Logs :**

```bash
docker logs profilarr 2>&1 | tail -200 | grep -iE "cache|compile|Failed|UNIQUE|disabled|PCDCache"
```

**Reset :** Unlink la base → relink le dépôt → laisser **Import** + **Compile** terminer.

Utiliser la branche **`main`** version PCD **3.0.0** ou plus récente.

---

## 13. Autres problèmes

| Symptôme | Piste |
|----------|--------|
| *Quality profiles require media management and delay* | Delay `FR-Delay-*` + media = nom du profil |
| Sonarr `PUT customformat` 500 / `RegexParseException` | Souvent description avec `*` concaténée au motif (HDR/HDR10) — Pull dernier `main` → Compile → Sync |
| Sonarr `PUT customformat` Fatal | Regex `ops/02` → `validate_regex_ops.py` → Pull → Compile → Sync |
| Scores différents entre indexeurs | Titres différents sur le même fichier — normal |
| Compile échoue | Pull `main` ; schema `1.1.0` dans `pcd.json` ; validate.py si tu modifies ops |

Conventions libellés UI : [`DECISIONS-METADONNEES-FR.md`](DECISIONS-METADONNEES-FR.md).

---

## 14. Mise à jour du dépôt (mainteneurs)

```text
Modifier ops/ → python3 scripts/validate.py → commit → push
→ Profilarr : Pull → Compile → Sync
```

Ne pas réinsérer les tags déjà dans `ops/06` via `ops/10` (doublon → échec compile). Les tests `ops/11` doivent être uniques par `(custom_format, title, type)`.

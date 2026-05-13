# french-profilarr-database

Configuration **Profilarr v1** (Radarr / Sonarr) orientée **scène FR stricte** pour les usages proches des trackers privés (**C411**, **La Cale**, **Gemini**).

Ce dépôt centralise :
- la détection des releases via regex,
- la logique métier via custom formats,
- les règles de scoring via profils,
- les contraintes de gestion média (tailles, naming, options).

L'objectif est d'automatiser la sélection de releases en priorisant :
1. la **langue FR**,
2. la **qualité technique utile** (HDR/audio),
3. la **fiabilité des groupes**,
4. le **respect des contraintes de poids/compatibilité**.

---

## Compatibilité importante (Profilarr v1)

Ce dépôt est structuré pour **Profilarr v1**.

- Dans `regex_patterns/`, les tests utilisent le schéma v1 :
  - `id`
  - `input`
  - `expected`
- Dans `custom_formats/`, les tests restent au format de test custom format :
  - `title`
  - `type`
  - `should_match`
  - `description`

Si le schéma est mélangé, l'UI Profilarr peut afficher `Unexpected Error`.

---

## Ce qui est strict vs éditorial

### Strict (à ne pas casser)
- Schéma des tests `regex_patterns/` : `id`, `input`, `expected`.
- Schéma des tests `custom_formats/` : `title`, `type`, `should_match`, `description`.
- Références valides :
  - `custom_formats.conditions[].pattern` -> `regex_patterns.name`
  - `profiles.custom_formats[].name` -> `custom_formats.name`
- YAML valide dans tous les dossiers importés (`regex_patterns`, `custom_formats`, `profiles`, `media_management`).

### Éditorial (modifiable selon votre politique)
- Listes teams (`FR-Tier-01`, `FR-Tier-02`) et blocklist (`FR-Blockers`).
- Pondération fine des bonus/malus (hors hiérarchie langue).
- Choix de compatibilité matériel (ex : malus AV1, exclusion Remux/Full Disc selon profil).

---

## Structure du dépôt

### `regex_patterns/`
Bibliothèque de motifs regex nommés.
Chaque fichier contient :
- `name`
- `description`
- `pattern`
- `tests` (format v1)

Rôle : détecter des éléments dans le titre (langue, codecs, tags, groupes, repacks, etc.).

### `custom_formats/`
Règles consommées par Radarr/Sonarr.
Chaque custom format référence une ou plusieurs regex via le champ `pattern` dans les conditions.

Rôle : transformer des détections regex en signaux de scoring exploitables par les profils.

### `profiles/`
Profils FR films/séries (720p / 1080p / 4K / Any).
Rôle : hiérarchiser le score final (langue > qualité > teams > repacks > exclusions).

### `media_management/`
- `quality_definitions.yml` : bornes min/max/preferred par qualité
- `naming.yml` : templates de nommage
- `misc.yml` : options techniques annexes

---

## Philosophie de scoring

### Priorité linguistique
L'ordre logique est :
- `FR-MULTI-VF2`
- `FR-MULTI-VFF`
- `FR-VF2`
- `FR-VFF`
- `FR-VOSTFR`

Les écarts de score sont volontaires pour empêcher qu'un bonus secondaire (team/HDR/repack) dépasse la langue.

### Teams FR
- `FR-Tier-01` : bonus plus élevé
- `FR-Tier-02` : bonus légèrement inférieur

But : départager des releases de langue équivalente.

### Technique (4K)
Sur profils 4K, bonus dédiés :
- Dolby Vision / HDR10+ / HDR10
- TrueHD Atmos / DTS:X / TrueHD / DTS-HD MA

### Exclusions
Selon les profils, exclusions fortes via score très négatif :
- `FR-Blockers`
- `Remux`
- `Full Disc`
- `x264 (2160p)`
- `AV1`

> Note : le blocage AV1 est un choix de compatibilité matérielle dans ce dépôt. Il peut diverger de certaines politiques tracker.

---

## Convention d'annotations (uniformisation)

Tous les fichiers YAML suivent la même logique de lecture :
- bannière de tête,
- description explicite,
- commentaires fonctionnels courts,
- tests présents et contextualisés.

Dans `custom_formats/` :
- commentaire standard expliquant la référence regex,
- commentaire sur la logique des conditions quand nécessaire (`required`, `negate`).

Dans `profiles/` :
- commentaires par section (langue, teams, audio/HDR, repacks, exclusions).

---

## Limites connues

- Les tests regex reposent uniquement sur le **titre de release**.
- Les validations réelles de bitrate/profil DV/audio piste ne sont pas garanties par le titre seul.
- Les listes teams/blockers sont éditoriales et doivent évoluer avec la scène et les règles tracker.

---

## Maintenance recommandée

Ordre de travail conseillé :
1. `README.md`
2. `media_management/quality_definitions.yml`
3. `regex_patterns/`
4. `custom_formats/`
5. `profiles/`

À chaque changement :
- vérifier le schéma des tests,
- vérifier la cohérence des noms (`pattern` ↔ regex existante),
- valider le YAML avant import Profilarr.

---

## Checklist avant import Profilarr

- Valider que tous les fichiers YAML sont parseables.
- Vérifier qu'aucun test `regex_patterns` n'utilise `title/type/should_match`.
- Vérifier qu'aucun test `custom_formats` n'utilise `id/input/expected`.
- Vérifier que tous les `pattern` de `custom_formats` existent dans `regex_patterns`.
- Vérifier que tous les `name` de `profiles.custom_formats` existent dans `custom_formats`.
- Contrôler la hiérarchie langue (`FR-MULTI-VF2 > FR-MULTI-VFF > FR-VF2 > FR-VFF > FR-VOSTFR`) sur chaque profil.
- Contrôler que `FR-Films-Any` reste volontairement permissif (ne pas le durcir par défaut).

# Profilarr v2 — Sync (media, delay, profils qualité)

Le message **« Quality profiles require media management settings and a delay profile »** vient de l’écran **Sync** de Profilarr, pas d’une erreur de compile du dépôt.

## Ordre obligatoire (par instance Radarr ou Sonarr)

Profilarr exige d’**enregistrer** le media management et le delay **avant** de sauver les profils qualité.

```text
1. Media Management  →  Save
2. Delay profile     →  Save
3. Quality profiles  →  Save  →  Sync
```

Si une section est encore « dirty » (modifiée non sauvée), le bandeau d’avertissement reste affiché.

## Media Management — une config par instance

Ce n’est **pas** un preset par profil `FR-Films-1080p`. C’est **un seul triplet** pour toute l’instance :

| Menu Profilarr | Choisir (Radarr) | Choisir (Sonarr) |
|----------------|------------------|------------------|
| Naming | `French Profilarr Database` / **`French - Radarr`** | `French Profilarr Database` / **`French - Sonarr`** |
| Quality definitions | idem **`French - Radarr`** | idem **`French - Sonarr`** |
| Media settings | idem **`French - Radarr`** | idem **`French - Sonarr`** |

Les **trois** listes doivent pointer vers le **même** nom de preset (`French - Radarr` ou `French - Sonarr`).

Ne pas utiliser `FR-Media-Base` (gabarit interne SQL uniquement).

## Delay profile — une fois par instance

| Instance | Delay à choisir puis **Save** |
|----------|------------------------------|
| Radarr | **`FR-Delay-Radarr`** |
| Sonarr | **`FR-Delay-Sonarr`** |

## Quality profiles — cases à cocher

Ensuite seulement, cocher les profils voulus, par ex. :

- Radarr : `FR-Films-1080p`, `FR-Films-4K`, …
- Sonarr : `FR-Series-1080p`, `FR-Anime-1080p`, …

**Save**, puis **Sync** (ou Pull → Compile → Sync si la base Git a changé).

## Workflow Git

1. **Pull** la base
2. **Compile**
3. Configurer l’instance comme ci-dessus
4. **Sync**

## Références

- [Installation Profilarr v2](https://v2.dictionarry.dev/profilarr-setup/installation)
- Logique UI : `Profilarr` → `src/routes/arr/[id]/sync/+page.svelte` (`qualityProfilesCanSave`)

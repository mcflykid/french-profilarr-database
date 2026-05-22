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

## Workflow Git (deux endroits différents)

### Sur la base « French Profilarr Database » (dépôt Git)

1. **Pull** — importe les `ops/*.sql` (tes logs `updated:11` = OK)
2. **Compile** — obligatoire pour remplir le cache (profils, delays, presets `French - Radarr` visibles dans l’UI)

Sans **Compile**, les listes déroulantes de l’instance Arr peuvent rester vides ou anciennes.

### Sur chaque instance Arr (Radarr **et** Sonarr séparément)

Menu **Arr** → ton instance → onglet **Sync** — ce n’est **pas** le Pull de la base.

## Logs `Job finished … (skipped)` — ce que ça veut dire

Exemple typique après un Pull :

```text
arr.sync.qualityProfiles (skipped)
arr.sync.delayProfiles (skipped)
arr.sync.mediaManagement (skipped)
```

Profilarr a bien lancé les jobs post-Pull, mais **aucune config Sync n’est enregistrée** pour cette instance (`hasConfig` = false dans le code Profilarr). Ce n’est pas une erreur SQL du dépôt.

**À faire :** ouvrir **Arr → [Radarr ou Sonarr] → Sync**, configurer chaque bloc, cliquer **Save** sur chacun, puis **Sync** (bouton dans la carte) une fois rien n’est « dirty ».

Tant que tu ne vois pas dans les logs Profilarr quelque chose comme `qualityProfiles: N item(s)` au lieu de `skipped`, la config instance n’est pas sauvegardée.

## Checklist Radarr (instance par instance)

- [ ] Base : Pull + **Compile**
- [ ] Arr → Radarr → Sync → Media : `French - Radarr` × 3 → **Save**
- [ ] Delay : cocher `FR-Delay-Radarr` (base id **3** = McFlyKid) → **Save**
- [ ] Quality profiles : cocher au moins un `FR-Films-*` → **Save** (plus de bandeau orange)
- [ ] Chaque carte : bouton **Sync** (ou trigger **On Pull** + nouveau Pull sur la base)

Répéter la même checklist pour **Sonarr** avec `French - Sonarr` et `FR-Delay-Sonarr`.

## Références

- [Installation Profilarr v2](https://v2.dictionarry.dev/profilarr-setup/installation)
- Logique UI : `Profilarr` → `src/routes/arr/[id]/sync/+page.svelte` (`qualityProfilesCanSave`)

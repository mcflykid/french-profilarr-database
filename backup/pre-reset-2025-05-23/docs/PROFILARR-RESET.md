# Reset Profilarr — corriger le 500 « database cache not available »

Le **500** signifie : Profilarr n’a **pas** de cache compilé en RAM (compile ratée ou base désactivée). Ce n’est pas un bug Radarr/Sonarr.

## Procédure complète (recommandée)

### 1. Mettre à jour Git

Dépôt : `https://github.com/mcflykid/french-profilarr-database`  
Version PCD **≥ 3.0.1** (`pcd.json`).

### 2. Dans Profilarr (UI)

1. **Databases** → **Unlink** la base française (supprime la copie interne cassée).
2. **Link repository** à nouveau → attendre **100 %** (import des `ops/`).
3. Vérifier que la base est **Enabled** (activée).
4. **Compile** → doit finir **sans erreur** (sinon lire le message : souvent `UNIQUE` sur tags).
5. Ouvrir **Media management** → preset `FR-Films-4K` : **plus de 500**.
6. **Sync** (custom formats, profils, media, delays).

### 3. Instances *arr

| Instance | Delay profile |
|----------|----------------|
| Radarr | `FR-Delay-Radarr` |
| Sonarr | `FR-Delay-Sonarr` |

Pas `fr-default`.

### 4. Bibliothèques

Profil qualité = nom du bundle media :

- Radarr : `FR-Films-4K`, `FR-Films-1080p`, …
- Sonarr séries : `FR-Series-4K`, …
- Sonarr animé : `FR-Anime-4K`, …

**Jamais** `FR-Media-Base` (modèle interne).

---

## Si Compile échoue encore

### Docker : repartir propre (appdata)

```bash
docker stop profilarr
# Sauvegarder puis vider la base PCD interne Profilarr (chemin selon ton compose) :
# rm -rf /chemin/vers/appdata/profilarr/data/databases/*
docker start profilarr
```

Puis **Link** → **Compile** → **Sync**.

### Vérifier les logs

```bash
docker logs profilarr 2>&1 | tail -100 | grep -iE "compile|UNIQUE|cache|Failed|disabled"
```

---

## Après redémarrage du conteneur

Le cache RAM est **vide**. Refaire **Compile** (même si Git est à jour), puis **Sync**.

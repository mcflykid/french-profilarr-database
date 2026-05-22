# Tweaks (couche locale Profilarr v2)

Dossier pour **petits ajustements** que tu ne veux pas pousser sur le dépôt principal.

## Usage

1. Créer un second dépôt PCD (ou branche) qui **dépend** de `french-profilarr-database`.
2. N’y mettre que des fichiers `ops/*.sql` qui **ajoutent** ou **surchargent** (selon workflow Profilarr).
3. Compiler / sync après le dépôt principal.

## Exemples fournis

| Fichier | Effet |
|---------|--------|
| `exemple-pas-de-remux.sql` | Rappel : politique anti-Remux déjà dans la base principale |

## Ce qu’on ne met pas ici

- **Renommage actif** (`rename = 1`) — politique du dépôt : `rename = 0`.
- Autoriser Remux sur un profil — contredit la politique **encodes uniquement**.

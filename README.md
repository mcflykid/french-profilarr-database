# french-profilarr-database

Une base pour **Profilarr** à importer dans **Radarr** et **Sonarr**. Elle est pensée pour la **scène française** sur les trackers privés francophones : objectif général = privilégier les releases **avec français** (VF, MULTI, VOSTFR, etc.), une **qualité cohérente** avec la résolution du profil, et des critères qui suivent les **usages usuels de la scène FR** plutôt qu’un copier-coller “international”.

La technique (audio, codec, HDR, etc.) repose largement sur le projet officiel **[Dictionarry-Hub/database](https://github.com/Dictionarry-Hub/database)**. Tout ce qui est spécifique au marché français est préfixé **`FR-`** (langue, teams, exclusions, réglages métier).

Ce projet n’est **pas** “un fork qu’on a à peine adapté” : la couche **FR** et l’articulation avec les profils ont été pensées **quasi depuis zéro**, donc **des bugs ou des cas limites** sont possibles. Si quelque chose cloche ou si tu veux proposer une amélioration, tu peux **ouvrir une issue** sur le dépôt.

---

## Comment choisir un profil ?

Tu choisis selon **ce que tu veux télécharger** (films ou séries) et **quelle définition tu cibles**.

### Films (`FR-Films-*`)

| Profil           | À l’usage |
|------------------|-----------|
| **720p**         | Petit écran, stockage léger |
| **1080p**        | Équilibre classique télé / PC |
| **4K**           | Films en ultra HD quand ils existent en scène FR |
| **Any**          | Plus souple ; utile comme “filet” si les profils stricts ne trouvent rien |

Les profils **720p**, **1080p** et **4K** sont **plus stricts** (par ex. exclusions de certains formats lourds ou peu adaptés). **Any** est **plus permissif** pour ne pas rester bloqué sans release.

### Séries (`FR-Series-*`)

Même logique que les films : **720p**, **1080p** ou **4K**, selon la définition que tu veux pour tes séries en priorité.

---

## En résumé

- **À quoi ça sert ?** Configurer automatiquement Radarr/Sonarr pour **prioriser le français** et une **pile de priorités alignée avec la scène FR**.
- **Par où commencer ?** Import dans Profilarr, puis choisis **un profil Films** et **un profil Séries** qui correspondent à ta résolution et à ton usage (strict vs fallback avec `Any` pour les films).

Pour aller plus loin (scores détaillés, maintenance, conventions `FR-`), l’historique du dépôt et les dossiers `regex_patterns/`, `custom_formats/`, `profiles/` restent la référence technique.

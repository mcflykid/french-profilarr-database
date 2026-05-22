# Audit streamers (référence trash-pcd)

Comparaison indicative avec [trash-pcd](https://github.com/Dictionarry-Hub/trash-pcd) — **pas d’import automatique**.

## Déjà couverts (`FR-Streamer-Premium`)

| Service | Tags typiques | Regex |
|---------|---------------|--------|
| Netflix | NF, Netflix | `FR-Regex-Streamers-Premium` |
| Prime Video | AMZN, AMAZON + WEB | idem |
| Disney+ | DSNP, Disney+ | idem |
| Apple TV+ | ATVP, ATV | idem |
| HBO Max / Max | HMAX, MAX + WEB | idem |
| Paramount+ | PMTP | idem |

## Standard (`FR-Streamer-Standard`)

| Service | Tags | Notes |
|---------|------|--------|
| Sky / NOW | NOW.WEB-DL | FR / UK |
| Crunchyroll | CR, Crunchyroll | Animé |
| iTunes / Apple | iT, IT + WEB | Achats |

## Volontairement exclus (peu de catalogue FR)

Hulu, Peacock, Roku, Tubi, etc. — présents sur trash-pcd US, absents ici.

## Pistes d’évolution (non implémentées)

| Service | Intérêt FR | Action suggérée |
|---------|------------|-----------------|
| Canal+ / MyCanal | Séries FR | Issue + exemples de titres réels avant regex |
| Salto / OCS (historique) | Archive | Idem |
| France.tv / ARTE | Public | Tags WEB rares dans noms de release — faible ROI |

Pour ajouter un streamer : ouvrir une issue avec **3 titres de release** indexeur, puis étendre `ops/02` + `ops/03` + scores `ops/06`.

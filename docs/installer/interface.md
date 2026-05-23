# Interface Profilarr

**En bref** : après le [guide](guide.md), l’onglet **Sync** envoie les profils vers Radarr. **Upgrades** relance une recherche si tu viens de changer les scores.

[← Index doc](../README.md)

---

| Page | Rôle |
|------|------|
| **Sync** | Pousse presets media, delay, profils qualité vers Radarr |
| **Drift** | Alerte si quelqu’un modifie Radarr à la main (optionnel) |
| **Upgrades** | Re-cherche de meilleures releases en bibliothèque — utile **après** un gros Sync de scores |
| **Delay profile** | `FR-Delay-Radarr` : torrent, délai 0 — voir [delays](tailles.md#delays) |

**Score `~22 000 / 60 000`** (ex. STIF 4K) : numérateur = somme CF ; dénominateur = **`upgrade_until_score`**. À **même langue**, **SUPPLY** (~25k) bat **STIF** (~22k) grâce à l’**équipe** (4,8k) et l’**audio** (DV/Atmos). Les **tailles** restent gérées par le preset media (`ops/07`, Mo/min). Exclusions **-999999** inchangées.

---

[← Index doc](../README.md) · [← README](../../README.md)

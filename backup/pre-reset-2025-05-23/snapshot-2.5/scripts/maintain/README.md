# Maintenance (optionnel)

À n’utiliser **que** si tu modifies la structure media ou les tests parser.

| Script | Génère |
|--------|--------|
| `generate_profile_media_ops.py` | `ops/09-profile-media-bundles.sql` |
| `generate_cf_tests_sql.py` | `ops/11-custom-format-tests.sql` |

Après regénération : `python3 scripts/validate.py` puis commit.

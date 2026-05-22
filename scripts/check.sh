#!/usr/bin/env bash
# Vérifications PCD v2 — à lancer avant commit / PR
set -euo pipefail
cd "$(dirname "$0")/.."
echo "=== verify_pcd_v2 ==="
python3 scripts/verify_pcd_v2.py
echo "=== validate_regex_ops ==="
python3 scripts/validate_regex_ops.py
echo "=== verify_expected_scores ==="
python3 scripts/verify_expected_scores.py
echo "=== verify_team_tests ==="
python3 scripts/verify_team_tests.py
echo "=== verify_profile_scores ==="
python3 scripts/verify_profile_scores.py
echo "=== OK ==="

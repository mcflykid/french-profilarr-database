#!/usr/bin/env bash
# Alias — même chose que validate.py
set -euo pipefail
cd "$(dirname "$0")/.."
exec python3 scripts/validate.py

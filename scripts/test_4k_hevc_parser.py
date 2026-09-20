#!/usr/bin/env python3
"""Régression 4K : une release H265 doit passer le profil FR-Films-4K."""

from __future__ import annotations

import json
import os
import re
import sys
import urllib.request
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
OPS = ROOT / "ops"
TITLE = "Exemple.2025.MULTI.VFF.2160p.WEB.H265-SUPPLY"


def post(url: str, body: dict) -> dict:
    request = urllib.request.Request(
        url,
        data=json.dumps(body).encode(),
        headers={"Content-Type": "application/json"},
        method="POST",
    )
    with urllib.request.urlopen(request, timeout=20) as response:
        return json.load(response)


def sql_pattern(name: str) -> str:
    text = (OPS / "02-regex.sql").read_text(encoding="utf-8")
    match = re.search(
        rf"regular_expressions .*?VALUES \('{re.escape(name)}', '((?:''|[^'])*)'",
        text,
    )
    if not match:
        raise ValueError(f"regex {name} introuvable")
    return match.group(1).replace("''", "'")


def main() -> int:
    conditions = (OPS / "04-custom-format-conditions.sql").read_text(encoding="utf-8")
    profile = (OPS / "06-quality-profiles.sql").read_text(encoding="utf-8")
    if "'h265', 'Exclure : résolution 2160p'" in conditions or "'x265', 'Exclure : résolution 2160p'" in conditions:
        print("ERROR: le codec HEVC est encore exclu en 2160p")
        return 1
    if not re.search(r"'FR-Films-4K', 'h265', 'all', 1000", profile):
        print("ERROR: score h265 4K attendu (+1000) absent")
        return 1
    # Ordre, membres et cutoff sont contrôlés sur la base compilée pour les dix
    # profils par verify_quality_profiles, sans regex traversant d'autres profils.
    if not re.search(r"'FR-Films-4K', 'FR-Team-QTZ-4KLight', 'all', 4000", profile):
        print("ERROR: bonus QTZ + 4KLight attendu (+4000) absent du profil Films 4K")
        return 1
    other_qtz_bonus = re.findall(
        r"'([^']+)', 'FR-Team-QTZ-4KLight', '[^']+', -?\d+", profile
    )
    if other_qtz_bonus != ["FR-Films-4K"]:
        print(f"ERROR: bonus QTZ + 4KLight hors Films 4K: {other_qtz_bonus}")
        return 1

    parser_url = os.environ.get("PARSER_URL")
    if not parser_url:
        print("OK: règles HEVC/QTZ; SKIP: parser réel (PARSER_URL absent)")
        return 0

    parsed = post(f"{parser_url.rstrip('/')}/parse", {"title": TITLE, "type": "movie"})
    if parsed.get("resolution") != 2160:
        print(f"ERROR: le parser n'a pas détecté 2160p: {parsed}")
        return 1

    pattern = sql_pattern("h265")
    matched = post(f"{parser_url.rstrip('/')}/match", {"text": TITLE, "patterns": [pattern]})
    if not matched.get("results", {}).get(pattern):
        print("ERROR: le parser ne détecte pas H265 pour la release 4K de régression")
        return 1

    print("OK: 2160p H265 détecté, bonus QTZ + 4KLight limité aux Films 4K")
    return 0


if __name__ == "__main__":
    sys.exit(main())

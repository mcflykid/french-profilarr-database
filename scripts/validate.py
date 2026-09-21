#!/usr/bin/env python3
"""
Validation unique du dépôt PCD (équivalent Compile Profilarr + sync Sonarr safe).

Usage : python3 scripts/validate.py
"""

from __future__ import annotations

import subprocess
import sys
import os
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
CHECKS = (
    ("Intégrité ops/ (doublons, FK, profils)", "verify_ops_integrity.py"),
    ("Compile PCD (schema 1.1.0 + ops)", "verify_pcd_compile.py"),
    ("Non-régression des garde-fous (injections en mémoire)", "test_audit_guards.py"),
    ("Descriptions regex/CF (pas de *, pas de syntaxe regex)", "validate_regex_ops.py"),
    ("Tous les cas CF ops/11 (parser .NET)", "test_all_custom_formats.py"),
    ("Comportement des dix profils (parser .NET)", "test_profile_behaviour.py"),
    ("Régression 4K HEVC (parser réel en CI)", "test_4k_hevc_parser.py"),
    ("Cohérence doc ↔ SQL (scores, compteurs)", "verify_doc_scores.py"),
    ("Liens et ancres de la documentation", "verify_docs.py"),
)


def run(name: str, script: str) -> int:
    parts = script.split()
    path = ROOT / "scripts" / parts[0]
    print(f"\n── {name} ──")
    r = subprocess.run([sys.executable, str(path), *parts[1:]], cwd=ROOT)
    return r.returncode


def main() -> int:
    print("Validation french-profilarr-database (PCD v2)")
    failed = []
    for label, script in CHECKS:
        if run(label, script) != 0:
            failed.append(script)
    print()
    if failed:
        print(f"ÉCHEC : {', '.join(failed)}")
        return 1
    if os.environ.get("PARSER_URL"):
        print("OK — contrôles statiques et parser réussis : Pull → Compile → Sync")
    else:
        print("OK PARTIEL — contrôles statiques seulement ; tests parser NON exécutés. Définir PARSER_URL avant publication.")
    return 0


if __name__ == "__main__":
    sys.exit(main())

#!/usr/bin/env python3
"""
Validation unique du dépôt PCD (équivalent Compile Profilarr + sync Sonarr safe).

Usage : python3 scripts/validate.py
"""

from __future__ import annotations

import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
CHECKS = (
    ("Intégrité ops/ (doublons, FK, profils)", "verify_ops_integrity.py"),
    ("Compile PCD (schema 1.1.0 + ops)", "verify_pcd_compile.py"),
    ("Descriptions regex/CF (pas de *, pas de syntaxe regex)", "validate_regex_ops.py"),
    ("Tests calibrage ops/11 (releases réelles)", "run_cf_regex_tests.py --calibrage-only"),
    ("Cohérence doc ↔ SQL (scores, compteurs)", "verify_doc_scores.py"),
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
    print("OK — base prête pour Profilarr : Pull → Compile → Sync")
    return 0


if __name__ == "__main__":
    sys.exit(main())

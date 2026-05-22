#!/usr/bin/env python3
"""Vérifie les liens et chemins cités dans README/docs (anti-hallucination)."""

from __future__ import annotations

import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def main() -> int:
    errors: list[str] = []
    md_files = list(ROOT.glob("**/*.md"))
    link_re = re.compile(r"\]\(([^)]+)\)")

    for md in md_files:
        if ".git" in md.parts:
            continue
        text = md.read_text(encoding="utf-8")
        for target in link_re.findall(text):
            if target.startswith(("http://", "https://", "#", "mailto:")):
                continue
            path = (md.parent / target).resolve()
            try:
                path.relative_to(ROOT.resolve())
            except ValueError:
                continue
            if not path.exists():
                errors.append(f"{md.relative_to(ROOT)} → {target} (absent)")

    required = [
        "pcd.json",
        "ops/01-tags.sql",
        "ops/12-quality-profile-tests.sql",
        "docs/PROFILARR-V2.md",
        "docs/PROFILARR-RESET.md",
        "docs/compose-profilarr-v2.yml",
        "scripts/validate.py",
        ".github/workflows/ci.yml",
    ]
    for rel in required:
        if not (ROOT / rel).is_file():
            errors.append(f"requis manquant: {rel}")

    print("=== Vérification anti-hallucination ===\n")
    if errors:
        for e in errors:
            print(f"ERROR: {e}")
        return 1
    print("OK: liens locaux et fichiers requis présents.")
    return 0


if __name__ == "__main__":
    sys.exit(main())

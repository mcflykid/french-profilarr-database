#!/usr/bin/env python3
"""Vérifie les liens Markdown locaux et les ancres de la documentation."""

from __future__ import annotations

import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
DOCS = [(ROOT / "README.md").resolve(), *(path.resolve() for path in sorted((ROOT / "docs").rglob("*.md")))]
LINK = re.compile(r"(?<!!)\[[^]]*\]\(([^)]+)\)")
HEADING = re.compile(r"^#{1,6}\s+(.+?)\s*$", re.MULTILINE)


def anchor(text: str) -> str:
    text = re.sub(r"[`*_~]", "", text).lower()
    text = re.sub(r"[^\w\s-]", "", text, flags=re.UNICODE)
    return re.sub(r"[\s-]+", "-", text).strip("-")


def compact_anchor(text: str) -> str:
    return re.sub(r"[\W_]", "", text, flags=re.UNICODE).lower()


def main() -> int:
    errors: list[str] = []
    anchors = {path: {anchor(h) for h in HEADING.findall(path.read_text(encoding="utf-8"))} for path in DOCS}

    for path in DOCS:
        for raw in LINK.findall(path.read_text(encoding="utf-8")):
            target = raw.split()[0]
            if target.startswith(("http://", "https://", "mailto:")):
                continue
            target_path, separator, fragment = target.partition("#")
            destination = path if not target_path else (path.parent / target_path).resolve()
            if not destination.is_file():
                errors.append(f"{path.relative_to(ROOT)}: cible absente: {target}")
                continue
            if destination not in anchors:
                if separator:
                    errors.append(f"{path.relative_to(ROOT)}: ancre vers un fichier non Markdown: {target}")
                continue
            known_anchors = anchors[destination]
            if separator and fragment and fragment not in known_anchors and compact_anchor(fragment) not in {compact_anchor(value) for value in known_anchors}:
                errors.append(f"{path.relative_to(ROOT)}: ancre absente: {target}")

    if errors:
        print("ERROR: documentation invalide")
        for error in errors:
            print(f"  {error}")
        return 1
    print(f"OK: {len(DOCS)} fichiers Markdown, liens et ancres locaux valides")
    return 0


if __name__ == "__main__":
    sys.exit(main())

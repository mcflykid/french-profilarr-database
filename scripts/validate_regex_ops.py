#!/usr/bin/env python3
"""Valide ops/02-regex.sql : motif valide ; description sans '*' (sync Sonarr concatène parfois)."""

from __future__ import annotations

import re
import sys
from pathlib import Path

OPS = Path(__file__).resolve().parents[1] / "ops" / "02-regex.sql"

PROSE_IN_PATTERN = (" Détecte", " Repère", " Le mot", " Champ ", " **")


def parse_sql_string(text: str, start: int) -> tuple[str, int]:
    if text[start] != "'":
        raise ValueError(f"expected quote at {start}")
    i = start + 1
    parts: list[str] = []
    while i < len(text):
        ch = text[i]
        if ch == "'":
            if i + 1 < len(text) and text[i + 1] == "'":
                parts.append("'")
                i += 2
                continue
            return "".join(parts), i + 1
        parts.append(ch)
        i += 1
    raise ValueError("unterminated SQL string")


def iter_regex_rows(text: str):
    marker = "INSERT INTO regular_expressions (name, pattern, description) VALUES ("
    pos = 0
    while True:
        idx = text.find(marker, pos)
        if idx < 0:
            return
        i = idx + len(marker)
        name, i = parse_sql_string(text, i)
        i += 1
        while i < len(text) and text[i].isspace():
            i += 1
        pattern, i = parse_sql_string(text, i)
        i += 1
        while i < len(text) and text[i].isspace():
            i += 1
        description, i = parse_sql_string(text, i)
        yield name, pattern, description
        pos = i


def main() -> int:
    text = OPS.read_text(encoding="utf-8")
    errors: list[str] = []
    count = 0
    for name, pattern, description in iter_regex_rows(text):
        count += 1
        for marker in PROSE_IN_PATTERN:
            if marker in pattern:
                errors.append(f"{name}: prose in pattern ({marker.strip()})")
                break
        if "*" in description:
            errors.append(f"{name}: '*' in description (breaks Sonarr if appended to pattern)")
        try:
            re.compile(pattern)
        except re.error as e:
            if any(x in str(e) for x in ("nothing to repeat", "bad escape", "unbalanced")):
                errors.append(f"{name}: pattern invalid: {e}")
        if "*" in description:
            combined = f"{pattern} {description}"
            try:
                re.compile(combined)
            except re.error as e:
                if "quantifier" in str(e).lower() or "nothing to repeat" in str(e):
                    errors.append(f"{name}: pattern+description: {e}")
    if errors:
        for e in errors:
            print(f"ERROR: {e}")
        return 1
    print(f"OK: {count} regex patterns checked")
    return 0


if __name__ == "__main__":
    sys.exit(main())

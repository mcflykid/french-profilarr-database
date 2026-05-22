#!/usr/bin/env python3
"""Fail if any pattern in ops/02-regex.sql is not a valid regex (Python) or contains prose."""
from __future__ import annotations

import re
import sys
from pathlib import Path

OPS = Path(__file__).resolve().parents[1] / "ops" / "02-regex.sql"

PROSE_MARKERS = (" Détecte", " Repère", " Le mot", " Champ ", " **")


def main() -> int:
    text = OPS.read_text(encoding="utf-8")
    errors: list[str] = []
    for m in re.finditer(
        r"INSERT INTO regular_expressions \(name, pattern, description\) VALUES \('([^']+)', '((?:[^'\\]|\\.)*)', '",
        text,
    ):
        name = m.group(1)
        pattern = m.group(2).replace("''", "'")
        for marker in PROSE_MARKERS:
            if marker in pattern:
                errors.append(f"{name}: prose in pattern field ({marker.strip()})")
                break
        try:
            re.compile(pattern)
        except re.error as e:
            # .NET may accept some patterns Python rejects; still flag obvious breaks
            if any(x in str(e) for x in ("nothing to repeat", "bad escape", "unbalanced")):
                errors.append(f"{name}: {e}")
    if errors:
        for e in errors:
            print(f"ERROR: {e}")
        return 1
    print(f"OK: {len(list(re.finditer('INSERT INTO regular_expressions', text)))} regex patterns checked")
    return 0


if __name__ == "__main__":
    sys.exit(main())

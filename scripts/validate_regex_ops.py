#!/usr/bin/env python3
"""Valide descriptions ops/02-regex.sql et ops/03-custom-formats.sql."""

from __future__ import annotations

import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
OPS02 = ROOT / "ops" / "02-regex.sql"
OPS03 = ROOT / "ops" / "03-custom-formats.sql"

PROSE_IN_PATTERN = (" Détecte", " Repère", " Le mot", " Champ ", " **")
FORBIDDEN_IN_DESC = "*"
FORBIDDEN_REGEX_IN_DESC = ("\\b", "\\d", "\\s", "(?")


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


def check_description(name: str, description: str, errors: list[str], prefix: str) -> None:
    if FORBIDDEN_IN_DESC in description:
        errors.append(f"{prefix}{name}: '*' in description (risque sync Sonarr)")
    if description.rstrip().endswith("…") or description.endswith("..."):
        errors.append(f"{prefix}{name}: description tronquée")
    for token in FORBIDDEN_REGEX_IN_DESC:
        if token in description:
            errors.append(f"{prefix}{name}: syntaxe regex {token!r} dans description")
    if len(description) > 320:
        errors.append(f"{prefix}{name}: description trop longue ({len(description)} car.)")


def iter_cf_rows(text: str):
    marker = "INSERT INTO custom_formats (name, description, include_in_rename) VALUES ("
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
        description, i = parse_sql_string(text, i)
        yield name, description
        pos = i


def main() -> int:
    errors: list[str] = []
    text02 = OPS02.read_text(encoding="utf-8")
    count = 0
    for name, pattern, description in iter_regex_rows(text02):
        count += 1
        check_description(name, description, errors, "regex ")
        for marker in PROSE_IN_PATTERN:
            if marker in pattern:
                errors.append(f"regex {name}: prose in pattern ({marker.strip()})")
                break
        try:
            re.compile(pattern)
        except re.error as e:
            if any(x in str(e) for x in ("nothing to repeat", "bad escape", "unbalanced")):
                errors.append(f"regex {name}: pattern invalid: {e}")
        if FORBIDDEN_IN_DESC in description:
            combined = f"{pattern} {description}"
            try:
                re.compile(combined)
            except re.error as e:
                if "quantifier" in str(e).lower() or "nothing to repeat" in str(e):
                    errors.append(f"regex {name}: pattern+description: {e}")

    text03 = OPS03.read_text(encoding="utf-8")
    cf_count = 0
    for name, description in iter_cf_rows(text03):
        cf_count += 1
        check_description(name, description, errors, "cf ")

    if errors:
        for e in errors:
            print(f"ERROR: {e}")
        return 1
    print(f"OK: {count} regex + {cf_count} CF descriptions checked")
    return 0


if __name__ == "__main__":
    sys.exit(main())

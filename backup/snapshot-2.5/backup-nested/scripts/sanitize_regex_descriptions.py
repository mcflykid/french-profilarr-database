#!/usr/bin/env python3
"""Nettoie les descriptions ops/02 pour le sync Sonarr/Radarr (pattern + description = regex .NET)."""

from __future__ import annotations

import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
OPS = ROOT / "ops" / "02-regex.sql"

HEADER = """-- French Profilarr Database — PCD v2 (Profilarr >= 2.0.0)

-- Regular expressions
-- Descriptions : texte brut uniquement (Profilarr concatène pattern + description vers les *arr).

"""


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


def clean_description(desc: str) -> str:
    while "**" in desc:
        desc = re.sub(r"\*\*([^*]+)\*\*", r"\1", desc)
    desc = re.sub(r"`([^`]+)`", r"\1", desc)
    desc = desc.replace("*", "")
    desc = " ".join(desc.split())
    if len(desc) > 240:
        desc = desc[:237] + "…"
    return desc


def sql_quote(value: str) -> str:
    return "'" + value.replace("'", "''") + "'"


def parse_rows(text: str) -> list[tuple[str, str, str]]:
    marker = "INSERT INTO regular_expressions (name, pattern, description) VALUES ("
    rows: list[tuple[str, str, str]] = []
    pos = 0
    while True:
        idx = text.find(marker, pos)
        if idx < 0:
            break
        i = idx + len(marker)
        name, i = parse_sql_string(text, i)
        if text[i] != ",":
            raise ValueError(f"comma expected after name at {i}")
        i += 1
        while i < len(text) and text[i].isspace():
            i += 1
        pattern, i = parse_sql_string(text, i)
        if text[i] != ",":
            raise ValueError(f"comma expected after pattern at {i}")
        i += 1
        while i < len(text) and text[i].isspace():
            i += 1
        description, i = parse_sql_string(text, i)
        rows.append((name, pattern, clean_description(description)))
        pos = i
    return rows


def emit(rows: list[tuple[str, str, str]]) -> str:
    lines = [HEADER.rstrip(), ""]
    for name, pattern, description in rows:
        lines.append(
            "INSERT INTO regular_expressions (name, pattern, description) VALUES ("
            f"{sql_quote(name)}, {sql_quote(pattern)}, {sql_quote(description)});"
        )
    lines.append("")
    return "\n".join(lines)


def main() -> int:
    text = OPS.read_text(encoding="utf-8")
    rows = parse_rows(text)
    OPS.write_text(emit(rows), encoding="utf-8")
    print(f"OK: sanitized {len(rows)} regex descriptions in {OPS.name}")
    return 0


if __name__ == "__main__":
    sys.exit(main())

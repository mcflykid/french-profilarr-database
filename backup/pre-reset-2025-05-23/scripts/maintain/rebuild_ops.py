#!/usr/bin/env python3
"""Reconstruit ops/ depuis backup/snapshot-2.5/ (réécriture propre fichier par fichier)."""

from __future__ import annotations

import re
import shutil
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SRC = ROOT / "backup" / "snapshot-2.5" / "ops"
DST = ROOT / "ops"

HEADERS: dict[str, str] = {
    "01-tags.sql": """-- French Profilarr Database — PCD v3
-- Fichier 01 : tags (filtres Profilarr, liaison CF et profils)

""",
    "02-regex.sql": """-- Fichier 02 : expressions régulières (pattern = motif ; description = aide UI uniquement)
-- Les descriptions ne doivent pas contenir de * (Profilarr peut les concaténer au pattern pour Sonarr).

""",
    "03-custom-formats.sql": """-- Fichier 03 : définitions des custom formats (Radarr + Sonarr)

""",
    "04-custom-format-conditions.sql": """-- Fichier 04 : conditions par CF (regex, source, résolution)

""",
    "05-custom-format-tags.sql": """-- Fichier 05 : tags par custom format

""",
    "06-quality-profiles.sql": """-- Fichier 06 : profils qualité FR-* + scores + tags profil (dont anime)

""",
    "07-media-management.sql": """-- Fichier 07 : FR-Media-Base, tailles, nommage (rename=0), FR-Delay-Radarr

""",
    "09-profile-media-bundles.sql": """-- Fichier 09 : un preset media par profil (même nom que le profil qualité) + FR-Delay-Sonarr

""",
    "10-profile-ui-tags.sql": """-- Fichier 10 : tags UI Radarr / Sonarr / Films / Series uniquement (pas anime → ops/06)

""",
    "11-custom-format-tests.sql": """-- Fichier 11 : tests parser custom formats (optionnel)

""",
    "12-quality-profile-tests.sql": """-- Fichier 12 : simulations profil qualité (optionnel)

""",
}


def clean_regex_descriptions(content: str) -> str:
    marker = "INSERT INTO regular_expressions (name, pattern, description) VALUES ("
    out: list[str] = []
    pos = 0
    while True:
        idx = content.find(marker, pos)
        if idx < 0:
            out.append(content[pos:])
            break
        out.append(content[pos:idx])
        i = idx + len(marker)

        def parse_string(start: int) -> tuple[str, int]:
            if content[start] != "'":
                raise ValueError("quote expected")
            j = start + 1
            parts: list[str] = []
            while j < len(content):
                if content[j] == "'":
                    if j + 1 < len(content) and content[j + 1] == "'":
                        parts.append("'")
                        j += 2
                        continue
                    return "".join(parts), j + 1
                parts.append(content[j])
                j += 1
            raise ValueError("unterminated string")

        name, i = parse_string(i)
        while i < len(content) and content[i].isspace():
            i += 1
        if content[i] != ",":
            raise ValueError("comma after name")
        i += 1
        while i < len(content) and content[i].isspace():
            i += 1
        pattern, i = parse_string(i)
        i += 1
        while i < len(content) and content[i].isspace():
            i += 1
        description, i = parse_string(i)

        while "**" in description:
            description = re.sub(r"\*\*([^*]+)\*\*", r"\1", description)
        description = re.sub(r"`([^`]+)`", r"\1", description)
        description = description.replace("*", "")
        description = " ".join(description.split())
        if len(description) > 220:
            description = description[:217] + "…"

        esc = lambda s: s.replace("'", "''")
        out.append(
            f"{marker}('{esc(name)}', '{esc(pattern)}', '{esc(description)}');\n"
        )
        pos = i
    return "".join(out)


def dedupe_cf_tests(content: str) -> str:
    """Une seule ligne par (custom_format, title, type)."""
    seen: set[tuple[str, str, str]] = set()
    lines: list[str] = []
    header_done = False
    for line in content.splitlines(keepends=True):
        if not header_done:
            lines.append(line)
            if line.strip().startswith("INSERT INTO custom_format_tests"):
                header_done = True
            continue
        m = re.match(
            r"\s*\('([^']*(?:''[^']*)*)',\s*'((?:''|[^'])*)',\s*'(movie|series)',\s*",
            line,
        )
        if not m:
            lines.append(line)
            continue
        cf = m.group(1).replace("''", "'")
        title = m.group(2).replace("''", "'")
        typ = m.group(3)
        key = (cf, title, typ)
        if key in seen:
            continue
        seen.add(key)
        lines.append(line)
    return "".join(lines)


def strip_sql_header(text: str) -> str:
    return re.sub(r"^--[^\n]*\n(?:--[^\n]*\n)*", "", text, count=1).lstrip("\n")


def rebuild_file(name: str, src_text: str) -> str:
    body = strip_sql_header(src_text)
    if name == "02-regex.sql":
        # Copie fidèle + en-tête v3 (déjà nettoyé dans snapshot)
        return HEADERS[name] + body
    if name == "11-custom-format-tests.sql":
        body = dedupe_cf_tests(body)
    return HEADERS.get(name, f"-- {name}\n\n") + body


def main() -> int:
    if not SRC.is_dir():
        print(f"ERROR: missing {SRC}")
        return 1
    if DST.exists():
        shutil.rmtree(DST)
    DST.mkdir(parents=True)
    for path in sorted(SRC.glob("*.sql")):
        text = path.read_text(encoding="utf-8")
        out = rebuild_file(path.name, text)
        (DST / path.name).write_text(out, encoding="utf-8")
        print(f"  wrote ops/{path.name}")
    print(f"OK: {len(list(DST.glob('*.sql')))} fichiers ops/")
    return 0


if __name__ == "__main__":
    sys.exit(main())

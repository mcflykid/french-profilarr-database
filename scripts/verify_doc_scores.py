#!/usr/bin/env python3
"""Cohérence doc ↔ SQL : les scores cités dans les tableaux docs/ doivent correspondre à ops/06.

Vérifie :
- langue.md (tableau des scores) — identiques sur tous les profils qui scorent le CF
- equipes.md (scores équipes) — identiques sur tous les profils qui scorent le CF
- image-son.md (scores audio 4K/1080p, HDR en 4K) — FR-Films-4K / FR-Films-1080p
- compteurs README.md et maintenir.md (CF, regex, profils, tests)

Ajouté en 2026-07 après dérive constatée (image-son.md : 7 scores faux vs SQL).
"""

from __future__ import annotations

import re
import sqlite3
import sys
import urllib.request
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SCHEMA_BASE = "https://raw.githubusercontent.com/Dictionarry-Hub/schema/1.1.0/ops"
SCHEMA_FILES = ("0.schema.sql", "1.languages.sql", "2.qualities.sql",
                "3.quality-group-member-position.sql")

# Tableaux image-son.md : libellé doc → nom CF en base
CF_ALIASES = {
    "Atmos (bundle)": "Atmos",
    "FR-Audio-71 (titre `7.1`)": "FR-Audio-71",
    "DV (Without Fallback)": "Dolby Vision (Without Fallback)",
    "HDR (générique)": "HDR",
}


def build_db() -> sqlite3.Connection:
    conn = sqlite3.connect(":memory:")
    for name in SCHEMA_FILES:
        with urllib.request.urlopen(f"{SCHEMA_BASE}/{name}", timeout=60) as resp:
            conn.executescript(resp.read().decode("utf-8"))
    for path in sorted((ROOT / "ops").glob("*.sql")):
        conn.executescript(path.read_text(encoding="utf-8"))
    return conn


def parse_num(cell: str) -> int | None:
    cell = cell.replace("**", "").replace("−", "-").replace(" ", " ").strip()
    m = re.fullmatch(r"-?[\d][\d ]*", cell)
    return int(cell.replace(" ", "")) if m else None


def clean_cell(cell: str) -> str:
    return cell.replace("**", "").strip()


def table_rows(text: str, start_marker: str) -> list[list[str]]:
    """Lignes du premier tableau markdown après start_marker."""
    idx = text.find(start_marker)
    if idx < 0:
        return []
    rows = []
    in_table = False
    for line in text[idx:].splitlines():
        if line.startswith("|"):
            in_table = True
            cells = [c.strip() for c in line.strip("|").split("|")]
            if not set(cells[0]) <= {"-", " ", ":"}:  # séparateur
                rows.append(cells)
        elif in_table:
            break
    return rows[1:]  # sans l'entête


def main() -> int:
    conn = build_db()
    errors: list[str] = []

    def sql_score(profile: str, cf: str) -> int | None:
        r = conn.execute(
            "SELECT score FROM quality_profile_custom_formats"
            " WHERE quality_profile_name=? AND custom_format_name=?",
            (profile, cf)).fetchone()
        return r[0] if r else None

    def check_uniform(doc: str, cf: str, expected: int) -> None:
        rows = conn.execute(
            "SELECT quality_profile_name, score FROM quality_profile_custom_formats"
            " WHERE custom_format_name=?", (cf,)).fetchall()
        if not rows:
            errors.append(f"{doc} : CF « {cf} » cité mais scoré sur aucun profil")
            return
        for prof, score in rows:
            if score != expected:
                errors.append(f"{doc} : {cf} annoncé {expected}, réel {score} sur {prof}")

    # --- langue.md : identique sur tous les profils ---
    langue = (ROOT / "docs/comprendre/langue.md").read_text(encoding="utf-8")
    for cells in table_rows(langue, "### Tableau des scores"):
        cf, num = clean_cell(cells[0]), parse_num(cells[1])
        if cf.startswith("FR-") and num is not None:
            check_uniform("langue.md", cf, num)

    # --- equipes.md : identique sur tous les profils ---
    equipes = (ROOT / "docs/comprendre/equipes.md").read_text(encoding="utf-8")
    for cells in table_rows(equipes, "### Scores équipes"):
        num = parse_num(cells[1])
        if num is None:
            continue
        for cf in re.findall(r"FR-(?:Team|Tier)-[A-Za-z0-9]+", cells[0]):
            check_uniform("equipes.md", cf, num)

    # --- image-son.md : audio (4K / 1080p) et HDR (4K) ---
    imageson = (ROOT / "docs/comprendre/image-son.md").read_text(encoding="utf-8")
    for cells in table_rows(imageson, "### Scores audio"):
        cf = CF_ALIASES.get(clean_cell(cells[0]), clean_cell(cells[0]))
        for col, prof in ((1, "FR-Films-4K"), (2, "FR-Films-1080p")):
            num = parse_num(cells[col])
            if num is None:
                continue
            real = sql_score(prof, cf)
            if real != num:
                errors.append(f"image-son.md (audio) : {cf} annoncé {num}, réel {real} sur {prof}")
    for cells in table_rows(imageson, "### HDR en 4K"):
        cf, num = CF_ALIASES.get(clean_cell(cells[0]), clean_cell(cells[0])), parse_num(cells[1])
        if num is None:
            continue
        real = sql_score("FR-Films-4K", cf)
        if real != num:
            errors.append(f"image-son.md (HDR 4K) : {cf} annoncé {num}, réel {real} sur FR-Films-4K")

    # --- compteurs ---
    n_cf = conn.execute("SELECT count(*) FROM custom_formats").fetchone()[0]
    n_rx = conn.execute("SELECT count(*) FROM regular_expressions").fetchone()[0]
    n_pr = conn.execute("SELECT count(*) FROM quality_profiles").fetchone()[0]
    n_tests = conn.execute("SELECT count(*) FROM custom_format_tests").fetchone()[0]

    readme = (ROOT / "README.md").read_text(encoding="utf-8")
    m = re.search(r"(\d+) formats perso · (\d+) regex · (\d+) profils · ~(\d+) tests", readme)
    if not m:
        errors.append("README.md : ligne « Contenu » introuvable ou format changé")
    else:
        for label, doc_v, real in (("CF", int(m[1]), n_cf), ("regex", int(m[2]), n_rx),
                                   ("profils", int(m[3]), n_pr)):
            if doc_v != real:
                errors.append(f"README.md : {label} annoncé {doc_v}, réel {real}")
        if abs(int(m[4]) - n_tests) > 15:
            errors.append(f"README.md : ~{m[4]} tests annoncés, réel {n_tests}")

    maintenir = (ROOT / "docs/contribuer/maintenir.md").read_text(encoding="utf-8")
    for pattern, real, label in (
        (r"# (\d+) motifs", n_rx, "regex (02)"),
        (r"# (\d+) CF", n_cf, "CF (03)"),
        (r"# (\d+) profils FR-", n_pr, "profils (06)"),
    ):
        m = re.search(pattern, maintenir)
        if m and int(m[1]) != real:
            errors.append(f"maintenir.md : {label} annoncé {m[1]}, réel {real}")

    if errors:
        print(f"ÉCHEC — {len(errors)} incohérence(s) doc ↔ SQL :")
        for e in errors:
            print(f"  ✗ {e}")
        return 1
    print(f"OK: doc ↔ SQL cohérents (langue, équipes, audio/HDR, compteurs — {n_cf} CF, {n_rx} regex, {n_pr} profils, {n_tests} tests)")
    return 0


if __name__ == "__main__":
    sys.exit(main())

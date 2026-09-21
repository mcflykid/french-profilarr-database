"""Outils d'audit : SQL compilé et regex .NET du parser Profilarr.

Le parser fournit les métadonnées/regex, pas le moteur de décision Arr complet.
Les conditions sont combinées par type suivant SpecificationMatchesGroup.
"""
from __future__ import annotations

import json
import re
import sqlite3
import urllib.request
from collections import defaultdict
from concurrent.futures import ThreadPoolExecutor

from verify_pcd_compile import OPS, SCHEMA_FILES, fetch_schema_sql


def database():
    conn = sqlite3.connect(":memory:")
    conn.row_factory = sqlite3.Row
    for name in SCHEMA_FILES:
        conn.executescript(fetch_schema_sql(name))
    for path in sorted(OPS.glob("*.sql")):
        conn.executescript(path.read_text(encoding="utf-8"))
    return conn


def normalize(value):
    return re.sub(r"[-_\s]", "", str(value).lower())


class ParserAudit:
    def __init__(self, conn, url):
        self.conn, self.url = conn, url.rstrip("/")
        self.parsed, self.matches = {}, {}
        self.patterns = [r[0] for r in conn.execute("SELECT pattern FROM regular_expressions")]
        with ThreadPoolExecutor(max_workers=8) as pool:
            valid = list(pool.map(lambda pattern: self.post("/validate/regex", {"pattern": pattern}), self.patterns))
        if not all(result.get("valid") is True for result in valid):
            raise ValueError("Expression régulière refusée par .NET")
        self.conditions = defaultdict(list)
        for row in conn.execute("SELECT * FROM custom_format_conditions"):
            self.conditions[row["custom_format_name"]].append(dict(row))
        self.data = defaultdict(lambda: defaultdict(list))
        for table in ("patterns", "sources", "resolutions", "release_types", "languages", "sizes", "years", "quality_modifiers", "indexer_flags"):
            query = f"SELECT * FROM condition_{table}"
            if table == "patterns":
                query = "SELECT cp.*, re.pattern FROM condition_patterns cp JOIN regular_expressions re ON re.name=cp.regular_expression_name"
            for row in conn.execute(query):
                self.data[(row["custom_format_name"], row["condition_name"])][table].append(dict(row))

    def post(self, endpoint, payload):
        request = urllib.request.Request(self.url + endpoint, data=json.dumps(payload).encode(), headers={"Content-Type": "application/json"})
        with urllib.request.urlopen(request, timeout=30) as response:
            return json.load(response)

    def prepare(self, releases):
        pending = list(set(releases) - self.parsed.keys())
        with ThreadPoolExecutor(max_workers=8) as pool:
            values = list(pool.map(lambda item: self.post("/parse", {"title": item[0], "type": item[1]}), pending))
        self.parsed.update(zip(pending, values))
        texts = set()
        for title, media_type in releases:
            parsed = self.parsed[(title, media_type)]
            texts.update(t for t in (title, parsed.get("releaseGroup"), parsed.get("edition")) if t)
        texts = list(texts - self.matches.keys())
        for offset in range(0, len(texts), 100):
            result = self.post("/match/batch", {"texts": texts[offset:offset+100], "patterns": self.patterns})
            self.matches.update(result["results"])

    def condition(self, cond, title, parsed, size=None, languages=None):
        kind = cond["type"]
        data = self.data[(cond["custom_format_name"], cond["name"])]
        if kind in ("release_title", "release_group", "edition"):
            field = {"release_title": title, "release_group": parsed.get("releaseGroup"), "edition": parsed.get("edition")}[kind]
            hit = any(self.matches.get(field, {}).get(p["pattern"], False) for p in data["patterns"])
        elif kind in ("source", "resolution", "quality_modifier", "release_type"):
            table, column, value = {
                "source": ("sources", "source", "television" if parsed["source"] == "TV" else parsed["source"]),
                "resolution": ("resolutions", "resolution", str(parsed["resolution"]) + "p"),
                "quality_modifier": ("quality_modifiers", "quality_modifier", parsed["modifier"]),
                "release_type": ("release_types", "release_type", (parsed.get("episode") or {}).get("releaseType", "Unknown")),
            }[kind]
            hit = any(normalize(row[column]) == normalize(value) for row in data[table])
        elif kind == "language":
            langs = parsed["languages"] if languages is None else languages
            hit = any((row["language_name"] not in langs) if row["except_language"] else (row["language_name"] in langs) for row in data["languages"])
        elif kind == "size":
            if size is None:
                raise ValueError(f"Taille requise pour {cond['custom_format_name']}")
            hit = any(size > (row["min_bytes"] or 0) and (row["max_bytes"] is None or size <= row["max_bytes"]) for row in data["sizes"])
        elif kind == "year":
            year = parsed.get("year", 0)
            hit = bool(year) and any((row["min_year"] is None or year >= row["min_year"]) and (row["max_year"] is None or year <= row["max_year"]) for row in data["years"])
        else:
            raise ValueError(f"Condition non prise en charge : {kind}")
        return not hit if cond["negate"] else bool(hit)

    def cf(self, name, title, media_type, size=None, languages=None):
        arr = "radarr" if media_type == "movie" else "sonarr"
        parsed = self.parsed[(title, media_type)]
        groups = defaultdict(list)
        for cond in self.conditions[name]:
            if cond["arr_type"] not in ("all", arr):
                continue
            if (arr, cond["type"]) in (("sonarr", "quality_modifier"), ("radarr", "release_type")):
                continue
            groups[cond["type"]].append((bool(cond["required"]), self.condition(cond, title, parsed, size, languages)))
        return bool(groups) and all(any(passed for _, passed in group) and all(passed for required, passed in group if required) for group in groups.values())

    def scores(self, profile, title, media_type, size=0):
        arr = "radarr" if media_type == "movie" else "sonarr"
        matched = {}
        for row in self.conn.execute("SELECT custom_format_name, score FROM quality_profile_custom_formats WHERE quality_profile_name=? AND arr_type IN ('all', ?)", (profile, arr)):
            if self.cf(row[0], title, media_type, size):
                matched[row[0]] = row[1]
        return sum(matched.values()), matched

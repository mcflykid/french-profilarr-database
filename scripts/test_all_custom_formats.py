#!/usr/bin/env python3
"""Exécute tous les cas ops/11 sur le parser .NET (aucun filtre de description)."""
import os
import sys

from parser_audit import database, ParserAudit


def extra_cases():
    """CF sans anciens fixtures et tailles absentes du schéma ops/11."""
    cases = []
    for cf, suffix in (("Opus", "OPUS"), ("VP9", "VP9"), ("VVC", "VVC"),
                       ("Xvid", "Xvid"), ("Upscaled", "UPSCALED")):
        cases.append((cf, f"Film.2024.1080p.WEB-DL.{suffix}-GROUP", "movie", None, True))
        cases.append((cf, "Film.2024.1080p.WEB-DL.H265-GROUP", "movie", None, False))
    cases.extend([
        ("Season Pack", "Serie.S01.MULTI.1080p.WEB-DL.H265-GROUP", "series", None, True),
        ("Season Pack", "Serie.S01E01.MULTI.1080p.WEB-DL.H265-GROUP", "series", None, False),
        ("Theatrical", "Film.2024.THEATRICAL.1080p.BluRay.x265-GROUP", "movie", None, True),
        ("Theatrical", "Film.2024.THEATRICAL.IMAX.1080p.BluRay.x265-GROUP", "movie", None, False),
        ("UHD Bluray", "Film.2024.1080p.UHD.BluRay.HDR.x265-GROUP", "movie", None, True),
        ("UHD Bluray", "Film.2024.2160p.UHD.BluRay.HDR.x265-GROUP", "movie", None, False),
        ("x264 (2160p)", "Film.2024.2160p.WEB-DL.x264-GROUP", "movie", None, True),
        ("x264 (2160p)", "Film.2024.1080p.WEB-DL.x264-GROUP", "movie", None, False),
    ])
    for cf, resolution, gib, media_type in (
        ("FR-Lourd-1080p", 1080, 5, "movie"),
        ("FR-Tres-Lourd-1080p", 1080, 8, "movie"),
        ("FR-Lourd-2160p", 2160, 20, "movie"),
        ("FR-Tres-Lourd-2160p", 2160, 28, "movie"),
        ("FR-Lourd-Episode-1080p", 1080, 3.5, "series"),
    ):
        prefix = "Film.2024" if media_type == "movie" else "Serie.S01E01"
        title = f"{prefix}.{resolution}p.WEB-DL.H265-GROUP"
        minimum = int(gib * 1024**3)
        for size, expected in ((minimum, False), (minimum+1, True), (1024**4, True), (1024**4+1, False)):
            cases.append((cf, title, media_type, size, expected))
        cases.append((cf, f"{prefix}.720p.WEB-DL.H265-GROUP", media_type, minimum+1, False))
    cases.append(("FR-Lourd-Episode-1080p", "Serie.S01.1080p.WEB-DL.H265-GROUP", "series", 4*1024**3, False))
    return cases


def main():
    url = os.environ.get("PARSER_URL")
    if not url:
        print("SKIP: tous les CF nécessitent PARSER_URL (obligatoire en CI)")
        return 1 if os.environ.get("CI") else 0
    conn = database()
    runner = ParserAudit(conn, url)
    tests = conn.execute("SELECT * FROM custom_format_tests ORDER BY id").fetchall()
    extras = extra_cases()
    runner.prepare([(row["title"], row["type"]) for row in tests] + [(title, media) for _, title, media, _, _ in extras])
    failures = []
    for row in tests:
        try:
            actual = runner.cf(row["custom_format_name"], row["title"], row["type"])
        except ValueError as exc:
            failures.append(f"id={row['id']} {exc}")
            continue
        if actual != bool(row["should_match"]):
            failures.append(f"id={row['id']} {row['custom_format_name']} attendu={row['should_match']} obtenu={int(actual)} | {row['title']}")
    original_failures = len(failures)
    for cf, title, media, size, expected in extras:
        if runner.cf(cf, title, media, size) != expected:
            failures.append(f"Complément {cf}, {title}, taille={size}, attendu={expected}")
    covered = {row["custom_format_name"] for row in tests if row["should_match"]}
    covered.update(cf for cf, _, _, _, expected in extras if expected)
    missing = {row[0] for row in conn.execute('SELECT name FROM custom_formats')} - covered
    if missing:
        failures.append(f"CF sans test positif : {sorted(missing)}")
    for failure in failures:
        print("FAIL:", failure)
    print(f"CF parser réel: {len(tests)-original_failures}/{len(tests)} OK, {original_failures} FAIL, 0 cas ignoré")
    print(f"Compléments CF/tailles : {len(extras)} cas, {len(failures)-original_failures} échec(s) ; couverture positive {len(covered)} CF")
    return int(bool(failures))


if __name__ == "__main__":
    sys.exit(main())

#!/usr/bin/env python3
"""Régressions de score des dix profils avec le parser .NET.

Vérifie les seuils CF, pas l'admissibilité complète d'un téléchargement : tailles
par durée, disponibilité et décisions d'import Arr restent des contrôles séparés.
L'ordre des qualités et les cutoffs sont audités par verify_quality_profiles.
"""
from __future__ import annotations

import os
import sys

from parser_audit import ParserAudit, database
from verify_quality_profiles import PROFILE_TARGETS


def main():
    url = os.environ.get("PARSER_URL")
    if not url:
        print("SKIP: comportements des profils nécessitent PARSER_URL (obligatoire en CI)")
        return 1 if os.environ.get("CI") else 0
    conn = database()
    runner = ParserAudit(conn, url)
    profiles = dict(conn.execute("SELECT name, minimum_custom_format_score FROM quality_profiles"))
    scenarios = []
    for profile, resolutions in PROFILE_TARGETS.items():
        media_type = "movie" if profile.startswith("FR-Films-") else "series"
        prefix = "Exemple.2025" if media_type == "movie" else "Exemple.S01E01"
        for resolution in resolutions:
            for codec in ("x265", "H265"):
                title = f"{prefix}.MULTI.VFF.{resolution}p.WEB-DL.EAC3.5.1.{codec}-GROUP"
                scenarios.append((profile, title, media_type, resolution, None))
        target = resolutions[0]
        for excluded, source in (
            ("Remux", "BluRay.Remux.x265"),
            ("Full Disc", "COMPLETE.BLURAY.ISO"),
            ("AV1", "WEB-DL.AV1"),
            ("Upscaled", "WEB-DL.Upscaled.x265"),
        ):
            title = f"{prefix}.MULTI.VFF.{target}p.{source}-GROUP"
            scenarios.append((profile, title, media_type, target, excluded))
        if profile.endswith("-4K"):
            scenarios.append((profile, f"{prefix}.MULTI.VFF.2160p.WEB-DL.x264-GROUP", media_type, 2160, "x264 (2160p)"))

    fixtures = conn.execute("SELECT * FROM test_releases ORDER BY id").fetchall()
    runner.prepare([(title, media_type) for _, title, media_type, _, _ in scenarios] +
                   [(row["title"], row["entity_type"]) for row in fixtures])
    checks, failures = 0, []

    def check(passed, label):
        nonlocal checks
        checks += 1
        if not passed:
            failures.append(label)

    check(set(profiles) == set(PROFILE_TARGETS), "Liste des dix profils inattendue")
    for profile, title, media_type, resolution, excluded in scenarios:
        score, matched = runner.scores(profile, title, media_type)
        if excluded:
            check(matched.get(excluded) == -999999 and score < profiles[profile],
                  f"{profile}: exclusion {excluded} inefficace, score={score}, CF={matched}")
        else:
            check(runner.parsed[(title, media_type)]["resolution"] == resolution,
                  f"{profile}: résolution mal analysée pour {title}")
            check(matched.get("FR-MULTI-VFF") == 7000 and score >= profiles[profile],
                  f"{profile}: HEVC FR {resolution}p sous le minimum, score={score}, CF={matched}")

    # Référence terrain : capture utilisateur du 19/09/2026, valeurs explicites
    # indépendantes du calcul afin de détecter une régression des conditions/CF.
    momie_scores = {
        "La.Momie.1999.MULTI.VFF.2160p.BluRay.4KLight.HDR10Plus.TrueHD.7.1.Atmos.x265-QTZ": 19100,
        "La.Momie.1999.MULTI.VFF.2160p.WEB.DV.HDR10PLUS.AC3.5.1.H265-Slay3R": 17020,
        "La.Momie.1999.MULTI.TRUEFRENCH.2160p.WEB.DV.HDR.DV.WEB-DL.H265-Slay3R": 16000,
        "La.Momie.1999.MULTI.VFF.2160p.WEB.DV.HDR10PLUS.AC3.5.1.H265-TyHD": 18720,
    }
    check(len(fixtures) == 12, "Les douze simulations ops/12 ont changé : revoir leur couverture")
    actual_momie = {}
    for row in fixtures:
        title, media_type = row["title"], row["entity_type"]
        entity = row["entity_tmdb_id"]
        profile = {564: "FR-Films-4K", 1411: "FR-Series-1080p", 85937: "FR-Anime-1080p", 41283: "FR-Films-4K"}.get(entity)
        if profile is None:
            check(False, f"Simulation non couverte : {title}")
            continue
        score, matched = runner.scores(profile, title, media_type, row["size_bytes"])
        if title in momie_scores:
            actual_momie[title] = score
            check(score == momie_scores[title], f"La Momie : attendu {momie_scores[title]}, obtenu {score}, CF={matched}")
        elif "Remux" in title or ".AV1-" in title:
            excluded = "Remux" if "Remux" in title else "AV1"
            check(matched.get(excluded) == -999999 and score < profiles[profile],
                  f"Simulation {excluded} non rejetée : {title}, score={score}, CF={matched}")
        else:
            check(score >= profiles[profile], f"Simulation FR sous le minimum : {title}, score={score}")
            if entity == 41283:
                multi = ".MULTI." in title
                # docs/comprendre/langue.md : VOQ est québécois (VFQ),
                # pas un double doublage France + Québec (VF2).
                check(("FR-MULTI-VFQ" in matched) == multi and ("FR-VFQ" in matched) != multi and not {"FR-MULTI-VF2", "FR-VF2", "FR-MULTI-VFF"}.intersection(matched),
                      f"Langue VOQ/MULTI.VOQ incohérente : {title}, CF={matched}")
    check(set(actual_momie) == set(momie_scores), "Une référence La Momie attendue est absente de ops/12")
    qtz = next((score for title, score in actual_momie.items() if title.endswith("-QTZ")), None)
    tyhd = next((score for title, score in actual_momie.items() if title.endswith("-TyHD")), None)
    check(qtz is not None and tyhd is not None and qtz > tyhd, "La Momie : QTZ 4KLight doit devancer TyHD")
    for failure in failures:
        print("FAIL:", failure)
    print(f"Profils/parser réel : {checks-len(failures)}/{checks} contrôles OK, {len(failures)} FAIL ; 10 profils, {len(scenarios)} scénarios synthétiques, {len(fixtures)} simulations terrain")
    return int(bool(failures))


if __name__ == "__main__":
    sys.exit(main())

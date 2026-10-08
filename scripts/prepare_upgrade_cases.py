#!/usr/bin/env python3
"""Prépare des paires synthétiques pour le moteur Arr natif copié localement.

PARSER_URL requis. L'export API ne contient pas de secrets. Le résultat JSON
est envoyé sur stdout, aucun fichier ou service Arr n'est modifié. Les CF
proviennent du parser .NET et des conditions du dépôt ; l'évaluation complète
des CF par Arr, les tailles/durées et l'import restent hors de cet essai.
"""
import argparse
import contextlib
import json
import os
import sys
from pathlib import Path

from parser_audit import ParserAudit, database


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("snapshot", type=Path)
    args = parser.parse_args()
    snapshot = json.loads(args.snapshot.read_text())
    url = os.environ.get("PARSER_URL")
    if not url:
        raise ValueError("PARSER_URL requis, aucun résultat partiel accepté")
    conn = database()
    try:
        with contextlib.redirect_stdout(sys.stderr):
            runner = ParserAudit(conn, url)
            cases = []
            pending = []
            for arr in ("radarr", "sonarr"):
                media = "movie" if arr == "radarr" else "series"
                prefix = "Exemple.2025" if media == "movie" else "Exemple.S01E01"
                for profile in snapshot[arr]["profiles"]:
                    name = profile["name"]
                    if not name.startswith("FR-"):
                        continue
                    qualities = {child["quality"]["name"] for group in profile["items"] if group["allowed"]
                                 for child in (group["items"] or [group]) if child["allowed"]}
                    levels = sorted(level for level in (480,720,1080,2160) if f"WEBDL-{level}p" in qualities)
                    def title(level, source="WEB-DL", lang="MULTI.VFF", extra="", team="GROUP"):
                        return f"{prefix}.{lang}.{extra}{level}p.{source}.EAC3.5.1.H265-{team}"
                    def add(label, current, candidate, expected):
                        pending.extend(((current,media),(candidate,media)))
                        cases.append({"arr":arr,"profile":name,"label":label,"current":current,"candidate":candidate,
                                      "expected":expected,"media":media,"minimum":profile["minFormatScore"]})
                    for lower in levels:
                        for upper in (level for level in levels if level > lower):
                            rich = title(lower,extra="DV.HDR10Plus.",team="QTZ")
                            plain = title(upper,source="BluRay",lang="ENGLISH")
                            add(f"{lower}p -> {upper}p, score candidat inférieur",rich,plain,"None")
                            add(f"{upper}p -> {lower}p, score candidat supérieur",plain,rich,"BetterQuality")
                    target = levels[-1]
                    base = title(target)
                    for revision in ("REPACK", "REPACK2", "REPACK3"):
                        add(f"original -> {revision}",base,title(target,extra=revision+"."),"MinCustomFormatScore")
                    add("MULTI ambigu -> MULTI.VFF (+1500)",title(target,lang="MULTI"),base,"None")
                    add("SpK79 -> QTZ sans 4KLight (+2100)",title(target,team="SpK79"),title(target,team="QTZ"),"None")
                    if name == "FR-Films-4K":
                        add("SpK79 -> QTZ avec 4KLight (+6100)",title(target,extra="4KLight.",team="SpK79"),title(target,extra="4KLight.",team="QTZ"),"None")
                        add("La Momie TyHD -> QTZ (+2380)",
                            "La.Momie.1999.MULTI.VFF.2160p.WEB.DV.HDR10PLUS.AC3.5.1.H265-TyHD",
                            "La.Momie.1999.MULTI.VFF.2160p.BluRay.4KLight.HDR10Plus.TrueHD.7.1.Atmos.x265-QTZ",
                            "None")
            runner.prepare(pending)
            source_names = {"WebDL":"WEBDL","Bluray":"Bluray","WebRip":"WEBRip","TV":"HDTV"}
            for case in cases:
                for side in ("current", "candidate"):
                    release = case[side]
                    parsed = runner.parsed[(release,case["media"])]
                    if parsed["modifier"] != "None":
                        raise ValueError(f"Qualité inattendue : {release}: {parsed}")
                    quality = f"{source_names[parsed['source']]}-{parsed['resolution']}p"
                    score, formats = runner.scores(case["profile"],release,case["media"])
                    if score < case["minimum"]:
                        raise ValueError(f"Paire sous le minimum : {case['label']} {score}")
                    case[side] = {"title":release,"quality":quality,"revision":parsed["revision"],"score":score,"formats":sorted(formats)}
                case.pop("media")
                case.pop("minimum")
        print(json.dumps(cases,ensure_ascii=False,indent=2))
    finally:
        conn.close()


if __name__ == "__main__":
    main()

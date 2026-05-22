#!/usr/bin/env python3
"""Uniformise annotations (conditions) et descriptions en français pour Profilarr v2."""

from __future__ import annotations

import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
OPS = ROOT / "ops"

# Annotations UI des conditions (ops/04) — libellés courts et homogènes
CONDITION_RENAMES: dict[str, str] = {
    "Not AAC": "Exclure : AAC",
    "Not DTS": "Exclure : DTS",
    "Not DTS-ES": "Exclure : DTS-ES",
    "Not DTS-HD": "Exclure : DTS-HD",
    "Not DTS-HD HRA ES": "Exclure : DTS-HD HRA/ES",
    "Not DTS-X": "Exclure : DTS-X",
    "Not Dolby Digital": "Exclure : Dolby Digital",
    "Not Dolby Digital +": "Exclure : Dolby Digital+",
    "Not FLAC": "Exclure : FLAC",
    "Not HDR10": "Exclure : HDR10",
    "Not HDR10+": "Exclure : HDR10+",
    "Not HLG": "Exclure : HLG",
    "Not IMAX": "Exclure : IMAX",
    "Not PCM": "Exclure : PCM",
    "Not PQ": "Exclure : PQ",
    "Not Remux": "Exclure : Remux",
    "Not SDR": "Exclure : SDR",
    "Not TrueHD": "Exclure : TrueHD",
    "Not x264": "Exclure : x264",
    "Not x265": "Exclure : x265",
    "Atmos (bundle)": "Atmos (regroupement)",
    "Streamers premium": "Streamers premium (regex FR)",
    "Streamers standard": "Streamers standard (regex FR)",
    "Blockers": "Liste noire scène FR",
    "Tier 01": "Palier 01 — longue traîne haute",
    "Tier 02": "Palier 02 — longue traîne basse",
    "Repack 2e itération ou REAL…PROPER": "Repack — 2e itération",
    "Repack 3e itération": "Repack — 3e itération",
    "Not WEB-DL": "Exclure : source WEB-DL",
    "Not WEBRip": "Exclure : source WEBRip",
    "Not DVD": "Exclure : source DVD",
    "Not HDTV": "Exclure : source HDTV",
    "Not 2160p": "Exclure : résolution 2160p",
}

TEAM_CF_DESCRIPTIONS: dict[str, str] = {
    "FR-Team-AMEN": (
        "Équipe AMEN — WEB 2160p compact (DV/HDR10+). "
        "Pourquoi : encodeur reconnu sur trackers francophones ; bonus de priorité (scores ops/06)."
    ),
    "FR-Team-BONBON": (
        "Équipe BONBON — 2160p 4KLight / WEBRip compact (~2,5–5 Go). "
        "Pourquoi : référence taille/qualité en UHD allégé ; fort bonus sur profils 4K."
    ),
    "FR-Team-BOUC": (
        "Équipe BOUC — WEB 2160p premium (DV/HDR10+, MULTI). "
        "Pourquoi : catalogue haut de gamme ; parfois EXCLU C411 — score modéré."
    ),
    "FR-Team-ENIGMA": (
        "Équipe ENIGMA — WEB 1080p/2160p (H264/H265, EAC3, HDR10 en 4K). "
        "Pourquoi : fort catalogue VFQ et blockbusters MULTI sur la scène FR."
    ),
    "FR-Team-FW": (
        "Équipe Forward (FW / FORWARD) — WEB 2160p catalogue (~9–20 Go). "
        "Pourquoi : volume et régularité ; bonus intermédiaire dans les profils FR-*."
    ),
    "FR-Team-HYPERION": (
        "Équipe HYPERION — quasi exclusivement Remux UHD/1080p (TrueHD Atmos, DV). "
        "Pourquoi : détectée pour transparence ; Remux à -999999 sur nos profils → jamais retenue."
    ),
    "FR-Team-OZEF": (
        "Équipe OZEF — Remux Blu-ray/UHD (TrueHD, DTS-HD MA). "
        "Pourquoi : idem HYPERION — Remux proscrit (-999999) sur profils stricts FR-*."
    ),
    "FR-Team-PopHD": (
        "Équipe PopHD — 1080p BluRay/HDLight x264 (~2–4 Go), MULTI VFF/VF2. "
        "Pourquoi : bon compromis 1080p compact ; bonus modéré sur profils 720p/1080p."
    ),
    "FR-Team-QTZ": (
        "Équipe QTZ — référence 4KLight Bluray (qualité / taille). "
        "Pourquoi : équipe de référence C411 en 4K allégé ; parmi les plus hauts scores team."
    ),
    "FR-Team-SUPPLY": (
        "Équipe SUPPLY — WEB 2160p premium (H265, DV/HDR10+, Atmos, ~10–25 Go). "
        "Pourquoi : qualité image et audio élevée ; bonus fort sur profils 4K."
    ),
    "FR-Team-Slay3R": (
        "Équipe Slay3R — WEB 2160p volume / exclus. "
        "Pourquoi : sorties fréquentes et complètes (tags DV/HDR) ; bonus élevé 4K."
    ),
    "FR-Team-TFA": (
        "Équipe TFA — WEB 2160p MULTI (VFF/VF2), HDR/DV (~10–18 Go). "
        "Pourquoi : catalogue séries/films régulier ; bonus intermédiaire-haut."
    ),
    "FR-Team-THESYNDiCATE": (
        "Équipe THESYNDiCATE — WEB 2160p H265/x265 (~8–22 Go). "
        "Pourquoi : bon rapport qualité/taille ; les sorties AV1 restent exclues (-999999)."
    ),
    "FR-Team-TOXIC": (
        "Équipe TOXIC — 1080p HDLight compact (BluRay/WEBRip, x264). "
        "Pourquoi : souvent cumul FR-HDLight ; utile 720p/1080p, peu pertinent en 4K."
    ),
    "FR-Team-TyHD": (
        "Équipe TyHD — WEB/WEBRip 2160p HEVC compact. "
        "Pourquoi : alternative légère au 4K premium ; bonus modéré sur profils 4K."
    ),
}

CF_DESCRIPTION_PATCHES: dict[str, str] = {
    "FR-Streamer-Premium": (
        "Détecte les sources WEB premium dans le titre : Netflix (NF), Prime Video (AMZN), "
        "Disney+ (DSNP), Apple TV+ (ATVP), HBO Max / Max, Paramount+ (PMTP). "
        "Pourquoi : master studio récent souvent meilleur que WEB générique ; bonus modéré sur profils FR-*."
    ),
    "FR-Streamer-Standard": (
        "Détecte les sources WEB secondaires visibles sur trackers FR : Sky NOW, Crunchyroll, iTunes/IT (WEB). "
        "Pourquoi : pertinent pour animé (CR) et achats Apple ; Hulu/Peacock exclus (peu de catalogue FR)."
    ),
    "FR-Repack": (
        "PROPER / REPACK / RERIP / REAL simple (sans 2/3). "
        "Pourquoi : correction qualité signalée dans le titre ; media en doNotPrefer — le score CF choisit la bonne release."
    ),
    "FR-Repack-2": (
        "PROPER2 / REPACK2 ou chaîne REAL…PROPER. "
        "Pourquoi : seconde passe de correction — bonus supérieur à FR-Repack."
    ),
    "FR-Repack-3": (
        "PROPER3 / REPACK3. "
        "Pourquoi : correction la plus aboutie annoncée — bonus maximal repack."
    ),
    "FR-Tier-01": (
        "Palier 01 — encodeurs longue traîne « haute » (BOUBA, NEOSTARK, …). "
        "Pourquoi : bonus sous les équipes FR-Team-* documentées ; voir regex FR-Tier-01."
    ),
    "FR-Tier-02": (
        "Palier 02 — encodeurs longue traîne « basse » (TLC, DFE, KPORAL, …). "
        "Pourquoi : petit bonus de reconnaissance ; toujours sous FR-Team-* et FR-Tier-01."
    ),
}

QUALITY_PROFILE_DESCRIPTIONS: dict[str, str] = {
    "FR-Films-4K": (
        "Profil Radarr 4K — trackers scène FR (C411, La Cale, Gemini). "
        "Objectif : UHD encode HEVC, langue FR, DV puis HDR10+/HDR10, audio premium. "
        "Priorité : MULTI VF2 > MULTI VFF > VF2 > VFF > VOSTFR ; équipes FR (team puis tier). "
        "Exclut : x264@2160p, Remux, Full Disc, AV1 (-999999), Upscaled."
    ),
    "FR-Films-1080p": (
        "Profil Radarr 1080p — trackers scène FR. "
        "Objectif : WEB/Bluray 1080p efficient (x265/h265), langue FR, audio premium, éditions IMAX/Theatrical. "
        "Priorité : hiérarchie langue FR + équipes + streamers. "
        "Exclut : Remux, Full Disc, AV1, Upscaled."
    ),
    "FR-Films-720p": (
        "Profil Radarr 720p — trackers scène FR. "
        "Objectif : encodes compacts, langue FR, audio modéré. "
        "Priorité : langue FR + équipes FR. "
        "Exclut : Remux, Full Disc, AV1, Upscaled."
    ),
    "FR-Films-Any": (
        "Profil Radarr « toute qualité » — secours sur trackers FR. "
        "Objectif : garder langue FR + équipes + audio/édition sans imposer de résolution (SD → Raw-HD). "
        "Exclut : FR-Blockers, AV1, Upscaled (Remux non bloqué — choix volontaire secours)."
    ),
    "FR-Series-4K": (
        "Profil Sonarr 4K — séries sur trackers FR. "
        "Objectif : UHD HEVC, langue FR, DV/HDR, audio premium, bonus Season Pack. "
        "Priorité : langue FR + équipes. "
        "Exclut : x264@UHD, Remux, Full Disc, AV1, Upscaled."
    ),
    "FR-Series-1080p": (
        "Profil Sonarr 1080p — séries sur trackers FR. "
        "Objectif : 1080p efficient, HDTV-1080p toléré (TV cap), Season Pack. "
        "Exclut : Remux, Full Disc, AV1, Upscaled."
    ),
    "FR-Series-720p": (
        "Profil Sonarr 720p — séries sur trackers FR. "
        "Objectif : 720p compact, HDTV-720p, Season Pack. "
        "Exclut : Remux, AV1, Upscaled."
    ),
    "FR-Anime-4K": (
        "Profil Sonarr 4K — animé (type Anime), trackers FR. "
        "Objectif : UHD HEVC, langue FR, DV/HDR, bonus 4KLight/Hybrid. "
        "Exclut : x264@2160p, Remux, Full Disc, AV1, Upscaled."
    ),
    "FR-Anime-1080p": (
        "Profil Sonarr 1080p — animé, trackers FR. "
        "Objectif : 1080p efficient, HDTV-1080p, Season Pack. "
        "Exclut : Remux, Full Disc, AV1, Upscaled."
    ),
    "FR-Anime-720p": (
        "Profil Sonarr 720p — animé, trackers FR. "
        "Objectif : 720p compact, HDTV-720p. "
        "Exclut : Remux, Full Disc, AV1, Upscaled."
    ),
}

REGEX_DESCRIPTION_PATCHES: dict[str, str] = {
    "3D": (
        "Marqueurs 3D stéréoscopique (bluray3d, SBS, half-OU) après l’année dans le titre. "
        "Pourquoi : peu d’installations 3D actives — souvent malus sur les profils."
    ),
    "HDR10": (
        "HDR10 strict (sans suffixe + / Plus réservé à HDR10+). "
        "Pourquoi : éviter de confondre HDR10 et HDR10+ dans le scoring."
    ),
}


def patch_condition_labels(text: str) -> str:
    for old, new in CONDITION_RENAMES.items():
        text = text.replace(f"'{old}'", f"'{new}'")
    return text


def patch_cf_description(line: str, name: str, desc: str) -> str:
    esc = desc.replace("'", "''")
    pattern = (
        rf"INSERT INTO custom_formats \(name, description, include_in_rename\) "
        rf"VALUES \('{re.escape(name)}', '[^']*(?:''[^']*)*', \d\);"
    )
    repl = (
        f"INSERT INTO custom_formats (name, description, include_in_rename) "
        f"VALUES ('{name}', '{esc}', 0);"
    )
    return re.sub(pattern, repl, line, count=1)


def patch_quality_profile(text: str) -> str:
    for name, desc in QUALITY_PROFILE_DESCRIPTIONS.items():
        esc = desc.replace("'", "''")
        pattern = (
            r"INSERT INTO quality_profiles \(name, description, upgrades_allowed, "
            r"minimum_custom_format_score, upgrade_until_score, upgrade_score_increment\) "
            rf"VALUES \('{re.escape(name)}', '[^']*(?:''[^']*)*',"
        )
        repl = (
            "INSERT INTO quality_profiles (name, description, upgrades_allowed, "
            "minimum_custom_format_score, upgrade_until_score, upgrade_score_increment) "
            f"VALUES ('{name}', '{esc}',"
        )
        text = re.sub(pattern, repl, text, count=1)
    return text


def patch_regex_descriptions(text: str) -> str:
    for name, desc in REGEX_DESCRIPTION_PATCHES.items():
        esc = desc.replace("'", "''")
        pattern = (
            rf"INSERT INTO regular_expressions \(name, pattern, description\) "
            rf"VALUES \('{re.escape(name)}', '[^']*(?:''[^']*)*', '[^']*(?:''[^']*)*'\);"
        )
        # Only replace description part — simpler line-by-line for 3D and HDR10
        if name == "3D":
            text = text.replace(
                "'Marqueurs bluray3d, sbs, half-ou / half-sbs apres annee (exclure 3D si non voulu).'",
                f"'{esc}'",
                1,
            )
        elif name == "HDR10":
            text = text.replace(
                "'HDR10 sans suffixe + / Plus (HDR10+ dans CF dedie).'",
                f"'{esc}'",
                1,
            )
    return text


def french_test_description(cf: str, desc: str, should_match: int) -> str:
    d = desc.strip()
    if not d or d.startswith("Test parser"):
        return d
    if any(
        x in d
        for x in (
            "Capture",
            "Momie",
            "cross-seed",
            "qBit",
            "slot",
            "POI",
            "M3GAN",
            "NCIS",
        )
    ):
        return d
    verdict = "doit correspondre" if should_match else "ne doit pas correspondre"
    if "via regex_patterns" in d or ".yml" in d:
        return f"Test parser — {cf} : {verdict} (release réelle)"
    if d.startswith("custom_formats/"):
        return f"Test parser — {cf} : {verdict}"
    return f"Test parser — {cf} : {verdict} — {d[:80]}"


LINE_TEST_RE = re.compile(
    r"\s*\('([^']+)', '((?:[^']|'')*)', '(movie|series)', ([01]), '([^']*(?:''[^']*)*)'\),?"
)


def patch_cf_tests(text: str) -> str:
    out: list[str] = []
    for line in text.splitlines(keepends=True):
        m = LINE_TEST_RE.match(line.rstrip("\n"))
        if not m:
            out.append(line)
            continue
        cf, title, typ, sm_s, desc = m.group(1), m.group(2), m.group(3), m.group(4), m.group(5)
        sm = int(sm_s)
        new_desc = french_test_description(cf, desc, sm).replace("'", "''")
        suffix = "," if line.rstrip().endswith(",") else ""
        out.append(
            f"    ('{cf}', '{title}', '{typ}', {sm}, '{new_desc}'){suffix}\n"
        )
    return "".join(out)


def rewrite_custom_formats() -> None:
    path = OPS / "03-custom-formats.sql"
    lines = path.read_text(encoding="utf-8").splitlines(keepends=True)
    out: list[str] = []
    for line in lines:
        if not line.startswith("INSERT INTO custom_formats"):
            out.append(line)
            continue
        m = re.match(
            r"INSERT INTO custom_formats \(name, description, include_in_rename\) "
            r"VALUES \('([^']+)', '((?:''|[^'])*)', (\d)\);",
            line.strip(),
        )
        if not m:
            out.append(line)
            continue
        name = m.group(1)
        if name in TEAM_CF_DESCRIPTIONS or name in CF_DESCRIPTION_PATCHES:
            desc = TEAM_CF_DESCRIPTIONS.get(name) or CF_DESCRIPTION_PATCHES[name]
            esc = desc.replace("'", "''")
            out.append(
                f"INSERT INTO custom_formats (name, description, include_in_rename) "
                f"VALUES ('{name}', '{esc}', {m.group(3)});\n"
            )
        else:
            out.append(line)
    path.write_text("".join(out), encoding="utf-8")


def main() -> int:
    ops04 = OPS / "04-custom-format-conditions.sql"
    ops04.write_text(patch_condition_labels(ops04.read_text(encoding="utf-8")), encoding="utf-8")
    print("  OK  ops/04 — annotations conditions (français)")

    rewrite_custom_formats()
    print("  OK  ops/03 — descriptions CF (équipes, streamers, repack)")

    ops06 = OPS / "06-quality-profiles.sql"
    ops06.write_text(patch_quality_profile(ops06.read_text(encoding="utf-8")), encoding="utf-8")
    print("  OK  ops/06 — descriptions profils qualité")

    ops02 = OPS / "02-regex.sql"
    ops02.write_text(patch_regex_descriptions(ops02.read_text(encoding="utf-8")), encoding="utf-8")
    print("  OK  ops/02 — descriptions regex (3D, HDR10)")

    ops11 = OPS / "11-custom-format-tests.sql"
    ops11.write_text(patch_cf_tests(ops11.read_text(encoding="utf-8")), encoding="utf-8")
    print("  OK  ops/11 — libellés tests parser")

    pcd = ROOT / "pcd.json"
    data = __import__("json").loads(pcd.read_text(encoding="utf-8"))
    data["description"] = (
        "Base PCD Profilarr v2 pour la scène française : profils FR-*, media, delays, "
        "custom formats et tests parser documentés en français."
    )
    pcd.write_text(__import__("json").dumps(data, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    print("  OK  pcd.json — description manifeste")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())

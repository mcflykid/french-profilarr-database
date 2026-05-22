#!/usr/bin/env python3
"""Normalise les descriptions ops/02 et ops/03 (UI Profilarr / Sonarr)."""

from __future__ import annotations

import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
OPS02 = ROOT / "ops" / "02-regex.sql"
OPS03 = ROOT / "ops" / "03-custom-formats.sql"

# --- regex : descriptions courtes, sans *, sans syntaxe regex, phrases complètes ---
REGEX_DESCRIPTIONS: dict[str, str] = {
    "3D": "Marqueurs 3D (bluray3d, SBS, half-OU) après l’année. Malus fréquent : peu d’installations 3D actives.",
    "AAC": "Codec AAC dans le titre (AAC, AAC5.1). Audio lossy courant en WEB ; distinct de Dolby et DTS.",
    "AV1": "Codec AV1 dans le titre. Exclu sur les profils FR (score -999999) pour compatibilité lecteurs.",
    "Basic HDR Formats": "Mention HDR ou DV / Dolby Vision, hors combinaisons HLG, PQ ou SDR trompeuses.",
    "DTS Basic": "DTS suivi d’un chiffre de canaux (ex. DTS.5, DTS 5). Variante télégraphique ancienne.",
    "DTS-ES": "DTS-ES (Extended Surround), extension matricielle 6.1 sur vieux DVD/Bluray.",
    "DTS-HD HRA ES": "Variantes DTS-ES et DTS high resolution (HR, HI) pour éviter les doublons audio.",
    "DTS-HD HRA": "DTS-HD High Resolution (HRA). Couche intermédiaire entre DTS core et DTS-HD MA.",
    "DTS-HD MA": "DTS-HD Master Audio (MA, XLL). Lossless fréquent sur Blu-ray, UHD et WEB premium.",
    "DTS-X": "DTS:X (audio objet). Distinct de DTS-HD MA et du DTS classique.",
    "DTS": "DTS core (hors HD ou X), souvent avec suffixe de canaux (DTS5, DTS.5).",
    "Dolby Digital +": "Dolby Digital Plus (DD+, E-AC-3, DDP, e.ac3). Distinct du Dolby Digital classique.",
    "Dolby Digital": "Dolby Digital classique (DD, AC3). Distinct du DD+ et des flux lossless.",
    "Dolby Vision (Without Fallback)": "Dolby Vision sans HDR10 lisible dans le titre. Malus compatibilité lecteurs anciens.",
    "Dolby Vision": "Alias DV, DoVi, Dolby Vision. Exclut DV accolé à HLG ou SDR seuls.",
    "FLAC": "Piste FLAC annoncée dans le titre. Distinct du PCM/LPCM.",
    "FR-Regex-4KLight": "Tag 4KLight (Bluray UHD allégé). Référence scène FR (QTZ, BONBON).",
    "FR-Regex-Atmos-Bundle": "Atmos, DDPA et variante TrueHD.A 5.1/7.1 (BTN) en un seul motif.",
    "FR-Regex-Blockers": "Groupes bannis, encodeurs GPU (NVENC, QSV, AMF) et incohérences REMUX+encodeur.",
    "FR-Regex-HDLight": "Tag HDLight (Bluray allégé). Courant en 1080p/720p sur trackers FR.",
    "FR-Regex-Hybrid": "Tag HYBRID (Bluray hybride multi-sources). Bonus UHD sur profils 4K.",
    "FR-Regex-MULTI": "Tag MULTI et variantes (MULTITRUEFRENCH, MULTI.FRENCH). Mot entier MULTI.",
    "FR-Regex-Streamers-Premium": "WEB premium : Netflix, Prime, Disney+, Apple TV+, HBO Max, Paramount+.",
    "FR-Regex-Streamers-Standard": "WEB secondaires : NOW/Sky, Crunchyroll, iTunes (tags WEB).",
    "FR-Regex-VF2": "Tags VF2, VFQ ou VOQ (Québec, seconde VF).",
    "FR-Regex-VFF": "Tags français hors VF2/VFQ/VOQ : VFF, TRUEFRENCH, MULTI.FRENCH, FRENCH, etc.",
    "FR-Regex-VOSTFR": "Sous-titres FR sur VO : VOSTFR, SUBFRENCH, FANSUB, FASTSUB.",
    "FR-Repack-2": "PROPER2, REPACK2 ou chaîne REAL puis PROPER (hors niveau 3).",
    "FR-Repack-3": "PROPER3 ou REPACK3 — correction la plus aboutie.",
    "FR-Repack": "PROPER, REPACK, RERIP ou REAL simple (hors niveaux 2 et 3).",
    "FR-Tier-01": "Encodeurs palier 01 (BOUBA, NEOSTARK, etc.). Sous les équipes FR-Team.",
    "FR-Tier-02": "Encodeurs palier 02 (TLC, DFE, KPORAL, DELIRIUS, etc.). Sous FR-Tier-01.",
    "Full Disc": "Image disque complète (ISO, BDMV, BR-DISK). Motif strict pour limiter les faux positifs.",
    "HDR": "Mention HDR générique. Affinée ensuite par HDR10, HDR10+ et exclusions SDR.",
    "HDR10+": "HDR10+ (HDR10 PLUS). Suffixe + ou Plus après HDR10.",
    "HDR10": "HDR10 strict, sans suffixe Plus réservé à HDR10+.",
    "HLG": "HLG (Hybrid Log-Gamma), HDR broadcast télé.",
    "IMAX Enhanced": "IMAX Enhanced sur WEB Disney+ ou Bravia Core, hors NON-IMAX.",
    "IMAX": "Mention IMAX (hors NON-IMAX). Distinct du CF IMAX Enhanced.",
    "Opus": "Codec Opus dans le titre. Ignore les fausses alertes type résolution 1080p après OPUS.",
    "PCM": "PCM ou LPCM non compressé dans le titre.",
    "PQ": "PQ ou PQ10 (Perceptual Quantizer), métadonnées HDR10.",
    "Remux": "Mot Remux dans le titre. Conteneur sans ré-encodage depuis Blu-ray/UHD.",
    "SDR": "Mention SDR explicite (gamme standard, pas HDR).",
    "Theatrical Edition": "Theatrical après l’année (4 chiffres) pour éviter les faux positifs.",
    "TrueHD": "Dolby TrueHD dans le titre. Atmos géré par FR-Regex-Atmos-Bundle.",
    "UHD Bluray": "Source UHD Blu-ray annoncée (variantes d’écriture UHD Bluray).",
    "Upscaled": "Upscale, regrade ou tags type AI enhanced / AIUS.",
    "VP9": "Codec VP9 dans le titre.",
    "VVC": "VVC / H.266 (codec rare, bonus expérimental si décodage HW).",
    "Xvid": "Ancien codec Xvid (MPEG-4 ASP), surtout SD legacy.",
    "h265": "Mention H.265 / H265 / HEVC (orthographes tolérantes).",
    "AMEN": "Groupe AMEN — WEB 2160p compact. Lié au CF FR-Team-AMEN.",
    "BONBON": "Groupe BONBON — 4KLight / WEBRip compact. Lié au CF FR-Team-BONBON.",
    "BOUC": "Groupe BOUC — WEB 2160p premium. Lié au CF FR-Team-BOUC.",
    "ENIGMA": "Groupe ENIGMA — WEB 1080p/2160p, MULTI VF. Lié au CF FR-Team-ENIGMA.",
    "FW": "Groupe Forward (FW / FORWARD). Lié au CF FR-Team-FW.",
    "HYPERION": "Groupe HYPERION — surtout Remux UHD. Lié au CF FR-Team-HYPERION.",
    "OZEF": "Groupe OZEF — Remux Blu-ray/UHD. Lié au CF FR-Team-OZEF.",
    "PopHD": "Groupe PopHD — 1080p HDLight x264. Lié au CF FR-Team-PopHD.",
    "QTZ": "Groupe QTZ — référence 4KLight. Lié au CF FR-Team-QTZ.",
    "SUPPLY": "Groupe SUPPLY — WEB 2160p premium. Lié au CF FR-Team-SUPPLY.",
    "Slay3R": "Groupe Slay3R — WEB 2160p volume. Lié au CF FR-Team-Slay3R.",
    "TFA": "Groupe TFA — WEB 2160p MULTI. Lié au CF FR-Team-TFA.",
    "THESYNDiCATE": "Groupe THESYNDiCATE — WEB 2160p HEVC. Lié au CF FR-Team-THESYNDiCATE.",
    "TOXIC": "Groupe TOXIC — 1080p HDLight. Lié au CF FR-Team-TOXIC.",
    "TyHD": "Groupe TyHD — WEB 2160p HEVC compact. Lié au CF FR-Team-TyHD.",
    "x264": "x264, h264, H.264 ou DVDRip, hors titres Remux.",
    "x265": "x265, HEVC ou DS4K dans le titre, hors Remux.",
}

CF_DESCRIPTIONS: dict[str, str] = {
    "3D": "Contenu stéréoscopique 3D. Malus : peu d’installations 3D actives.",
    "AAC": "Codec audio AAC dans le titre. Exclusions pour éviter le double-score audio.",
    "AV1": "Codec AV1. Score -999999 sur tous les profils FR (compatibilité matériel).",
    "Atmos": "Dolby Atmos (ATMOS, DDPA, TrueHD.A) via FR-Regex-Atmos-Bundle.",
    "DTS-ES": "DTS-ES dans le titre. Exclusions vers les autres codecs du pack audio.",
    "DTS-HD HRA": "DTS-HD High Resolution. Exclusions pour une seule famille DTS par release.",
    "DTS-HD MA": "DTS-HD Master Audio. Exclusions TrueHD, DTS:X, FLAC, etc.",
    "DTS-X": "DTS:X objet. Une seule famille DTS premium par titre.",
    "DTS": "DTS classique (non HD). Exclu si DTS-HD ou DTS:X présents.",
    "Dolby Digital +": "Dolby Digital Plus (E-AC-3). Exclusions audio mutualisées.",
    "Dolby Digital": "Dolby Digital (AC-3). Exclusions vers DTS/TrueHD du même pack.",
    "Dolby Vision (Without Fallback)": "DV sans HDR10 de secours lisible. Malus compatibilité lecteurs.",
    "Dolby Vision": "DV, DoVi, Dolby Vision. Exclut les combinaisons DV+HLG/SDR triviales.",
    "FLAC": "Piste FLAC. Exclusions si d’autres codecs audio dominent sur la même ligne.",
    "FR-4KLight": "Tag 4KLight (Bluray UHD allégé). Fort bonus sur profils 4K.",
    "FR-Blockers": "Groupes bannis, GPU encode (NVENC/QSV/AMF), incohérences REMUX+encodeur. Score très négatif.",
    "FR-HDLight": "Tag HDLight (Bluray allégé). Utile 720p/1080p ; rare en 2160p.",
    "FR-Hybrid": "Tag HYBRID (Bluray hybride UHD). Bonus modéré si annoncé.",
    "FR-MULTI-VF2": "MULTI + VF2, VFQ ou VOQ. Meilleur score langue du système.",
    "FR-MULTI-VFF": "MULTI + tag FR (VFF, TRUEFRENCH, etc.) hors VF2/VFQ/VOQ.",
    "FR-Repack-2": "PROPER2 / REPACK2 ou REAL puis PROPER. Bonus au-dessus de FR-Repack.",
    "FR-Repack-3": "PROPER3 / REPACK3. Bonus repack maximal.",
    "FR-Repack": "PROPER, REPACK, RERIP ou REAL simple. Media en doNotPrefer ; le score CF décide.",
    "FR-Streamer-Premium": "WEB premium (Netflix, Prime, Disney+, Apple TV+, HBO, Paramount+). Bonus modéré.",
    "FR-Streamer-Standard": "WEB secondaires (NOW, Crunchyroll, iTunes). Utile animé et achats Apple.",
    "FR-Team-AMEN": "Équipe AMEN — WEB 2160p compact DV/HDR10+. Bonus équipe.",
    "FR-Team-BONBON": "Équipe BONBON — 4KLight / WEBRip compact. Fort bonus 4K.",
    "FR-Team-BOUC": "Équipe BOUC — WEB 2160p premium DV/HDR10+. Bonus modéré.",
    "FR-Team-ENIGMA": "Équipe ENIGMA — WEB 1080p/2160p, catalogue VFQ/MULTI.",
    "FR-Team-FW": "Équipe Forward — WEB 2160p volume. Bonus intermédiaire.",
    "FR-Team-HYPERION": "Équipe HYPERION — surtout Remux. Remux à -999999 : jamais retenue.",
    "FR-Team-OZEF": "Équipe OZEF — Remux Blu-ray/UHD. Remux exclu (-999999).",
    "FR-Team-PopHD": "Équipe PopHD — 1080p HDLight x264, MULTI. Bonus 720p/1080p.",
    "FR-Team-QTZ": "Équipe QTZ — référence 4KLight. Parmi les plus hauts scores team.",
    "FR-Team-SUPPLY": "Équipe SUPPLY — WEB 2160p premium H265/DV/Atmos. Fort bonus 4K.",
    "FR-Team-Slay3R": "Équipe Slay3R — WEB 2160p volume et exclus. Bonus élevé 4K.",
    "FR-Team-TFA": "Équipe TFA — WEB 2160p MULTI. Bonus intermédiaire-haut.",
    "FR-Team-THESYNDiCATE": "Équipe THESYNDiCATE — WEB 2160p HEVC. AV1 toujours exclu.",
    "FR-Team-TOXIC": "Équipe TOXIC — 1080p HDLight. Souvent cumul FR-HDLight.",
    "FR-Team-TyHD": "Équipe TyHD — WEB 2160p HEVC compact. Bonus modéré 4K.",
    "FR-Tier-01": "Palier 01 encodeurs (BOUBA, NEOSTARK, …). Sous les équipes FR-Team.",
    "FR-Tier-02": "Palier 02 encodeurs (TLC, DFE, KPORAL, …). Sous FR-Tier-01.",
    "FR-VF2": "VF2, VFQ ou VOQ sans MULTI. Ajuste la politique VFQ/Québec via les scores.",
    "FR-VFF": "Tag FR mono-piste (VFF, TRUEFRENCH, …) sans MULTI.",
    "FR-VOSTFR": "VOSTFR, SUBFRENCH, FANSUB, FASTSUB. Repli si pas de doublage FR.",
    "Full Disc": "Image disque complète (ISO, BDMV). Exclut WEB/Remux/encodes sur la même ligne.",
    "HDR": "HDR générique hors HDR10/HDR10+ déjà gérés. Évite le double-score HDR.",
    "HDR10+": "HDR10+ / HDR10 PLUS. Exclusions SDR, PQ, HLG.",
    "HDR10": "HDR10 strict (sans Plus). Complète DV et HDR générique.",
    "IMAX Enhanced": "IMAX Enhanced (Disney+, Bravia Core). Distinct du CF IMAX seul.",
    "IMAX": "IMAX classique. Exclut IMAX Enhanced (regex dédiée).",
    "Opus": "Piste Opus. Ajuster le score si faux positif sur un release group.",
    "PCM": "PCM/LPCM. Exclusions audio mutualisées.",
    "Remux": "Release Remux. Score -999999 sur tous les profils FR — encodes seulement.",
    "Season Pack": "Season Pack Sonarr. Petit bonus saison complète.",
    "Theatrical": "Édition Theatrical. IMAX géré par les CF dédiés.",
    "TrueHD": "Dolby TrueHD. Exclusions DTS/FLAC du pack Dictionarry.",
    "UHD Bluray": "Downscale 1080p depuis source UHD + HDR. Tout groupe peut déclencher le bonus.",
    "Upscaled": "Upscale, regrade ou AIUS. Blocage -999999 sur tous les profils FR.",
    "VP9": "VP9 dans le titre. Malus léger : privilégier HEVC si disponible.",
    "VVC": "VVC / H.266 rare. Bonus léger ou neutre selon décodage HW.",
    "Xvid": "Xvid legacy SD. Malus fort sur profils HD/4K.",
    "h265": "Mentions h265 / HEVC (orthographes alternatives à x265).",
    "x264 (2160p)": "x264 annoncé avec 2160p (faux 4K). Bloqué ou très mal noté en UHD.",
    "x265": "Encodeur x265 dans le titre. Aligné avec h265/HEVC.",
}


def sql_quote(s: str) -> str:
    return s.replace("'", "''")


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


def rewrite_regex_file() -> None:
    text = OPS02.read_text(encoding="utf-8")
    marker = "INSERT INTO regular_expressions (name, pattern, description) VALUES ("
    out: list[str] = []
    pos = 0
    header_end = text.find(marker)
    out.append(text[:header_end].rstrip() + "\n\n")
    while True:
        idx = text.find(marker, pos)
        if idx < 0:
            break
        i = idx + len(marker)
        name, i = parse_sql_string(text, i)
        i += 1
        while i < len(text) and text[i].isspace():
            i += 1
        pattern, i = parse_sql_string(text, i)
        i += 1
        while i < len(text) and text[i].isspace():
            i += 1
        _old_desc, i = parse_sql_string(text, i)
        desc = REGEX_DESCRIPTIONS.get(name)
        if desc is None:
            raise KeyError(f"missing REGEX_DESCRIPTIONS[{name!r}]")
        out.append(
            f"INSERT INTO regular_expressions (name, pattern, description) VALUES "
            f"('{sql_quote(name)}', '{sql_quote(pattern)}', '{sql_quote(desc)}');\n"
        )
        pos = i
    OPS02.write_text("".join(out), encoding="utf-8")


def rewrite_cf_file() -> None:
    text = OPS03.read_text(encoding="utf-8")
    header = text.split("INSERT INTO custom_formats")[0].rstrip() + "\n\n"
    marker = "INSERT INTO custom_formats (name, description, include_in_rename) VALUES ("
    out = [header]
    pos = 0
    while True:
        idx = text.find(marker, pos)
        if idx < 0:
            break
        i = idx + len(marker)
        name, i = parse_sql_string(text, i)
        i += 1
        while i < len(text) and text[i].isspace():
            i += 1
        _old_desc, i = parse_sql_string(text, i)
        while i < len(text) and text[i].isspace():
            i += 1
        if not text.startswith(", 0)", i):
            raise ValueError(f"expected ', 0)' after description for {name}: {text[i:i+8]!r}")
        i += len(", 0)")
        desc = CF_DESCRIPTIONS.get(name)
        if desc is None:
            raise KeyError(f"missing CF_DESCRIPTIONS[{name!r}]")
        out.append(
            f"INSERT INTO custom_formats (name, description, include_in_rename) VALUES "
            f"('{sql_quote(name)}', '{sql_quote(desc)}', 0);\n"
        )
        if text[i : i + 1] == ";":
            i += 1
        pos = i
    OPS03.write_text("".join(out), encoding="utf-8")


def main() -> int:
    rewrite_regex_file()
    rewrite_cf_file()
    print("OK: descriptions normalisées dans ops/02 et ops/03")
    return 0


if __name__ == "__main__":
    sys.exit(main())

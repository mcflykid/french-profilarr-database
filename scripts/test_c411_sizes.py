#!/usr/bin/env python3
"""Calibrage taille/durée sourcé, distinct du moteur de décision Radarr."""
import json
import math
from pathlib import Path

from parser_audit import database

FIXTURES = Path(__file__).resolve().parents[1] / 'tests' / 'fixtures'
QUALITIES = {'Bluray-2160p', 'WEBDL-2160p', 'WEBRip-2160p', 'HDTV-2160p'}


def rate_range(size_go, seconds):
    """Enveloppe Mio/min : unité inconnue, affichage arrondi, durée +/- 1 min."""
    if not isinstance(size_go, (int, float)) or not math.isfinite(size_go) or size_go <= 0:
        raise ValueError('Taille invalide')
    low, high = seconds
    if not all(isinstance(v, (int, float)) and math.isfinite(v) for v in seconds) or not 60 < low <= high:
        raise ValueError('Durée invalide')
    margin = 0.5 if float(size_go).is_integer() else 0.05
    return ((size_go - margin) * 10**9 / 1024**2 / ((high + 60) / 60),
            (size_go + margin) * 1024 / ((low - 60) / 60))


def rejected(ranges, minimum, maximum):
    return {key for key, (low, high) in ranges.items() if low < minimum or high > maximum}


def main():
    releases = {}
    for name in ('c411-2026-09-23.json', 'c411-spk79-2026-09-23.json'):
        for row in json.loads((FIXTURES / name).read_text())['releases']:
            if row['id'] in releases:
                raise ValueError('Identifiant release dupliqué')
            releases[row['id']] = row
    films = json.loads((FIXTURES / 'c411-runtimes-2026-09-23.json').read_text())['films']
    if len(films) != 9:
        raise ValueError('Neuf films de référence attendus')
    ranges = {}
    for film in films:
        if not film['edition'] or not film['sources'] or not all(url.startswith('https://') for url in film['sources']):
            raise ValueError('Source ou édition absente')
        for key in film['release_ids']:
            if key in ranges:
                raise ValueError('Durée attribuée deux fois')
            ranges[key] = rate_range(releases[key]['displayed_size_go'], film['runtime_seconds'])
    if len(ranges) != 12:
        raise ValueError('Douze releases de référence attendues')
    conn = database()
    definitions = {row[0]: (row[1], row[2]) for row in conn.execute(
        'SELECT quality_name, min_size, max_size FROM radarr_quality_definitions '
        "WHERE name='FR-Media-Radarr' AND quality_name LIKE '%2160p'"
    ) if row[0] in QUALITIES}
    if set(definitions) != QUALITIES:
        raise ValueError('Définition 2160p manquante')
    failures = []
    for quality, (minimum, maximum) in definitions.items():
        for key in sorted(rejected(ranges, minimum, maximum)):
            failures.append(f'{quality}/{key}: {ranges[key]} hors {minimum}/{maximum}')
    # Le garde-fou doit détecter une récidive de plancher trop haut/plafond trop bas.
    if 'leviticus' not in rejected(ranges, 34.5, 250):
        failures.append('Plancher 34.5 non détecté')
    if 'supergirl_web' not in rejected(ranges, 17, 150):
        failures.append('Plafond 150 non détecté')
    for key, (low, high) in ranges.items():
        print(f'  {key}: {low:.2f}–{high:.2f} Mio/min')
    for failure in failures:
        print('FAIL:', failure)
    print(f'Tailles C411 : {len(ranges)} releases / {len(films)} films sourcés, '
          f'{len(definitions) * len(ranges)} comparaisons de bornes + 2 mutations, {len(failures)} FAIL')
    print('Hors sous-échantillon de durées : ' + ', '.join(sorted(releases.keys() - ranges.keys())))
    print('Références et marges de calibrage uniquement ; ni MediaInfo ni validation d’import Radarr.')
    conn.close()
    return int(bool(failures))


if __name__ == '__main__':
    raise SystemExit(main())

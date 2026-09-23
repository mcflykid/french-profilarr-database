#!/usr/bin/env python3
"""Calibrage des deux captures C411 du 23/09/2026, sans inventer de MediaInfo.

Vérifie les CF et les scores, pas l'admissibilité taille/durée ni l'import Arr.
Les tailles restent des observations arrondies ; deux conversions sont sondées.
"""
import json
import os
from pathlib import Path

from parser_audit import ParserAudit, database
from verify_quality_profiles import PROFILE_TARGETS

ROOT = Path(__file__).resolve().parents[1]


def main():
    url = os.environ.get('PARSER_URL')
    if not url:
        print('SKIP: échantillons C411 nécessitent PARSER_URL (obligatoire en CI)')
        return 1 if os.environ.get('CI') else 0
    rows = []
    for name, count in (('c411-2026-09-23.json', 14), ('c411-spk79-2026-09-23.json', 12)):
        data = json.loads((ROOT / 'tests' / 'fixtures' / name).read_text(encoding='utf-8'))
        if len(data['releases']) != count:
            raise ValueError(f'{name}: échantillon incomplet')
        rows.extend(data['releases'])
    if len({r['id'] for r in rows}) != len(rows):
        raise ValueError('Identifiants de référence dupliqués')
    conn = database()
    audit = ParserAudit(conn, url)
    pairs = [(r['title'], 'movie') for r in rows]
    # Les clones QTZ sont des comparaisons synthétiques, pas des releases observées.
    spk = [r for r in rows if r['title'].endswith('-SpK79')]
    clones = {r['id']: r['title'].rsplit('-', 1)[0] + '-QTZ' for r in spk}
    plain = 'Film.2025.MULTI.VFF.2160p.WEB-DL.EAC3.5.1.x265-SpK79'
    pairs += [(title, 'movie') for title in clones.values()] + [(plain, 'movie')]
    audit.prepare(pairs)
    checks, failures = 0, []

    def check(value, label):
        nonlocal checks
        checks += 1
        if not value:
            failures.append(label)

    vf2 = {'phoenician_truehd', 'phoenician_eac3', 'fall_truehd', 'fall_eac3', 'disclosure_day',
           'homme_colere', 'district_9', 'hokum', 'marty_supreme', 'obsession', 'scary_movie',
           'disclosure_spk', 'supergirl_web', 'supergirl_rip', 'projet_chance'}
    vfq = {'normal', 'pressure', 'leviticus'}
    mono = {'bagarre', 'vie_privee'}
    lights = {r['id'] for r in rows[:14]} | {'marty_supreme', 'projet_chance'}
    results = {}
    for row in rows:
        key, title = row['id'], row['title']
        size = row['displayed_size_go']
        check(isinstance(size, (int, float)) and size > 0, key + ': taille affichée invalide')
        score, matched = audit.scores('FR-Films-4K', title, 'movie', int(size * 1024**3))
        results[key] = score
        decimal = audit.scores('FR-Films-4K', title, 'movie', int(size * 10**9))
        check((score, matched) == decimal, key + ': arrondi/unité de taille influe sur le score')
        check(audit.parsed[(title, 'movie')]['resolution'] == 2160, key + ': résolution')
        lang = 'FR-MULTI-VF2' if key in vf2 else 'FR-MULTI-VFQ' if key in vfq else 'FR-VFF' if key in mono else 'FR-MULTI-VFF'
        langs = {cf for cf in matched if cf.startswith(('FR-MULTI-', 'FR-VF', 'FR-VOST'))}
        check(langs == {lang}, key + ': langue ou cumul ' + str(langs))
        check(matched.get('Dolby Vision') == 3500, key + ': DV absent')
        hdr = 'HDR' if key in {'pressure', 'vie_privee'} else 'HDR10+'
        check({cf for cf in matched if cf in {'HDR', 'HDR10', 'HDR10+'}} == {hdr}, key + ': HDR incorrect/cumulé')
        check(('FR-4KLight' in matched) == (key in lights), key + ': 4KLight incorrect')
        audio = 'TrueHD' if key in {'phoenician_truehd', 'fall_truehd'} else 'DTS-HD MA' if key == 'barbare_dts' else 'Dolby Digital' if key == 'pressure' else 'Dolby Digital +'
        check({cf for cf in matched if cf in {'TrueHD', 'DTS-HD MA', 'Dolby Digital', 'Dolby Digital +'}} == {audio}, key + ': famille audio')
        check(('Atmos' in matched) == (key in {'fall_truehd', 'normal', 'marty_supreme', 'scary_movie'}), key + ': Atmos')
        check(('FR-Audio-71' in matched) == (key in {'phoenician_truehd', 'fall_truehd', 'captain_america', 'homme_colere'}), key + ': 7.1')
        check(matched.get('FR-Team-SpK79', 0) == (5400 if key in clones else 0), key + ': bonus équipe')
        check(score >= 500 and all(v > -999999 for v in matched.values()), key + ': seuil/exclusion')

    for good, heavy, delta in (('phoenician_eac3', 'phoenician_truehd', 2800), ('fall_eac3', 'fall_truehd', 4300), ('barbare_eac3', 'barbare_dts', 1300)):
        check(results[good] - results[heavy] == delta, good + ': préférence audio')
    check(results['aliens'] == 19400, 'Aliens : langue séparée par HYBRID')
    for profile in PROFILE_TARGETS:
        # Les CF sont communs aux deux Arr ; on compare ici leur pondération,
        # sans déclarer ces films admissibles dans un profil série ou 720p.
        for row in spk:
            score = audit.scores(profile, row['title'], 'movie')[0]
            qtz = audit.scores(profile, clones[row['id']], 'movie')[0]
            delta = 4100 if profile == 'FR-Films-4K' and row['id'] in lights else 100
            check(qtz - score == delta, profile + '/' + row['id'] + ': QTZ doit devancer SpK79 à autres tags identiques')
    _, matched = audit.scores('FR-Films-4K', plain, 'movie')
    check(not {'FR-4KLight', 'Dolby Vision', 'HDR10+'}.intersection(matched), 'Aucun bonus de tag absent')
    for failure in failures:
        print('FAIL:', failure)
    print(f'C411 : {checks-len(failures)}/{checks} contrôles OK, {len(rows)} titres observés, {len(failures)} FAIL')
    conn.close()
    return int(bool(failures))


if __name__ == '__main__':
    raise SystemExit(main())

#!/usr/bin/env python3
"""Exclusions d'équipes demandées le 23/09/2026, vérifiées avec le parser .NET.

Tous les titres sont synthétiques. Vérifie le rejet par score CF des dix
profils, pas le moteur complet de sélection ou d'import de Radarr/Sonarr.
"""
import os

from parser_audit import ParserAudit, database
from verify_quality_profiles import PROFILE_TARGETS

BLOCKED_TEAMS = ('WebVision', 'AgroaQc', 'kORE', 'R3Z', 'Arkas', 'FYR3N')


def main():
    url = os.environ.get('PARSER_URL')
    if not url:
        print('SKIP: exclusions équipes nécessitent PARSER_URL (obligatoire en CI)')
        return 1 if os.environ.get('CI') else 0
    conn = database()
    audit = ParserAudit(conn, url)
    minimums = dict(conn.execute('SELECT name, minimum_custom_format_score FROM quality_profiles'))
    cases = []
    for profile, resolutions in PROFILE_TARGETS.items():
        media_type = 'movie' if profile.startswith('FR-Films-') else 'series'
        name = 'Film.2025' if media_type == 'movie' else 'Serie.S01E01'
        resolution = resolutions[0]
        light = '4KLight' if resolution == 2160 else 'HDLight'
        # Tags favorables : le blocage doit résister aux bonus langue/image/audio.
        base = f'{name}.MULTI.VF2.{resolution}p.BluRay.{light}.DV.HDR10Plus.EAC3.5.1.REPACK3.x265-'
        for team in BLOCKED_TEAMS:
            for suffix in (team, team.lower() + '.mkv', team.upper() + '.MP4'):
                cases.append((profile, base + suffix, media_type, True))
            for title in (base + 'X' + team, base + team + '2', team + '.' + base + 'QTZ'):
                cases.append((profile, title, media_type, False))
        # Le zéro historique ne doit pas être remplacé par le O nouvellement demandé.
        cases.append((profile, base + 'k0RE', media_type, True))
    audit.prepare([(title, media_type) for _, title, media_type, _ in cases])
    checks, failures = 0, []

    def check(passed, label):
        nonlocal checks
        checks += 1
        if not passed:
            failures.append(label)

    check(set(minimums) == set(PROFILE_TARGETS), 'Liste des dix profils inattendue')
    for profile in PROFILE_TARGETS:
        arr = 'radarr' if profile.startswith('FR-Films-') else 'sonarr'
        # Borne conservatrice : même tous les bonus, y compris incompatibles entre
        # eux, ne peuvent compenser le malus. Les cas parser vérifient son activation.
        rows = conn.execute(
            "SELECT custom_format_name, score FROM quality_profile_custom_formats "
            "WHERE quality_profile_name=? AND arr_type IN ('all', ?)", (profile, arr)
        ).fetchall()
        upper_bound = sum(max(row['score'], 0) for row in rows)
        blocker = next(row['score'] for row in rows if row['custom_format_name'] == 'FR-Blockers')
        check(blocker == -999999 and upper_bound + blocker < minimums[profile],
              f'{profile}: les bonus ne doivent jamais annuler le blocage')
    for profile, title, media_type, blocked in cases:
        score, matched = audit.scores(profile, title, media_type, size=5 * 1024**3)
        if blocked:
            check(matched.get('FR-Blockers') == -999999, f'{profile}: équipe non détectée : {title}')
            check(score < minimums[profile], f'{profile}: exclusion inefficace, score={score} : {title}')
        else:
            check('FR-Blockers' not in matched, f'{profile}: faux positif sur nom voisin/titre : {title}')
            check(score >= minimums[profile], f'{profile}: témoin favorable refusé, score={score} : {title}')
    for failure in failures:
        print('FAIL:', failure)
    print(f'Équipes interdites : {checks-len(failures)}/{checks} contrôles OK, '
          f'{len(cases)} cas sur {len(PROFILE_TARGETS)} profils, {len(failures)} FAIL')
    conn.close()
    return int(bool(failures))


if __name__ == '__main__':
    raise SystemExit(main())

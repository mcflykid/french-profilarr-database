#!/usr/bin/env python3
"""Prouve que les contrôles refusent des régressions injectées en mémoire."""
from parser_audit import database
from verify_quality_profiles import audit_quality_profiles, PROFILE_TARGETS
from verify_media_profiles import audit_media_profiles, PRESETS


def main():
    conn = database()
    conn.commit()
    audit = lambda: audit_quality_profiles(conn, verbose=False) + audit_media_profiles(conn, verbose=False)
    if audit():
        raise AssertionError('La base de référence doit être valide')
    count = 0

    def reject(sql, params):
        nonlocal count
        conn.execute('SAVEPOINT mutation')
        try:
            cursor = conn.execute(sql, params)
            if cursor.rowcount < 1 or not audit():
                raise AssertionError(f'Régression non détectée: {sql} {params}')
            count += 1
        finally:
            conn.execute('ROLLBACK TO mutation')
            conn.execute('RELEASE mutation')

    for name, levels in PROFILE_TARGETS.items():
        for column, value in (('upgrades_allowed', 0), ('minimum_custom_format_score', 20000),
                              ('upgrade_until_score', 0), ('upgrade_score_increment', 1)):
            reject(f'UPDATE quality_profiles SET {column}=? WHERE name=?', (value, name))
        reject('UPDATE quality_profile_qualities SET enabled=0 WHERE quality_profile_name=? AND position=0', (name,))
        reject('UPDATE quality_profile_qualities SET upgrade_until=0 WHERE quality_profile_name=?', (name,))
        reject('DELETE FROM quality_group_members WHERE quality_profile_name=?', (name,))
        if len(levels) > 1:
            reject('UPDATE quality_profile_qualities SET position=10-position WHERE quality_profile_name=?', (name,))
    for preset, (arr, _, _) in PRESETS.items():
        for column, value in (('max_size', 2000), ('min_size', 900), ('preferred_size', -1)):
            reject(f'UPDATE {arr}_quality_definitions SET {column}=? WHERE name=? AND quality_name=?',
                   (value, preset, 'HDTV-2160p'))
        reject(f'UPDATE {arr}_naming SET rename=1 WHERE name=?', (preset,))
        if arr == 'sonarr':
            reject('UPDATE sonarr_naming SET colon_replacement_format=? WHERE name=?', ('smart', preset))
    print(f'Garde-fous: {count}/{count} configurations défectueuses rejetées (base temporaire)')
    conn.close()
    return 0


if __name__ == '__main__':
    raise SystemExit(main())

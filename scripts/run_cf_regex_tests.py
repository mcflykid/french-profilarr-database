#!/usr/bin/env python3
"""
Exécute les tests ops/11 contre la logique regex de ops/02 + ops/04.

Approximation du parser Radarr (release_title / release_group + required/optional).
Les CF avec conditions resolution/size/language sont ignorés (signalés en WARN).

Usage :
  python3 scripts/run_cf_regex_tests.py              # tous les tests (bruyant)
  python3 scripts/run_cf_regex_tests.py --calibrage-only  # releases réelles (CI)
"""

from __future__ import annotations

import argparse
import re
import sys
from dataclasses import dataclass, field
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
OPS02 = ROOT / "ops" / "02-regex.sql"
OPS04 = ROOT / "ops" / "04-custom-format-conditions.sql"
OPS11 = ROOT / "ops" / "11-custom-format-tests.sql"

RE_COND = re.compile(
    r"INSERT INTO custom_format_conditions \(custom_format_name, name, type, arr_type, negate, required\)\s+"
    r"SELECT '([^']+)', '([^']+)', '([^']+)', '[^']+', (\d), (\d+)",
)
RE_PATTERN_LINK = re.compile(
    r"SELECT '([^']+)', '([^']+)', re\.name FROM regular_expressions re WHERE re\.name = '([^']+)'"
)
RE_TEST = re.compile(
    r"\(\s*'([^']+)',\s*'((?:''|[^'])*)',\s*'(movie|series)',\s*([01]),"
)


@dataclass
class Condition:
    name: str
    ctype: str
    negate: bool
    required: bool
    patterns: list[str] = field(default_factory=list)


def unesc(s: str) -> str:
    return s.replace("''", "'")


def load_regex() -> dict[str, re.Pattern[str]]:
    from validate_regex_ops import iter_regex_rows

    out: dict[str, re.Pattern[str]] = {}
    skipped: list[str] = []
    for name, pattern, _desc in iter_regex_rows(OPS02.read_text(encoding="utf-8")):
        try:
            out[name] = re.compile(pattern, re.IGNORECASE)
        except re.error:
            skipped.append(name)
    if skipped:
        print(
            f"WARN: {len(skipped)} regex non compilables en Python "
            f"(OK en .NET/Radarr): {', '.join(skipped[:5])}"
            + ("…" if len(skipped) > 5 else "")
        )
    return out


def load_cf_conditions() -> dict[str, list[Condition]]:
    text = OPS04.read_text(encoding="utf-8")
    cfs: dict[str, dict[str, Condition]] = {}
    for cf, cname, ctype, neg, req in RE_COND.findall(text):
        cfs.setdefault(cf, {})[cname] = Condition(
            cname, ctype, negate=bool(int(neg)), required=bool(int(req))
        )
    for cf, cname, rname in RE_PATTERN_LINK.findall(text):
        if cf in cfs and cname in cfs[cf]:
            cfs[cf][cname].patterns.append(rname)
    return {cf: list(conds.values()) for cf, conds in cfs.items()}


def load_tests() -> list[tuple[str, str, str, int]]:
    text = OPS11.read_text(encoding="utf-8")
    return [
        (cf, unesc(title), unesc(desc), int(should))
        for cf, title, _typ, should, desc in re.findall(
            r"\(\s*'([^']+)',\s*'((?:''|[^'])*)',\s*'(movie|series)',\s*([01]),\s*'((?:''|[^'])*)'\)",
            text,
        )
    ]


def is_calibrage_test(description: str) -> bool:
    d = description.lower()
    return (
        "calibrage" in d
        or "c411" in d
        or "torr9" in d
        or "winks" in description
        or "slay3r" in description
    )


def condition_matches(cond: Condition, title: str, regex: dict[str, re.Pattern[str]]) -> bool:
    if cond.ctype not in ("release_title", "release_group"):
        return True
    if not cond.patterns:
        return False
    hit = any(regex[p].search(title) for p in cond.patterns if p in regex)
    return not hit if cond.negate else hit


def cf_matches(conditions: list[Condition], title: str, regex: dict[str, re.Pattern[str]]) -> bool | None:
    """None = CF non évaluable (conditions resolution / size / langue, etc.)."""
    if any(c.ctype not in ("release_title", "release_group") for c in conditions):
        return None
    evaluable = conditions
    required = [c for c in evaluable if c.required]
    optional = [c for c in evaluable if not c.required]
    for c in required:
        if not condition_matches(c, title, regex):
            return False
    if optional:
        if not any(condition_matches(c, title, regex) for c in optional):
            return False
    return True


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--calibrage-only",
        action="store_true",
        help="Uniquement les tests issus de releases réelles (C411, Torr9, Calibrage, …)",
    )
    args = parser.parse_args()

    regex = load_regex()
    cfs = load_cf_conditions()
    tests = load_tests()
    if args.calibrage_only:
        tests = [t for t in tests if is_calibrage_test(t[2])]

    ok = fail = skip = 0
    failures: list[str] = []

    for cf, title, _desc, expected in tests:
        conds = cfs.get(cf)
        if not conds:
            skip += 1
            continue
        got = cf_matches(conds, title, regex)
        if got is None:
            skip += 1
            continue
        if bool(got) == bool(expected):
            ok += 1
        else:
            fail += 1
            failures.append(
                f"{cf!r}: {title[:70]!r}… expected={expected} got={int(got)}"
            )

    mode = "calibrage" if args.calibrage_only else "complet"
    print(
        f"run_cf_regex_tests ({mode}): {ok} OK, {fail} FAIL, {skip} SKIP "
        f"({len(tests)} tests)"
    )
    if failures:
        print("\nÉchecs (max 20):")
        for line in failures[:20]:
            print(f"  - {line}")
        if len(failures) > 20:
            print(f"  … et {len(failures) - 20} autres")
        return 1
    if fail == 0:
        print("OK — tests regex alignés avec ops/11 (hors CF resolution/size/langue)")
    return 0 if fail == 0 else 1


if __name__ == "__main__":
    sys.exit(main())

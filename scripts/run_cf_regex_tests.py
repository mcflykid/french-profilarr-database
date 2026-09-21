#!/usr/bin/env python3
"""Entrée historique : exécute désormais TOUS les cas avec le parser .NET.

PARSER_URL est nécessaire. --calibrage-only reste accepté pour compatibilité,
mais ne réduit plus la couverture. L'ancien simulateur Python était incomplet.
"""
import argparse
import sys

from test_all_custom_formats import main


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--calibrage-only", action="store_true", help="Obsolète : tous les cas sont exécutés")
    parser.parse_args()
    sys.exit(main())

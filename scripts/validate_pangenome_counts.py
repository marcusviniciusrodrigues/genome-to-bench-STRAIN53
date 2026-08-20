#!/usr/bin/env python3
"""Validate reported pan-genome counts against an archived Roary CSV."""

from __future__ import annotations

import argparse
import csv
from pathlib import Path

from config_value import load_config


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--config", default="config/config.yaml")
    parser.add_argument("--roary-csv")
    args = parser.parse_args()

    config = load_config(Path(args.config))
    expected = int(config["pangenome"]["reported_gene_clusters"])
    path = Path(args.roary_csv or config["pangenome"]["roary_output"])
    if not path.exists():
        raise SystemExit(
            f"Roary output not found: {path}. Restore the archived file before validation."
        )

    with path.open(encoding="utf-8-sig", newline="") as handle:
        reader = csv.DictReader(handle)
        rows = sum(1 for _ in reader)
    if rows != expected:
        raise SystemExit(
            f"Mismatch: Roary contains {rows} gene clusters; config reports {expected}."
        )
    print(f"Validated: Roary contains {rows} gene clusters.")


if __name__ == "__main__":
    main()

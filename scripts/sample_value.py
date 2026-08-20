#!/usr/bin/env python3
"""Read one field for a sample from config/samples.tsv."""

from __future__ import annotations

import argparse
import csv
from pathlib import Path


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("sample_id")
    parser.add_argument("field")
    parser.add_argument("--samples", default="config/samples.tsv")
    args = parser.parse_args()

    with Path(args.samples).open(encoding="utf-8", newline="") as handle:
        rows = csv.DictReader(handle, delimiter="\t")
        if args.field not in (rows.fieldnames or []):
            raise SystemExit(f"Missing samples.tsv field: {args.field}")
        for row in rows:
            if row.get("sample_id") == args.sample_id:
                value = row.get(args.field, "")
                if not value:
                    raise SystemExit(
                        f"Empty samples.tsv value for {args.sample_id}.{args.field}"
                    )
                print(value)
                return
    raise SystemExit(f"Unknown sample_id: {args.sample_id}")


if __name__ == "__main__":
    main()


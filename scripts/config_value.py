#!/usr/bin/env python3
"""Read one dotted value from the workflow YAML configuration."""

from __future__ import annotations

import argparse
import re
from pathlib import Path
from typing import Any


def parse_scalar(raw: str) -> str | int | float | bool:
    value = raw.split(" #", 1)[0].strip()
    if len(value) >= 2 and value[0] == value[-1] and value[0] in {'"', "'"}:
        return value[1:-1]
    if value.lower() in {"true", "false"}:
        return value.lower() == "true"
    if re.fullmatch(r"[-+]?\d+", value):
        return int(value)
    if re.fullmatch(r"[-+]?(?:\d+\.\d*|\d*\.\d+)", value):
        return float(value)
    return value


def load_config(path: Path) -> dict[str, Any]:
    """Parse the map-and-scalar YAML subset used by config/config.yaml."""
    root: dict[str, Any] = {}
    stack: list[tuple[int, dict[str, Any]]] = [(-1, root)]
    for line_number, raw_line in enumerate(path.read_text(encoding="utf-8").splitlines(), 1):
        if not raw_line.strip() or raw_line.lstrip().startswith("#"):
            continue
        indent = len(raw_line) - len(raw_line.lstrip(" "))
        if "\t" in raw_line[:indent]:
            raise ValueError(f"Tabs are not allowed for indentation (line {line_number})")
        key, separator, raw_value = raw_line.strip().partition(":")
        if not separator or not key:
            raise ValueError(f"Expected 'key: value' on line {line_number}")
        while stack[-1][0] >= indent:
            stack.pop()
        parent = stack[-1][1]
        if raw_value.strip():
            parent[key] = parse_scalar(raw_value)
        else:
            child: dict[str, Any] = {}
            parent[key] = child
            stack.append((indent, child))
    return root


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("key", help="Dotted key, for example resources.threads")
    parser.add_argument("--config", default="config/config.yaml")
    args = parser.parse_args()

    data: Any = load_config(Path(args.config))
    for part in args.key.split("."):
        if not isinstance(data, dict) or part not in data:
            raise SystemExit(f"Missing configuration key: {args.key}")
        data = data[part]

    if isinstance(data, bool):
        print(str(data).lower())
    elif isinstance(data, (str, int, float)):
        print(data)
    else:
        raise SystemExit(f"Configuration key is not a scalar: {args.key}")


if __name__ == "__main__":
    main()

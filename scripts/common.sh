#!/usr/bin/env bash
# Shared configuration helpers for all workflow stages.

PROJECT_ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
cd "$PROJECT_ROOT"

CONFIG_FILE=${CONFIG_FILE:-config/config.yaml}
SAMPLES_FILE=${SAMPLES_FILE:-config/samples.tsv}

config_get() {
  python scripts/config_value.py --config "$CONFIG_FILE" "$1"
}

sample_get() {
  python scripts/sample_value.py --samples "$SAMPLES_FILE" "$1" "$2"
}


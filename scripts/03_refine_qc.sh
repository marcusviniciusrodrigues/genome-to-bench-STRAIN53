#!/usr/bin/env bash
# Stage 3 - RagTag + QUAST + BUSCO (MeDuSa, Proksee, CLC and PlasFlow are separate).
set -euo pipefail
source "$(dirname "$0")/common.sh"

SAMPLE_ID=${SAMPLE_ID:-$(config_get project.focal_sample_id)}
THREADS=${THREADS:-$(config_get resources.threads)}
RESULTS_DIR=$(config_get paths.results_dir)
REF=$(config_get assembly.scaffolding_reference)
LINEAGE=$(config_get assembly.busco_lineage)
MEDUSA_ASSEMBLY="$RESULTS_DIR/medusa_$SAMPLE_ID.fasta"
RAGTAG_DIR="$RESULTS_DIR/ragtag_$SAMPLE_ID"
QUAST_DIR="$RESULTS_DIR/quast_$SAMPLE_ID"

mkdir -p "$QUAST_DIR"

# Run MeDuSa first (see docs/03); it produces $MEDUSA_ASSEMBLY.
ragtag.py scaffold "$REF" "$MEDUSA_ASSEMBLY" -o "$RAGTAG_DIR"
ASM="$RAGTAG_DIR/ragtag.scaffold.fasta"

quast.py "$ASM" -o "$QUAST_DIR" -t "$THREADS"
busco -i "$ASM" -m genome -l "$LINEAGE" -o "${SAMPLE_ID}_busco" -c "$THREADS"
echo "[done] stage 3"

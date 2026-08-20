#!/usr/bin/env bash
# Stage 5 - tBLASTn of curated PGPR targets against the focal genome.
set -euo pipefail
source "$(dirname "$0")/common.sh"

SAMPLE_ID=${SAMPLE_ID:-$(config_get project.focal_sample_id)}
RESULTS_DIR=$(config_get paths.results_dir)
QUERY=$(config_get paths.pgpr_targets)
ASM="$RESULTS_DIR/ragtag_$SAMPLE_ID/ragtag.scaffold.fasta"
BLAST_DIR="$RESULTS_DIR/blastdb"
OUT="$RESULTS_DIR/tblastn_$SAMPLE_ID.tsv"

mkdir -p "$BLAST_DIR"

makeblastdb -in "$ASM" -dbtype nucl -out "$BLAST_DIR/$SAMPLE_ID"
tblastn -query "$QUERY" -db "$BLAST_DIR/$SAMPLE_ID" \
  -outfmt "6 qseqid sseqid pident length qcovs evalue bitscore" \
  -out "$OUT"
echo "[done] stage 5 -> $OUT"

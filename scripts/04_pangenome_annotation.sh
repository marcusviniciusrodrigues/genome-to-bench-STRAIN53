#!/usr/bin/env bash
# Stage 4 - Prokka + Roary + COGclassifier. See docs/04_*.
set -euo pipefail
source "$(dirname "$0")/common.sh"

SAMPLE_ID=${SAMPLE_ID:-$(config_get project.focal_sample_id)}
THREADS=${THREADS:-$(config_get resources.threads)}
RESULTS_DIR=$(config_get paths.results_dir)
GENOMES_DIR=$(config_get paths.pangenome_genomes_dir)
PROKKA_DIR="$RESULTS_DIR/prokka"
ROARY_DIR="$RESULTS_DIR/roary"
COG_DIR="$RESULTS_DIR/cogclassifier_$SAMPLE_ID"

mkdir -p "$PROKKA_DIR" "$ROARY_DIR" "$COG_DIR"

for genome in "$GENOMES_DIR"/*.fasta; do
  name=$(basename "$genome" .fasta)
  prokka --kingdom Bacteria --genus Bacillus --species nitratireducens \
    --prefix "$name" --outdir "$PROKKA_DIR/$name" --cpus "$THREADS" "$genome"
done

roary -e --mafft -p "$THREADS" -f "$ROARY_DIR" "$PROKKA_DIR"/*/*.gff

COGclassifier -i "$PROKKA_DIR/$SAMPLE_ID/$SAMPLE_ID.faa" -o "$COG_DIR"
echo "[done] stage 4"

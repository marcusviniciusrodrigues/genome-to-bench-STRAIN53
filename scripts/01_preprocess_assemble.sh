#!/usr/bin/env bash
# Stage 1 - Trimmomatic (Q30) + SPAdes. See docs/01_preprocessing_and_assembly.md
set -euo pipefail
source "$(dirname "$0")/common.sh"

SAMPLE_ID=${SAMPLE_ID:-$(config_get project.focal_sample_id)}
THREADS=${THREADS:-$(config_get resources.threads)}
MEM=${MEM:-$(config_get resources.memory_gb)}
RESULTS_DIR=$(config_get paths.results_dir)
R1=$(sample_get "$SAMPLE_ID" read_1)
R2=$(sample_get "$SAMPLE_ID" read_2)
ADAPTERS=${ADAPTERS:-$(config_get trimming.adapters)}
Q=$(config_get trimming.phred_cutoff)
WINDOW=$(config_get trimming.sliding_window)
MINLEN=$(config_get trimming.minimum_length)
TRIM_DIR="$RESULTS_DIR/trimmed/$SAMPLE_ID"
SPADES_DIR="$RESULTS_DIR/spades_$SAMPLE_ID"

mkdir -p "$TRIM_DIR" "$SPADES_DIR"

trimmomatic PE -phred33 "$R1" "$R2" \
  "$TRIM_DIR/${SAMPLE_ID}_R1.paired.fq.gz" "$TRIM_DIR/${SAMPLE_ID}_R1.unpaired.fq.gz" \
  "$TRIM_DIR/${SAMPLE_ID}_R2.paired.fq.gz" "$TRIM_DIR/${SAMPLE_ID}_R2.unpaired.fq.gz" \
  ILLUMINACLIP:"$ADAPTERS":2:30:10 SLIDINGWINDOW:"$WINDOW":"$Q" \
  LEADING:"$Q" TRAILING:"$Q" MINLEN:"$MINLEN"

spades.py -1 "$TRIM_DIR/${SAMPLE_ID}_R1.paired.fq.gz" \
  -2 "$TRIM_DIR/${SAMPLE_ID}_R2.paired.fq.gz" \
  -o "$SPADES_DIR" --careful -t "$THREADS" -m "$MEM"
echo "[done] contigs: $SPADES_DIR/contigs.fasta"

#!/usr/bin/env bash
# Stage 1 — Trimmomatic (Q30) + SPAdes. See docs/01_preprocessing_and_assembly.md
set -euo pipefail
THREADS=${THREADS:-8}; MEM=${MEM:-32}
R1=data/reads/STRAIN53_R1.fastq.gz
R2=data/reads/STRAIN53_R2.fastq.gz
ADAPTERS=${ADAPTERS:-adapters.fa}     # <-- set your adapter FASTA
mkdir -p results/trimmed results/spades_STRAIN53

trimmomatic PE -phred33 "$R1" "$R2" \
  results/trimmed/R1.paired.fq.gz results/trimmed/R1.unpaired.fq.gz \
  results/trimmed/R2.paired.fq.gz results/trimmed/R2.unpaired.fq.gz \
  ILLUMINACLIP:"$ADAPTERS":2:30:10 SLIDINGWINDOW:4:30 LEADING:30 TRAILING:30 MINLEN:36

spades.py -1 results/trimmed/R1.paired.fq.gz -2 results/trimmed/R2.paired.fq.gz \
  -o results/spades_STRAIN53 --careful -t "$THREADS" -m "$MEM"
echo "[done] contigs: results/spades_STRAIN53/contigs.fasta"

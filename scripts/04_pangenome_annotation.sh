#!/usr/bin/env bash
# Stage 4 — Prokka + Roary + COGclassifier. See docs/04_*
set -euo pipefail
THREADS=${THREADS:-8}
mkdir -p results/prokka results/roary results/cogclassifier_STRAIN53

for g in data/genomes_pangenome/*.fasta; do
  name=$(basename "$g" .fasta)
  prokka --kingdom Bacteria --genus Bacillus --species nitratireducens \
    --prefix "$name" --outdir results/prokka/"$name" --cpus "$THREADS" "$g"
done

roary -e --mafft -p "$THREADS" -f results/roary results/prokka/*/*.gff   # Fig 3A

COGclassifier -i results/prokka/STRAIN53/STRAIN53.faa -o results/cogclassifier_STRAIN53  # Fig 3B
echo "[done] stage 4"

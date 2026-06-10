#!/usr/bin/env bash
# Stage 5 — tBLASTn of mined PGPR genes vs STRAIN53 genome. See docs/05_*
set -euo pipefail
mkdir -p results/blastdb
ASM=results/ragtag_STRAIN53/ragtag.scaffold.fasta
QUERY=data/mined_genes/pgpr_targets.faa   # multi-FASTA from UniProt

makeblastdb -in "$ASM" -dbtype nucl -out results/blastdb/STRAIN53
tblastn -query "$QUERY" -db results/blastdb/STRAIN53 \
  -outfmt "6 qseqid sseqid pident length qcovs evalue bitscore" \
  -out results/tblastn_STRAIN53.tsv   # -> Table 2
echo "[done] stage 5 -> results/tblastn_STRAIN53.tsv"

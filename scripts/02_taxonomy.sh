#!/usr/bin/env bash
# Stage 2 — GTDB-Tk + ANIclustermap + marker alignments/trees. See docs/02_*
# (BLASTn vs GenBank and MEGA/PhyloSuite/iTOL/FigTree steps are web/GUI.)
set -euo pipefail
THREADS=${THREADS:-8}
mkdir -p results/gtdbtk_STRAIN53 results/aniclustermap results/markers results/trees

gtdbtk classify_wf --genome_dir results/spades_STRAIN53/ --extension fasta \
  --out_dir results/gtdbtk_STRAIN53 --cpus "$THREADS"

# OrthoANI heatmap (Fig 2A) — directory of B. cereus-group genomes (FASTA)
ANIclustermap -i data/genomes_cereus_group/ -o results/aniclustermap \
  --cmap_colors green,yellow,red

# Marker alignments (CLI alternative to MAFFT online)
mafft --auto data/markers/16S.fasta  > results/markers/16S.aln.fasta
mafft --auto data/markers/gyrB.fasta > results/markers/gyrB.aln.fasta

# Maximum likelihood (Fig 2C)
iqtree -s results/markers/16S.aln.fasta -m MFP -bb 1000 -nt AUTO -pre results/trees/16S_ml
# Bayesian inference (Fig 2B): prepare results/trees/16S.nex with a mrbayes block, then:
# mb results/trees/16S.nex
echo "[done] stage 2"

#!/usr/bin/env bash
# Stage 2 - GTDB-Tk + ANIclustermap + concatenated 16S/gyrB phylogeny.
set -euo pipefail
source "$(dirname "$0")/common.sh"

SAMPLE_ID=${SAMPLE_ID:-$(config_get project.focal_sample_id)}
THREADS=${THREADS:-$(config_get resources.threads)}
RESULTS_DIR=$(config_get paths.results_dir)
ANI_DIR=$(config_get paths.ani_genomes_dir)
MARKER_16S=$(config_get paths.marker_16s)
MARKER_GYRB=$(config_get paths.marker_gyrb)
SPADES_DIR="$RESULTS_DIR/spades_$SAMPLE_ID"
GTDB_DIR="$RESULTS_DIR/gtdbtk_$SAMPLE_ID"
MARKER_DIR="$RESULTS_DIR/markers"
TREE_DIR="$RESULTS_DIR/trees"
CONCAT_FASTA="$MARKER_DIR/16S_gyrB.concat.fasta"
CONCAT_NEXUS="$TREE_DIR/16S_gyrB.concat.nex"

mkdir -p "$GTDB_DIR" "$RESULTS_DIR/aniclustermap" "$MARKER_DIR" "$TREE_DIR"

gtdbtk classify_wf --genome_dir "$SPADES_DIR" --extension fasta \
  --out_dir "$GTDB_DIR" --cpus "$THREADS"

# OrthoANI heatmap (Figure 2A).
ANIclustermap -i "$ANI_DIR" -o "$RESULTS_DIR/aniclustermap" \
  --cmap_colors green,yellow,red

# Align markers independently, then concatenate identical taxon sets.
mafft --auto "$MARKER_16S" > "$MARKER_DIR/16S.aln.fasta"
mafft --auto "$MARKER_GYRB" > "$MARKER_DIR/gyrB.aln.fasta"
python scripts/concatenate_markers.py \
  --alignment "16S=$MARKER_DIR/16S.aln.fasta" \
  --alignment "gyrB=$MARKER_DIR/gyrB.aln.fasta" \
  --fasta-out "$CONCAT_FASTA" \
  --nexus-out "$CONCAT_NEXUS" \
  --mrbayes-nst "$(config_get phylogeny.mrbayes_nst)" \
  --mrbayes-rates "$(config_get phylogeny.mrbayes_rates)" \
  --mrbayes-generations "$(config_get phylogeny.mrbayes_generations)" \
  --mrbayes-sample-frequency "$(config_get phylogeny.mrbayes_sample_frequency)" \
  --mrbayes-burnin-fraction "$(config_get phylogeny.mrbayes_burnin_fraction)"

# Maximum likelihood (Figure 2C) uses the concatenated 16S + gyrB alignment.
iqtree -s "$CONCAT_FASTA" -m "$(config_get phylogeny.iqtree_model)" \
  -bb "$(config_get phylogeny.bootstrap_replicates)" -nt AUTO \
  -pre "$TREE_DIR/16S_gyrB_ml"

# Bayesian inference (Figure 2B) uses the same concatenated characters.
# Review the model and MCMC settings in config/config.yaml before enabling.
if [[ "${RUN_MRBAYES:-$(config_get phylogeny.run_mrbayes)}" == "true" ]]; then
  mb "$CONCAT_NEXUS"
else
  echo "[note] MrBayes input written to $CONCAT_NEXUS; set RUN_MRBAYES=true after verifying settings."
fi
echo "[done] stage 2"

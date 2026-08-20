# 02 — Taxonomic Identification

**Goal:** confirm the strain's identity within the *Bacillus cereus* group and place it phylogenetically.
**Tools:** BLASTn (NCBI), GTDB-Tk, ANIclustermap, MAFFT, MEGA X, IQ-TREE (PhyloSuite), MrBayes v3.2.1, iTOL / FigTree.

## 2.1 Similarity search — BLASTn (GenBank)

A representative DNA fragment from the assembly was queried with **BLASTn** at NCBI.
**Retention threshold:** hits with **identity and coverage > 90%**.

- Web: https://blast.ncbi.nlm.nih.gov (nucleotide BLAST vs nt/GenBank).
- Local equivalent: `blastn -query <fragment.fasta> -db nt -perc_identity 90 -outfmt 6`.

## 2.2 Phylogenomic placement — GTDB-Tk

```bash
gtdbtk classify_wf \
  --genome_dir results/spades_LABIM53/ \
  --extension fasta \
  --out_dir results/gtdbtk_LABIM53 \
  --cpus <threads>
```

**Retention threshold:** taxonomic proximity **> 95%**. Result: member of the *B. cereus* group.

## 2.3 Whole-genome ANI clustering — ANIclustermap → **Fig 2A**

Place the draft and complete *B. cereus*-group genomes (FASTA) in a directory, then:

```bash
ANIclustermap \
  -i data/genomes_cereus_group/ \
  -o results/aniclustermap \
  --cmap_colors green,yellow,red
```

Produces the OrthoANI heatmap + hierarchical clustering used in **Figure 2A**.

## 2.4 Marker-gene phylogenies (16S rRNA + *gyrB*) → **Fig 2B / 2C**

1. **Extract** 16S rRNA and *gyrB* sequences from the same set of genomes. Use identical FASTA identifiers for both markers and record the accessions in `metadata/accessions/marker_sequences.tsv`.
2. **Align** each marker with MAFFT (online service used in the paper; CLI equivalent below):
   ```bash
   mafft --auto data/markers/16S.fasta > results/markers/16S.aln.fasta
   mafft --auto data/markers/gyrB.fasta > results/markers/gyrB.aln.fasta
   ```
3. **Inspect/edit** both alignments in MEGA X (GUI), preserving identical taxon sets.
4. **Concatenate** the edited alignments by FASTA identifier. The helper fails if the taxon sets differ and emits the same character matrix as FASTA and NEXUS:
   ```bash
   python scripts/concatenate_markers.py \
     --alignment 16S=results/markers/16S.aln.fasta \
     --alignment gyrB=results/markers/gyrB.aln.fasta \
     --fasta-out results/markers/16S_gyrB.concat.fasta \
     --nexus-out results/trees/16S_gyrB.concat.nex
   ```
5. **Maximum likelihood** — IQ-TREE (run via PhyloSuite in the paper) on the concatenated input:
   ```bash
   iqtree -s results/markers/16S_gyrB.concat.fasta -m MFP -bb 1000 -nt AUTO \
     -pre results/trees/16S_gyrB_ml
   ```
   → **Figure 2C**
6. **Bayesian inference** — MrBayes v3.2.1 on the NEXUS representation of the same concatenated characters:
   ```bash
   mb results/trees/16S_gyrB.concat.nex
   ```
   → **Figure 2B**
7. **Visualise/edit** with iTOL (v6–7) and FigTree v1.4.4.

> Substitution model and MCMC settings must be verified against the original analysis before enabling MrBayes in `config/config.yaml`. Node values in Figure 2B are posterior probabilities; in Figure 2C, bootstrap support. Both figures must use the concatenated 16S + *gyrB* taxon-by-character matrix.

## 2.5 dDDH scope

Digital DNA-DNA hybridisation (dDDH) is not documented by an archived input, method or output in this repository. It is therefore not part of the supported workflow and no dDDH result should be inferred from these files. Remove any dDDH claim from the manuscript Discussion unless the missing Methods, Results and output provenance are supplied together.

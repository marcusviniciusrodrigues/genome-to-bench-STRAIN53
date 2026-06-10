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
  --genome_dir results/spades_STRAIN53/ \
  --extension fasta \
  --out_dir results/gtdbtk_STRAIN53 \
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

1. **Extract** 16S rRNA and *gyrB* sequences from the genomes.
2. **Align** with MAFFT (online service used in the paper; CLI equivalent below):
   ```bash
   mafft --auto data/markers/16S.fasta > results/markers/16S.aln.fasta
   mafft --auto data/markers/gyrB.fasta > results/markers/gyrB.aln.fasta
   ```
3. **Inspect/edit** alignments in MEGA X (GUI).
4. **Maximum likelihood** — IQ-TREE (run via PhyloSuite in the paper):
   ```bash
   iqtree -s results/markers/16S.aln.fasta -m MFP -bb 1000 -nt AUTO \
     -pre results/trees/16S_ml
   ```
   → **Figure 2C**
5. **Bayesian inference** — MrBayes v3.2.1 (MCMC with Gibbs sampling; posterior probabilities):
   ```bash
   mb results/trees/16S.nex   # NEXUS with an mrbayes block (lset/mcmc settings)
   ```
   → **Figure 2B**
6. **Visualise/edit** with iTOL (v6–7) and FigTree v1.4.4.

> Substitution model and MCMC generations follow the PhyloSuite/MrBayes settings you used; set them in the IQ-TREE `-m` flag and the MrBayes block. Node values in Fig 2B are posterior probabilities; in Fig 2C, bootstrap support.

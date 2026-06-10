# 00 — Overview

This workflow links **genome-based predictions** to **bench validation** to prioritise candidate biofertilizer (PGPR) strains, demonstrated on *Bacillus nitratireducens* STRAIN53.

The stages are:

1. [Preprocessing & assembly](01_preprocessing_and_assembly.md) — Trimmomatic → SPAdes
2. [Taxonomic identification](02_taxonomic_identification.md) — BLASTn, GTDB-Tk, ANIclustermap, 16S/*gyrB* phylogenies (IQ-TREE, MrBayes)
3. [Assembly refinement & QC](03_assembly_refinement_and_qc.md) — MeDuSa, RagTag, Proksee/CGView, CLC, PlasFlow, QUAST, BUSCO
4. [Pan-genome & functional annotation](04_pangenome_and_functional_annotation.md) — Prokka, Roary, COGclassifier
5. [Gene mining](05_gene_mining.md) — UniProt + tBLASTn for PGPR-related genes
6. [In vitro validation](06_invitro_validation.md) — IAA (Salkowski), HPLC organic acids, NBRIP/Aleksandrov solubilization

## Inputs you need

- Paired-end Illumina MiSeq reads for the focal strain (BioProject [PRJNA1114765](https://www.ncbi.nlm.nih.gov/bioproject/PRJNA1114765)).
- Reference and comparison genomes from GenBank:
  - the closest complete genome for scaffolding (*B. nitratireducens* BM02),
  - 12 *B. nitratireducens* genomes for the circular comparison (Fig 1),
  - 14 public *B. nitratireducens* genomes for the pan-genome (Fig 3A),
  - *B. cereus* group genomes for ANI clustering (Fig 2A),
  - 16S rRNA and *gyrB* sequences extracted from the genomes (Fig 2B/2C).

## Figure ↔ step map

| Figure | Produced in stage |
| --- | --- |
| Fig 1 (circular comparison) | 3 — Proksee/CGView |
| Fig 2A (ANI heatmap) | 2 — ANIclustermap |
| Fig 2B (Bayesian 16S tree) | 2 — MrBayes |
| Fig 2C (ML 16S tree) | 2 — IQ-TREE |
| Fig 3A (pan-genome matrix) | 4 — Roary |
| Fig 3B (COG classification) | 4 — COGclassifier |
| Fig 4 (solubilization plates) | 6 — bench assays |
| Table 1 (chromosome/plasmid) | 3 — PlasFlow |
| Table 2 (mined genes) | 5 — tBLASTn |

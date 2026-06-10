# Genome-to-Bench Workflow

Reproducible, step-by-step pipeline accompanying the article:

> **An integrated genome-to-bench workflow for identifying candidate biofertilizer strains: application to *Bacillus nitratireducens* STRAIN53**
> Rodrigues M.V.S., Garcia A.B., Gouveia P.O., Oliveira J.P., Nicoletto M.L.A., Noriler S., Oliveira Junior A.G., Rocha U.N., Bressan G.M.

This repository documents every computational step used to go from raw Illumina reads to a functionally validated plant growth-promoting rhizobacterium (PGPR) candidate, so that the analyses can be reproduced and adapted to other strains.

---

## Data availability

| Item | Identifier |
| --- | --- |
| Raw reads (BioProject) | [PRJNA1114765](https://www.ncbi.nlm.nih.gov/bioproject/PRJNA1114765) |
| Genome assembly (GenBank) | [JBLFHU000000000](https://www.ncbi.nlm.nih.gov/nuccore/JBLFHU000000000.1/) |
| Sequencing platform | Illumina MiSeq, MiSeq Reagent Kit V2 Micro (300 cycles) |

---

## Workflow at a glance

```
Raw reads (Illumina MiSeq)
        │  Trimmomatic v0.39  (Q30, adapter removal)
        ▼
   Trimmed reads
        │  SPAdes v3.13
        ▼
   Draft contigs ───────────────► Taxonomic ID
        │                          • BLASTn vs GenBank (>90% id & cov)
        │                          • GTDB-Tk (>95%)
        │                          • ANIclustermap (OrthoANI)      → Fig 2A
        │                          • 16S rRNA + gyrB: MAFFT → IQ-TREE (ML) / MrBayes (BI)
        │                                                          → Fig 2B (BI), 2C (ML)
        ▼
   Assembly refinement
        │  MeDuSa v1.0  → RagTag v2.1  (scaffold vs B. nitratireducens BM02)
        │  Proksee / CGView (circular comparison, 12 genomes)      → Fig 1
        │  CLC Genomics Workbench v24.0 (manual gap closure)
        │  PlasFlow @ Galaxy (chromosome/plasmid)                  → Table 1
        │  QUAST + BUSCO v5.7.1 (QC / completeness)
        ▼
   Comparative genomics
        │  Prokka v1.14.6 (annotation)
        │  Roary (pan-genome, 14 public + STRAIN53)                 → Fig 3A
        │  COGclassifier (functional categories)                  → Fig 3B
        ▼
   Gene mining for PGPR traits
        │  Literature survey → UniProt → NCBI tBLASTn vs STRAIN53   → Table 2
        ▼
   In vitro validation (bench)
        │  IAA: TSB + L-tryptophan → Salkowski colorimetry
        │  Organic acids: HPLC (Aminex HPX-87X)
        │  Solubilization: NBRIP (P) & Aleksandrov (K) plates      → Fig 4
        ▼
   Candidate biofertilizer strain
```

---

## Repository structure

```
genome-to-bench-STRAIN53/
├── README.md                 ← you are here
├── environment.yml           ← conda environment with the CLI tools
├── CITATION.cff
├── LICENSE
├── docs/                     ← detailed step-by-step for each stage
│   ├── 00_overview.md
│   ├── 01_preprocessing_and_assembly.md
│   ├── 02_taxonomic_identification.md
│   ├── 03_assembly_refinement_and_qc.md
│   ├── 04_pangenome_and_functional_annotation.md
│   ├── 05_gene_mining.md
│   └── 06_invitro_validation.md
├── scripts/                  ← runnable command templates per stage
│   ├── 01_preprocess_assemble.sh
│   ├── 02_taxonomy.sh
│   ├── 03_refine_qc.sh
│   ├── 04_pangenome_annotation.sh
│   └── 05_gene_mining.sh
├── data/                     ← inputs (not tracked; see data/README.md)
└── results/                  ← outputs (not tracked; see results/README.md)
```

---

## Tools used (with versions and references)

| Stage | Tool | Version | Type | Reference |
| --- | --- | --- | --- | --- |
| Read trimming | Trimmomatic | v0.39 | CLI | Bolger et al., 2014 |
| Assembly | SPAdes | v3.13 | CLI | Bankevich et al., 2012 |
| Taxonomy (similarity) | BLASTn (NCBI) | — | web/CLI | Johnson et al., 2008 |
| Taxonomy (phylogenomic) | GTDB-Tk | — | CLI | Chaumeil et al., 2020 |
| Genome clustering (ANI) | ANIclustermap | — | CLI | He et al., 2021 |
| Alignment (16S, *gyrB*) | MAFFT | online | web/CLI | Katoh et al., 2019 |
| Alignment editing | MEGA X | — | GUI | Kumar et al., 2018 |
| ML phylogeny | IQ-TREE (in PhyloSuite) | — | CLI/GUI | Zhang et al., 2020 |
| Bayesian phylogeny | MrBayes | v3.2.1 | CLI | Ronquist et al., 2012 |
| Tree visualization | iTOL / FigTree | v6–7 / v1.4.4 | web / GUI | Letunic & Bork, 2024; Munir, 2013 |
| Scaffolding | MeDuSa | v1.0 | CLI (Java) | Bosi et al., 2015 |
| Scaffolding / gap fill | RagTag | v2.1 | CLI | Alonge et al., 2022 |
| Circular genome view | Proksee / CGView | — | web | Grant et al., 2023; Grant & Stothard, 2008 |
| Manual gap closure | CLC Genomics Workbench | v24.0 | GUI (commercial) | — |
| Completeness | BUSCO | v5.7.1 | CLI | Simão et al., 2015 |
| Assembly QC | QUAST | — | CLI | Gurevich et al., 2013 |
| Plasmid prediction | PlasFlow (@ Galaxy) | — | web | Krawczyk et al., 2018 |
| Annotation | Prokka | v1.14.6 | CLI | Seemann, 2014 |
| Pan-genome | Roary | — | CLI | Page et al., 2015 |
| Functional categories | COGclassifier | — | CLI | Tatusov et al., 2000 |
| Sequence retrieval | UniProt | — | web | UniProt Consortium, 2019 |
| Gene confirmation | tBLASTn (NCBI) | — | web/CLI | Gertz et al., 2006 |

> **Note on reproducibility scope.** The article's Methods section names the tools, versions and key parameters, but does not publish full command lines for every step. The scripts in `scripts/` are therefore *command templates* that reproduce the described analyses using each tool's standard interface and the parameters stated in the paper (e.g. Trimmomatic Phred cutoff 30). Placeholders such as `<...>`, input paths and thread counts must be set to match your environment, and any step performed in a GUI or web service (MEGA, PhyloSuite, Proksee, Galaxy/PlasFlow, iTOL, FigTree, CLC) is documented in `docs/` rather than scripted. Verify each template against your actual run before citing it as the exact procedure.

---

## Quick start

```bash
# 1. Clone
git clone https://github.com/mdsufz/genome-to-bench-STRAIN53.git
cd genome-to-bench-STRAIN53

# 2. Create the environment (CLI tools)
conda env create -f environment.yml
conda activate genome-to-bench

# 3. Place inputs (see data/README.md) and run the stages
bash scripts/01_preprocess_assemble.sh
bash scripts/02_taxonomy.sh
bash scripts/03_refine_qc.sh
bash scripts/04_pangenome_annotation.sh
bash scripts/05_gene_mining.sh
```

See the per-stage guides in [`docs/`](docs/00_overview.md) for full details, including the GUI/web steps that are not scripted.

---

## How to cite

If you use this workflow, please cite the article (see `CITATION.cff`) and the individual tools listed above.

## License

Released under the MIT License (see `LICENSE`).

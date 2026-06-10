# 03 — Assembly Refinement & QC

**Goal:** improve contiguity, inspect the circular genome, separate chromosome/plasmid, and assess quality/completeness.
**Tools:** MeDuSa v1.0, RagTag v2.1, Proksee/CGView, CLC Genomics Workbench v24.0, PlasFlow (@ Galaxy), QUAST, BUSCO v5.7.1.

## 3.1 Scaffolding — MeDuSa v1.0

Scaffold the SPAdes contigs against the closest reference (*B. nitratireducens* **BM02**, complete genome).

```bash
# MeDuSa is a Java tool (install from https://github.com/combogenomics/medusa)
java -jar medusa.jar \
  -i results/spades_STRAIN53/contigs.fasta \
  -f data/reference_genomes/ \
  -o results/medusa_STRAIN53.fasta \
  -v
```

**Reported outcome:** 425 → **300 contigs**.

## 3.2 Reference-guided scaffolding & gap fill — RagTag v2.1

```bash
ragtag.py scaffold \
  data/reference_genomes/B_nitratireducens_BM02.fasta \
  results/medusa_STRAIN53.fasta \
  -o results/ragtag_STRAIN53
```

**Reported outcome:** 300 → **276 contigs**.

## 3.3 Circular visualization & gap analysis — Proksee / CGView → **Fig 1**

- Upload the scaffolded assembly to **Proksee** (https://proksee.ca) / CGView.
- Compare against **12** *B. nitratireducens* genomes (GenBank) to identify gaps to close.
- This comparison is the basis of **Figure 1** (rings: GC content, GC skew, ORFs, and the 12 comparison genomes).

## 3.4 Manual gap closure — CLC Genomics Workbench v24.0 (GUI, commercial)

Remaining gaps were closed manually.
**Final assembly:** **36 scaffolds** (31 plasmids + 5 chromosomes), total **5,671,654 bp**, largest scaffold 5,190,595 bp, **L50 = 1**, **G+C = 35.2%**.

## 3.5 Chromosome/plasmid prediction — PlasFlow (@ Galaxy) → **Table 1**

- Run **PlasFlow** on the Galaxy web platform (https://usegalaxy.org) with the final contigs.
- Output: per-contig label (chromosome / plasmid) + taxonomic signal (Firmicutes / Proteobacteria / unclassified) → **Table 1**.

## 3.6 Quality & completeness — QUAST + BUSCO v5.7.1

```bash
quast.py results/ragtag_STRAIN53/ragtag.scaffold.fasta \
  -o results/quast_STRAIN53 -t <threads>

busco -i results/ragtag_STRAIN53/ragtag.scaffold.fasta \
  -m genome -l bacillales_odb10 \
  -o STRAIN53_busco -c <threads>
```

**Reported outcome (BUSCO, n = 124):** 100.0% complete (96.0% single-copy, 4.0% duplicated), 0.0% fragmented, 0.0% missing.

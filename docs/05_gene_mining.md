# 05 — Gene Mining for PGPR Traits

**Goal:** identify, in the STRAIN53 genome, genes linked to organic-acid production and nutrient (K/P) solubilization that guide the bench assays.
**Tools:** literature survey, UniProt, NCBI tBLASTn.

## 5.1 Literature survey (2020–2025)

Search **Google Scholar, PubMed, SciELO** for bacterial genes involved in **potassium and phosphate solubilization** by PGPR. Build a list of target genes (e.g. *ackA, gltA, mdh, ppc*, gluconate/citrate pathway genes, etc.).

## 5.2 Reference sequences — UniProt

For each target gene, retrieve the **amino-acid sequence**, functional annotation and metadata from UniProt (https://www.uniprot.org). Collect them into one multi-FASTA:

```
data/mined_genes/pgpr_targets.faa
```

## 5.3 Confirmation in the STRAIN53 genome — NCBI tBLASTn → **Table 2**

Query the mined protein set against the STRAIN53 genome (translated nucleotide search).

```bash
# local equivalent of the NCBI tBLASTn run
makeblastdb -in results/ragtag_STRAIN53/ragtag.scaffold.fasta -dbtype nucl \
  -out results/blastdb/STRAIN53

tblastn -query data/mined_genes/pgpr_targets.faa \
  -db results/blastdb/STRAIN53 \
  -outfmt "6 qseqid sseqid pident length qcovs evalue bitscore" \
  -out results/tblastn_STRAIN53.tsv
```

Report **coverage** and **identity** per gene → **Table 2** (genes assigned to K-solubilization and K+P-solubilization pathways: IAA, citric, oxalic, 2-ketogluconic, lactic, malonic, acetic, gluconic, succinic acids, etc.).

These hits define which bench assays to run in stage 6.

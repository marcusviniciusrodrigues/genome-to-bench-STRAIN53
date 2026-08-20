# 05 — Gene Mining for PGPR Traits

**Goal:** identify, in the LABIM53 genome, genes linked to organic-acid production and nutrient (K/P) solubilisation that guide the bench assays.
**Tools:** literature survey, UniProt, NCBI tBLASTn.

## 5.1 Literature survey (2020–2025)

Search **Google Scholar, PubMed and SciELO** for bacterial genes involved in **potassium and phosphate solubilisation** by PGPR. Record every candidate in `metadata/pgpr_gene_targets.tsv`; a gene name without a source sequence, organism and evidence reference is not a reproducible target.

## 5.2 Reference sequences — UniProt

For each target gene, retrieve the **amino-acid sequence**, functional annotation and metadata from UniProt (https://www.uniprot.org). Record the accession and evidence in `metadata/pgpr_gene_targets.tsv` and `metadata/accessions/uniprot_targets.tsv`, then collect the sequences into one multi-FASTA:

```
data/mined_genes/pgpr_targets.faa
```

## 5.3 Confirmation in the LABIM53 genome — NCBI tBLASTn → **Table 2**

Query the mined protein set against the LABIM53 genome (translated nucleotide search).

```bash
# local equivalent of the NCBI tBLASTn run
makeblastdb -in results/ragtag_LABIM53/ragtag.scaffold.fasta -dbtype nucl \
  -out results/blastdb/LABIM53

tblastn -query data/mined_genes/pgpr_targets.faa \
  -db results/blastdb/LABIM53 \
  -outfmt "6 qseqid sseqid pident length qcovs evalue bitscore" \
  -out results/tblastn_LABIM53.tsv
```

Report **coverage** and **identity** per gene → **Table 2** (genes assigned to K-solubilisation and K+P-solubilisation pathways: IAA, citric, oxalic, 2-ketogluconic, lactic, malonic, acetic, gluconic, succinic acids, etc.). Link each result row back to the curated target identifier.

These hits define which bench assays to run in stage 6.

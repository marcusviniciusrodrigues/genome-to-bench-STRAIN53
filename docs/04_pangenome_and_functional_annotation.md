# 04 — Pan-genome & Functional Annotation

**Goal:** annotate genes and characterise the core/accessory/strain-specific repertoire and functional categories.
**Tools:** Prokka v1.14.6, Roary, COGclassifier.

## 4.1 Annotation — Prokka v1.14.6

Annotate LABIM53 **and** the 14 public *B. nitratireducens* genomes consistently (Roary needs GFF3 from the same annotator). Record the exact assembly accessions in `metadata/accessions/pangenome_genomes.tsv`.

```bash
for g in data/genomes_pangenome/*.fasta; do
  name=$(basename "$g" .fasta)
  prokka --kingdom Bacteria --genus Bacillus --species nitratireducens \
    --prefix "$name" --outdir results/prokka/"$name" \
    --cpus <threads> "$g"
done
```

**Reported outcome (LABIM53):** 5,718 CDS, 5 rRNA, 42 tRNA, 1 tmRNA.

## 4.2 Pan-genome — Roary → **Fig 3A**

```bash
roary -e --mafft -p <threads> \
  -f results/roary \
  results/prokka/*/*.gff
```

**Reported outcome (15 genomes = 14 public + LABIM53):** 12,047 gene clusters —
3,513 core, 3,558 accessory, 4,976 strain-specific.

The three reported categories sum to 12,047, so this is the single value used throughout the repository. It remains **pending confirmation against the original Roary output**, which is not version-controlled. After restoring `results/roary/gene_presence_absence.csv`, run:

```bash
python scripts/validate_pangenome_counts.py
```

The gene presence/absence matrix (with the accompanying tree) is **Figure 3A**.
To render the tree + matrix figure, Roary ships `roary_plots.py`:

```bash
python roary_plots.py results/roary/accessory_binary_genes.fa.newick \
  results/roary/gene_presence_absence.csv
```

## 4.3 Functional categories — COGclassifier → **Fig 3B**

Run on the LABIM53 protein FASTA (e.g. Prokka `LABIM53.faa`):

```bash
COGclassifier -i results/prokka/LABIM53/LABIM53.faa \
  -o results/cogclassifier_LABIM53
```

Produces the per-category counts plotted in **Figure 3B** (single-letter COG codes J, A, K, … S).

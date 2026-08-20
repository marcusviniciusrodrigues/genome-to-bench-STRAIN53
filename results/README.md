# results/

Outputs are **not** version-controlled. Each stage writes here:

| Stage | Output |
| --- | --- |
| 1 | `trimmed/LABIM53/`, `spades_LABIM53/` |
| 2 | `gtdbtk_LABIM53/`, `aniclustermap/`, `markers/`, `trees/` |
| 3 | `medusa_LABIM53.fasta`, `ragtag_LABIM53/`, `quast_LABIM53/`, BUSCO output |
| 4 | `prokka/`, `roary/`, `cogclassifier_LABIM53/` |
| 5 | `blastdb/`, `tblastn_LABIM53.tsv` |

Keep large intermediate outputs here. Final manuscript assets and their provenance belong in the version-controlled top-level `figures/` and `tables/` directories.

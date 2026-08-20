# Metadata and verification status

This directory contains the version-controlled evidence layer for the workflow.
It is intentionally separate from large sequence and result files.

- `pgpr_gene_targets.tsv` connects each gene-mining target to its UniProt source,
  biological evidence, expected mechanism, validation assay and manuscript link.
- `accessions/` records the exact assemblies and sequences used in each analysis.
- `reported_results.yaml` distinguishes reported values from independently
  validated values.
- `repository_settings.yaml` records the description and topics to apply in the
  GitHub interface after the repository migration.

`TO_CONFIRM` is a blocking publication marker, not missing-value shorthand.
Replace every occurrence from the original analysis records before submission.


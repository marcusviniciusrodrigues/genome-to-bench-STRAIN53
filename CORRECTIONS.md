# Correction implementation record

This file maps the revised priority list to the repository changes. It records
what is complete and what still requires original analysis material or a remote
GitHub action.

| Priority item | Repository implementation | Status |
| --- | --- | --- |
| Move GitHub to final location | Intentionally not performed; migration is being handled manually. The quick-start clone command uses `<final-repository-url>`. | Excluded by owner |
| Standardise strain name | Replaced the former strain label with LABIM53 across documentation, scripts, configuration, metadata and example paths. | Complete |
| Align reproducibility claim | README now describes workflow documentation and command templates, with explicit verification boundaries. | Complete |
| Concatenated 16S + *gyrB* phylogeny | Added deterministic concatenation, shared FASTA/NEXUS output, IQ-TREE and MrBayes routing, and taxon-set checks. | Complete; original model/MCMC settings require confirmation |
| Figure 4 panel labels | Fixed A = NBRIP/phosphate and B = Aleksandrov/potassium in docs and figure manifest. | Complete; final figure asset missing |
| PlasFlow wording and counts | Replaced definitive replicon language with predicted-class wording and recorded 36 submitted scaffolds. | Wording complete; Table 1/source output required for class counts |
| Pan-genome count | Standardised on the internally consistent reported total of 12,047 and added an output validator. | Consistency complete; original Roary CSV required for confirmation |
| dDDH inconsistency | Explicitly excluded dDDH from the supported workflow because no method or output was supplied. | Repository complete; unsupported manuscript claim must be removed |
| Gene-mining metadata | Added the required target/evidence/assay schema and linked accessions. | Structure complete; `TO_CONFIRM` values require original records |
| Accession lists | Added manifests for circular comparison, pan-genome, ANI/phylogeny, markers and UniProt targets. | Structure complete; comparison accessions require original records |
| Figure/table provenance | Added version-controlled directories, manifests, fixed panel definitions and validation requirements. | Structure complete; final assets missing |
| Configuration layer | Added `config/config.yaml`, `config/samples.tsv` and shared readers; removed focal-sample hard-coding from stage scripts. | Complete |
| Repository polish | Applied British English, corrected the MIT statement, expanded `CITATION.cff`, and prepared repository metadata and a changelog. | Local changes complete; remote description/topics and release require GitHub actions |

No value marked `TO_CONFIRM` or `asset_missing` should be presented as verified
in the manuscript or a public release.

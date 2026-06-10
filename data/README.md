# data/

Inputs are **not** version-controlled (see `.gitignore`). Recreate this layout:

```
data/
├── reads/                     # paired-end Illumina reads (BioProject PRJNA1114765)
│   ├── STRAIN53_R1.fastq.gz
│   └── STRAIN53_R2.fastq.gz
├── reference_genomes/         # closest complete genome for scaffolding
│   └── B_nitratireducens_BM02.fasta
├── genomes_cereus_group/      # B. cereus-group genomes for ANIclustermap (Fig 2A)
├── genomes_pangenome/         # 14 public B. nitratireducens genomes + STRAIN53 (Fig 3A)
├── markers/                   # 16S rRNA and gyrB sequences extracted from genomes
│   ├── 16S.fasta
│   └── gyrB.fasta
└── mined_genes/               # PGPR target proteins from UniProt
    └── pgpr_targets.faa
```

Genomes are downloaded from GenBank (Sayers et al., 2020). Keep accession lists here for traceability.

# 01 — Preprocessing & Assembly

**Goal:** trim raw Illumina reads and assemble draft contigs.
**Tools:** Trimmomatic v0.39, SPAdes v3.13.

## 1.1 Read trimming — Trimmomatic v0.39

Per the Methods: low-quality bases and adapters removed with a **Phred quality cutoff of 30**.

```bash
trimmomatic PE -phred33 \
  data/reads/LABIM53_R1.fastq.gz data/reads/LABIM53_R2.fastq.gz \
  results/trimmed/LABIM53/LABIM53_R1.paired.fq.gz results/trimmed/LABIM53/LABIM53_R1.unpaired.fq.gz \
  results/trimmed/LABIM53/LABIM53_R2.paired.fq.gz results/trimmed/LABIM53/LABIM53_R2.unpaired.fq.gz \
  ILLUMINACLIP:<adapters.fa>:2:30:10 \
  SLIDINGWINDOW:4:30 \
  LEADING:30 TRAILING:30 MINLEN:36
```

- The Q30 cutoff is the parameter stated in the paper. Window size, `MINLEN`, and the adapter FASTA are standard choices — adjust to your library/adapters.

## 1.2 De novo assembly — SPAdes v3.13

```bash
spades.py \
  -1 results/trimmed/LABIM53/LABIM53_R1.paired.fq.gz \
  -2 results/trimmed/LABIM53/LABIM53_R2.paired.fq.gz \
  -o results/spades_LABIM53 \
  --careful -t <threads> -m <memory_GB>
```

**Reported outcome:** the initial SPAdes assembly comprised **425 contigs** (later refined — see stage 3).

The primary output is `results/spades_LABIM53/contigs.fasta`, which is the input to taxonomic identification (stage 2) and refinement (stage 3). The runnable script obtains these paths from `config/config.yaml` and `config/samples.tsv`.

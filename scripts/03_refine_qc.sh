#!/usr/bin/env bash
# Stage 3 — RagTag + QUAST + BUSCO (MeDuSa Java, Proksee/CLC/PlasFlow are separate/web/GUI)
set -euo pipefail
THREADS=${THREADS:-8}
REF=data/reference_genomes/B_nitratireducens_BM02.fasta
mkdir -p results/quast_STRAIN53

# (MeDuSa first — see docs/03; produces results/medusa_STRAIN53.fasta)
ragtag.py scaffold "$REF" results/medusa_STRAIN53.fasta -o results/ragtag_STRAIN53
ASM=results/ragtag_STRAIN53/ragtag.scaffold.fasta

quast.py "$ASM" -o results/quast_STRAIN53 -t "$THREADS"
busco -i "$ASM" -m genome -l bacillales_odb10 -o STRAIN53_busco -c "$THREADS"
echo "[done] stage 3"

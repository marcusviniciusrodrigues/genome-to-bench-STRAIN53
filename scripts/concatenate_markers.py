#!/usr/bin/env python3
"""Concatenate aligned marker FASTA files by sequence identifier.

The same concatenated alignment is written as FASTA for IQ-TREE and as NEXUS
for MrBayes. All marker alignments must contain exactly the same sequence IDs.
"""

from __future__ import annotations

import argparse
import re
from collections import OrderedDict
from pathlib import Path


def read_fasta(path: Path) -> OrderedDict[str, str]:
    records: OrderedDict[str, str] = OrderedDict()
    current: str | None = None
    parts: list[str] = []
    for raw in path.read_text(encoding="utf-8").splitlines():
        line = raw.strip()
        if not line:
            continue
        if line.startswith(">"):
            if current is not None:
                records[current] = "".join(parts)
            current = line[1:].split()[0]
            if not current or current in records:
                raise ValueError(f"Invalid or duplicate FASTA ID in {path}: {current!r}")
            parts = []
        elif current is None:
            raise ValueError(f"Sequence before first header in {path}")
        else:
            parts.append(line)
    if current is not None:
        records[current] = "".join(parts)
    if not records:
        raise ValueError(f"No FASTA records found in {path}")
    lengths = {len(sequence) for sequence in records.values()}
    if len(lengths) != 1:
        raise ValueError(f"Alignment contains unequal sequence lengths: {path}")
    return records


def nexus_id(value: str) -> str:
    return re.sub(r"[^A-Za-z0-9_.-]", "_", value)


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--alignment",
        action="append",
        required=True,
        metavar="NAME=PATH",
        help="Aligned marker FASTA; repeat in concatenation order",
    )
    parser.add_argument("--fasta-out", required=True)
    parser.add_argument("--nexus-out", required=True)
    parser.add_argument("--mrbayes-nst", type=int, default=6)
    parser.add_argument("--mrbayes-rates", default="gamma")
    parser.add_argument("--mrbayes-generations", type=int, default=1_000_000)
    parser.add_argument("--mrbayes-sample-frequency", type=int, default=1_000)
    parser.add_argument("--mrbayes-burnin-fraction", type=float, default=0.25)
    args = parser.parse_args()

    markers: list[tuple[str, OrderedDict[str, str]]] = []
    for item in args.alignment:
        if "=" not in item:
            raise SystemExit(f"Expected NAME=PATH, received: {item}")
        name, raw_path = item.split("=", 1)
        markers.append((nexus_id(name), read_fasta(Path(raw_path))))

    expected_ids = list(markers[0][1])
    expected_set = set(expected_ids)
    for name, records in markers[1:]:
        if set(records) != expected_set:
            missing = sorted(expected_set - set(records))
            extra = sorted(set(records) - expected_set)
            raise SystemExit(
                f"Marker {name} has mismatched sequence IDs; missing={missing}, extra={extra}"
            )

    concatenated = {
        seq_id: "".join(records[seq_id] for _, records in markers)
        for seq_id in expected_ids
    }
    fasta_out = Path(args.fasta_out)
    nexus_out = Path(args.nexus_out)
    fasta_out.parent.mkdir(parents=True, exist_ok=True)
    nexus_out.parent.mkdir(parents=True, exist_ok=True)
    with fasta_out.open("w", encoding="utf-8", newline="\n") as handle:
        for seq_id in expected_ids:
            handle.write(f">{seq_id}\n{concatenated[seq_id]}\n")

    partitions: list[tuple[str, int, int]] = []
    start = 1
    for name, records in markers:
        length = len(next(iter(records.values())))
        partitions.append((name, start, start + length - 1))
        start += length

    ntax = len(expected_ids)
    nchar = len(next(iter(concatenated.values())))
    with nexus_out.open("w", encoding="utf-8", newline="\n") as handle:
        handle.write("#NEXUS\n\nbegin data;\n")
        handle.write(f"  dimensions ntax={ntax} nchar={nchar};\n")
        handle.write("  format datatype=dna missing=? gap=-;\n  matrix\n")
        for seq_id in expected_ids:
            handle.write(f"  {nexus_id(seq_id)}  {concatenated[seq_id]}\n")
        handle.write("  ;\nend;\n\nbegin mrbayes;\n")
        for name, left, right in partitions:
            handle.write(f"  charset {name} = {left}-{right};\n")
        names = ", ".join(name for name, _, _ in partitions)
        handle.write(f"  partition markers = {len(partitions)}: {names};\n")
        handle.write("  set partition=markers;\n")
        handle.write(
            f"  lset applyto=(all) nst={args.mrbayes_nst} "
            f"rates={args.mrbayes_rates};\n"
        )
        handle.write(
            f"  mcmcp ngen={args.mrbayes_generations} "
            f"samplefreq={args.mrbayes_sample_frequency} "
            f"printfreq={args.mrbayes_sample_frequency} "
            f"diagnfreq={args.mrbayes_sample_frequency} nchains=4;\n"
        )
        handle.write("  mcmc;\n")
        handle.write(f"  sump burninfrac={args.mrbayes_burnin_fraction};\n")
        handle.write(f"  sumt burninfrac={args.mrbayes_burnin_fraction};\n")
        handle.write("end;\n")

    print(f"Wrote {ntax} taxa x {nchar} sites to {fasta_out} and {nexus_out}")


if __name__ == "__main__":
    main()


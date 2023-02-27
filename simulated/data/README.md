
## Requirements

* Trans-NanoSim v3.1.0 : https://github.com/bcgsc/NanoSim

## Download our simulated data

Download the simulated data from Dryad:

https://datadryad.org/stash/landing/show?id=doi%3A10.5061%2Fdryad.cc2fqz68w

There are 2 directories containing simulated cDNA and direct RNA reads:
```
├── mouse_cdna
│   ├── extract_reads.sh
│   ├── sample.10M.read_names.txt.gz
│   ├── sample.10M_transcripts.txt
│   ├── sample.18M.read_names.txt.gz
│   ├── sample.18M_transcripts.txt
│   ├── sample.2M.read_names.txt.gz
│   ├── sample.2M_transcripts.txt
│   └── sim25M_aligned_reads.fastq.gz
├── mouse_drna
│   ├── extract_reads.sh
│   ├── sample.10M.read_names.txt.gz
│   ├── sample.10M_transcripts.txt
│   ├── sample.18M.read_names.txt.gz
│   ├── sample.18M_transcripts.txt
│   ├── sample.2M.read_names.txt.gz
│   ├── sample.2M_transcripts.txt
│   └── sim25M_aligned_reads.fastq.gz
└── NOTE.txt
```

FASTQ file containing simulated reads from Trans-NanoSim:
```
sim25M_aligned_reads.fastq.gz
```

Text files containing the transcript IDs in each sample:
```
sample.18M_transcripts.txt
sample.10M_transcripts.txt
sample.12M_transcripts.txt
```

Bash script to extract the FASTQ files for all 3 samples:
```
bash extract_reads.sh
```

## Alternatively, simulate reads yourself with Trans-NanoSim

Configure file paths in `cdna/transnanosim.sh` and `drna/transnanosim.sh` and run:

```
cd cdna
bash transnanosim.sh
```

```
cd drna
bash transnanosim.sh
```


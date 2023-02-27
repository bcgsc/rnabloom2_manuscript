
## Requirements

* Porechop : https://github.com/rrwick/Porechop

## Download Illumina reads

Download all FASTQ files for PRJNA398042 from NCBI:

https://www.ncbi.nlm.nih.gov/bioproject/?term=PRJNA398042

There should be a total of 24 pairs of FASTQ files.

## Download raw ONT reads

Download the FASTQ file for SRR19510936 from NCBI:

https://trace.ncbi.nlm.nih.gov/Traces/index.html?view=run_browser&acc=SRR19510936&display=data-access

## Set up Porechop

Add these adapters to Porechop:

```
           Adapter('oligo-dTVN',
                    start_sequence=('oligo-dTVN', 'TATCAACGCAGAGTACTTTT'),
                    end_sequence=('oligo-dTVN_rev', 'AAAAGTACTCTGCGTTGATA')),
           Adapter('TSO',
                    start_sequence=('TSO', 'TATCAACGCAGAGTACGGG'),
                    end_sequence=('TSO_rev', 'CCCGTACTCTGCGTTGATA')),
```

## Trim adapters in ONT reads

Configure file paths in the bash script `trim_adapters.sh` and run:

```
bash trim_adapters.sh
```


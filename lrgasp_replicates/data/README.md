
## Download read files

FASTQ files can be downloaded from https://www.encodeproject.org/search/?type=Experiment&internal_tags=LRGASP

| platform   | file accessions                       |
|------------|---------------------------------------| 
| ONT cDNA   | ENCFF232YSU, ENCFF288PBL, ENCFF683TBO |
| ONT dRNA   | ENCFF349BIN, ENCFF412NKJ, ENCFF765AEC |
| PacBio CCS | ENCFF313VYZ, ENCFF667VXS, ENCFF874VSI |
| Illumina   | ENCFF696TCH, ENCFF751FTE              |

## Trim adapters for ONT cDNA reads

### Requirements

* Pychopper : https://github.com/nanoporetech/pychopper

Set up paths in `pychopper.sh` and run:

```
bash pychopper.sh
```

## Trim adapters for Illumina reads

* Trimmomatic v0.39 : https://github.com/usadellab/Trimmomatic

Set up paths in `trimmomatic.sh` and run:

```
bash trimmomatic.sh
```


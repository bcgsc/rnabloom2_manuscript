set -euo pipefail

# set up paths
rnabloom_jar=/path/to/RNA-Bloom.jar
cdna_reads=$(realpath ../../data/mouse_cdna/sample.2M.fastq)
drna_reads=$(realpath ../../data/mouse_drna/sample.2M.fastq)

# sanity checks
ls -1 ${cdna_reads} ${drna_reads}
which isONclust run_isoncorrect

topdir=${PWD}


# process cDNA simulated reads
cd ${topdir}
outdir=${topdir}/cdna_2M
mkdir -p ${outdir}
cd ${outdir}

isONclust --t 48 --ont --fastq ${cdna_reads} --outfolder ./clustering --consensus

isONclust write_fastq --N 1 --clusters ./clustering/final_clusters.tsv \
    --fastq ${cdna_reads} --outfolder ./clustering/fastq_files

run_isoncorrect --t 48 --fastq_folder ./clustering/fastq_files \
    --outfolder ./correction/ 

touch OUTPUT.fastq
OUTFILES="./correction/"*"/corrected_reads.fastq"
for f in $OUTFILES
do 
  echo $f
  cat $f >> OUTPUT.fastq
done

seqtk seq -L 150 -A OUTPUT.fastq > assembly_ge150.fa


# process dRNA simulated reads
cd ${topdir}
outdir=${topdir}/drna_2M
mkdir -p ${outdir}
cd ${outdir}

isONclust --t 48 --ont --fastq ${drna_reads} --outfolder ./clustering --consensus

isONclust write_fastq --N 1 --clusters ./clustering/final_clusters.tsv \
    --fastq ${drna_reads} --outfolder ./clustering/fastq_files

run_isoncorrect --t 48 --fastq_folder ./clustering/fastq_files \
    --outfolder ./correction/ 

touch OUTPUT.fastq
OUTFILES="./correction/"*"/corrected_reads.fastq"
for f in $OUTFILES
do 
  echo $f
  cat $f >> OUTPUT.fastq
done

seqtk seq -L 150 -A OUTPUT.fastq > assembly_ge150.fa


set -euo pipefail

# set up paths
rnabloom_jar=/path/to/RNA-Bloom.jar
cdna_reads=$(realpath ../../data/mouse_cdna/sample.2M.fastq)
drna_reads=$(realpath ../../data/mouse_drna/sample.2M.fastq)

# sanity checks
ls -1 ${cdna_reads} ${drna_reads}
ls ${rnabloom_jar}
which java ntcard minimap2 racon seqtk

topdir=${PWD}


# assemble cDNA simulated reads
cd ${topdir}
outdir=${topdir}/cdna_2M
mkdir -p ${outdir}
cd ${outdir}

java -Xmx150g -jar ${rnabloom_jar} -t 48 -outdir ${outdir} -long ${cdna_reads} -fpr 0.005 -overlap 200 -length 150 -lrop 0.7 -p 0.7 -lrrd 1

seqtk seq -L 150 -A rnabloom.transcripts.fa > assembly_ge150.fa


# assemble dRNA simulated reads
cd ${topdir}
outdir=${topdir}/drna_2M
mkdir -p ${outdir}
cd ${outdir}

java -Xmx150g -jar ${rnabloom_jar} -t 48 -outdir ${outdir} -long ${drna_reads} -fpr 0.005 -overlap 200 -length 150 -lrop 0.7 -p 0.7 -lrrd 1 -stranded

seqtk seq -L 150 -A rnabloom.transcripts.fa > assembly_ge150.fa


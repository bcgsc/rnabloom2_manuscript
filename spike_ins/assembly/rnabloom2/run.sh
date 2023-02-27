set -euo pipefail

# set up paths
ont_cdna_reads=$(realpath ../../data/ont_cdna_sirv_ercc.fastq)
ont_drna_reads=$(realtpath ../../data/ont_drna_sirv_ercc.fastq)
pacbio_ccs_reads=$(realpath ../../data/pacbio_ccs_sirv_ercc.fastq)
rnabloom_jar=/path/to/RNA-Bloom.jar

# sanity checks
ls -1 ${ont_cdna_reads} ${ont_drna_reads} ${pacbio_ccs_reads}
ls ${rnabloom_jar}
which java ntcard minimap2 racon seqtk

topdir=${PWD}


# assemble ONT cDNA reads

outdir=${topdir}/ont_cdna
mkdir -p ${outdir}
cd ${outdir}

java -Xmx150g -jar ${rnabloom_jar} -t 48 -outdir ${outdir} -long ${ont_cdna_reads} -fpr 0.005 -overlap 200 -length 150 -lrop 0.7 -p 0.7 -lrrd 3

seqtk seq -L 150 -A rnabloom.transcripts.fa > assembly_ge150.fa


# assemble ONT dRNA reads

outdir=${topdir}/ont_drna
mkdir -p ${outdir}
cd ${outdir}

java -Xmx150g -jar ${rnabloom_jar} -t 48 -outdir ${outdir} -long ${ont_drna_reads} -fpr 0.005 -overlap 200 -length 150 -lrop 0.7 -p 0.7 -lrrd 3 -stranded

seqtk seq -L 150 -A rnabloom.transcripts.fa > assembly_ge150.fa


# assemble PacBio CCS reads

outdir=${topdir}/pacbio_ccs
mkdir -p ${outdir}
cd ${outdir}

java -Xmx150g -jar ${rnabloom_jar} -t 48 -outdir ${outdir} -long ${pacbio_ccs_reads} -fpr 0.005 -overlap 200 -length 150 -lrop 0.7 -p 0.7 -lrrd 3 -lrpb

seqtk seq -L 150 -A rnabloom.transcripts.fa > assembly_ge150.fa


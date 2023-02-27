set -euo pipefail

# set up paths
ont_cdna_reads=$(realpath ../../data/ENCFF232YSU_pychopper_fulllength_rescued.fastq)
ont_drna_reads=$(realpath ../../data/ENCFF349BIN.fastq)
pacbio_ccs_reads=$(realpath ../../data/ENCFF313VYZ.fastq)
illumina_reads1=$(realpath ../../data/ENCLB588OJP_trimmomatic_pe_1.fastq)
illumina_reads2=$(realpath ../../data/ENCLB588OJP_trimmomatic_pe_2.fastq)
rnabloom_jar=/path/to/RNA-Bloom.jar

# sanity checks
ls -1 ${ont_cdna_reads} ${ont_drna_reads} ${pacbio_ccs_reads} ${illumina_reads1} ${illumina_reads2}
ls ${rnabloom_jar}
which java ntcard minimap2 racon

topdir=${PWD}


# assemble ONT cDNA replicates
cd ${topdir}
outdir=${topdir}/ont_cdna_long
mkdir -p ${outdir}
cd ${outdir}

java -Xmx150g -jar ${rnabloom_jar} -t 48 -outdir ${outdir} -long ${ont_cdna_reads} -fpr 0.005 -overlap 200 -length 150 -lrop 0.7 -p 0.7 -lrrd 3


# assemble ONT dRNA replicates
cd ${topdir}
outdir=${topdir}/ont_drna_long
mkdir -p ${outdir}
cd ${outdir}

java -Xmx150g -jar ${rnabloom_jar} -t 48 -outdir ${outdir} -long ${ont_drna_reads} -fpr 0.005 -overlap 200 -length 150 -lrop 0.7 -p 0.7 -lrrd 3 -stranded


# assemble PacBio CCS reads
cd ${topdir}  
outdir=${topdir}/pacbio_ccs_long
mkdir -p ${outdir}
cd ${outdir}

java -Xmx150g -jar ${rnabloom_jar} -t 48 -outdir ${outdir} -long ${pacbio_ccs_reads} -fpr 0.005 -overlap 200 -length 150 -lrop 0.7 -p 0.7 -lrrd 3 -lrpb


# assemble ONT cDNA replicates
cd ${topdir}
outdir=${topdir}/ont_cdna_hybrid
mkdir -p ${outdir}
cd ${outdir}

java -Xmx150g -jar ${rnabloom_jar} -t 48 -outdir ${outdir} -long ${ont_cdna_reads} -fpr 0.005 -overlap 200 -length 150 -lrop 0.7 -p 0.7 -lrrd 3 -sef ${illumina_reads1} ${illumina_reads2}


# assemble ONT dRNA replicates
cd ${topdir}
outdir=${topdir}/ont_drna_hybrid
mkdir -p ${outdir}
cd ${outdir}

java -Xmx150g -jar ${rnabloom_jar} -t 48 -outdir ${outdir} -long ${ont_drna_reads} -fpr 0.005 -overlap 200 -length 150 -lrop 0.7 -p 0.7 -lrrd 3 -stranded -sef ${illumina_reads2} -ser ${illumina_reads1}


# assemble PacBio CCS reads
cd ${topdir}  
outdir=${topdir}/pacbio_ccs_hybrid
mkdir -p ${outdir}
cd ${outdir}

java -Xmx150g -jar ${rnabloom_jar} -t 48 -outdir ${outdir} -long ${pacbio_ccs_reads} -fpr 0.005 -overlap 200 -length 150 -lrop 0.7 -p 0.7 -lrrd 3 -lrpb -sef ${illumina_reads1} ${illumina_reads2}


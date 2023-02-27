set -euo pipefail

# set up paths
ont_cdna_reads=../../lrgasp_replicates/data/{ENCFF232YSU,ENCFF288PBL,ENCFF683TBO}_pychopper_fulllength_rescued.fastq
ont_drna_reads=../../lrgasp_replicates/data/{ENCFF349BIN,ENCFF412NKJ,ENCFF765AEC}.fastq
pacbio_ccs_reads=../../lrgasp_replicates/data/{ENCFF313VYZ,ENCFF667VXS,ENCFF874VSI}.fastq
rnabloom_jar=/path/to/RNA-Bloom.jar

# sanity checks
ls -1 ${ont_cdna_reads} ${ont_drna_reads} ${pacbio_ccs_reads}
ls ${rnabloom_jar}
which java ntcard minimap2 racon seqtk

topdir=${PWD}


# assemble ONT cDNA replicates
for replicate in ENCFF232YSU ENCFF288PBL ENCFF683TBO
do
  cd ${topdir}
  reads=$(realpath ../../lrgasp_replicates/data/${replicate}_pychopper_fulllength_rescued.fastq)
  
  outdir=${topdir}/${replicate}
  mkdir -p ${outdir}
  cd ${outdir}

  java -Xmx150g -jar ${rnabloom_jar} -t 48 -outdir ${outdir} -long ${reads} -fpr 0.005 -overlap 200 -length 150 -lrop 0.7 -p 0.7 -lrrd 3

  seqtk seq -L 150 -A rnabloom.transcripts.fa > assembly_ge150.fa
done

# assemble ONT dRNA replicates
for replicate in ENCFF349BIN ENCFF412NKJ ENCFF765AEC
do
  cd ${topdir}
  reads=$(realpath ../../lrgasp_replicates/data/${replicate}.fastq)

  outdir=${topdir}/${replicate}
  mkdir -p ${outdir}
  cd ${outdir}

  java -Xmx150g -jar ${rnabloom_jar} -t 48 -outdir ${outdir} -long ${reads} -fpr 0.005 -overlap 200 -length 150 -lrop 0.7 -p 0.7 -lrrd 3 -stranded

  seqtk seq -L 150 -A rnabloom.transcripts.fa > assembly_ge150.fa
done

# assemble PacBio CCS reads
for replicate in ENCFF313VYZ ENCFF667VXS ENCFF874VSI
do
  cd ${topdir}
  reads=$(realpath ../../lrgasp_replicates/data/${replicate}.fastq)
  
  outdir=${topdir}/${replicate}
  mkdir -p ${outdir}
  cd ${outdir}

  java -Xmx150g -jar ${rnabloom_jar} -t 48 -outdir ${outdir} -long ${reads} -fpr 0.005 -overlap 200 -length 150 -lrop 0.7 -p 0.7 -lrrd 3 -lrpb

  seqtk seq -L 150 -A rnabloom.transcripts.fa > assembly_ge150.fa
done


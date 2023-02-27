set -euo pipefail

# set up paths
rnabloom_jar=/path/to/RNA-Bloom.jar

# sanity checks
ls -1 ../../data/mouse_{cdna,drna}/sample.{2,10,18}M.fastq
ls ${rnabloom_jar}
which java ntcard minimap2 racon seqtk

topdir=${PWD}

# assemble cDNA simulated reads
protocol=cdna
for n in 2 10 18
do
  cd ${topdir}

  reads=$(realpath ../../data/mouse_${protocol}/sample.${n}M.fastq)

  outdir=${topdir}/${protocol}_${n}M
  mkdir -p ${outdir}
  cd ${outdir}

  java -Xmx150g -jar ${rnabloom_jar} -t 48 -outdir ${outdir} -long ${reads} -fpr 0.005 -overlap 200 -length 150 -lrop 0.7 -p 0.7 -lrrd 3

  seqtk seq -L 150 -A rnabloom.transcripts.fa > assembly_ge150.fa
done

# assemble dRNA simulated reads
protocol=drna
for n in 2 10 18
do
  cd ${topdir}

  reads=$(realpath ../../data/mouse_${protocol}/sample.${n}M.fastq)

  outdir=${topdir}/${protocol}_${n}M
  mkdir -p ${outdir}
  cd ${outdir}

  java -Xmx150g -jar ${rnabloom_jar} -t 48 -outdir ${outdir} -long ${reads} -fpr 0.005 -overlap 200 -length 150 -lrop 0.7 -p 0.7 -lrrd 3 -stranded

  seqtk seq -L 150 -A rnabloom.transcripts.fa > assembly_ge150.fa
done


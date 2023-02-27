set -euo pipefail

# set up paths
ont_cdna_reads=../../data/{ENCFF232YSU,ENCFF288PBL,ENCFF683TBO}_pychopper_fulllength_rescued.fastq
ont_drna_reads=../../data/{ENCFF349BIN,ENCFF412NKJ,ENCFF765AEC}.fastq
pacbio_ccs_reads=../../data/{ENCFF313VYZ,ENCFF667VXS,ENCFF874VSI}.fastq

# sanity checks
ls -1 ${ont_cdna_reads} ${ont_drna_reads} ${pacbio_ccs_reads}
which rattle

topdir=${PWD}


# assemble ONT cDNA replicates
for replicate in ENCFF232YSU ENCFF288PBL ENCFF683TBO
do
  cd ${topdir}
  reads=$(realpath ../../data/${replicate}_pychopper_fulllength_rescued.fastq)

  outdir=${topdir}/${replicate}
  mkdir -p ${outdir}
  cd ${outdir}

  rattle cluster -i ${reads} -t 48 -o ${outdir} --iso
  rattle cluster_summary -i ${reads} -c ${outdir}/clusters.out > ${outdir}/cluster_summary.tsv
  mkdir ${outdir}/clusters
  rattle extract_clusters -i ${reads} -c ${outdir}/clusters.out -o ${outdir}/clusters --fastq
  rattle correct -i ${reads} -c ${outdir}/clusters.out -o ${outdir} -t 48 -r 3
  rattle polish -i ${outdir}/consensi.fq -o ${outdir} -t 48
  
  seqtk seq -L 150 -A transcriptome.fq > assembly_ge150.fa
done

# assemble ONT dRNA replicates
for replicate in ENCFF349BIN ENCFF412NKJ ENCFF765AEC
do
  cd ${topdir}
  reads=$(realpath ../../data/${replicate}.fastq)
  
  outdir=${topdir}/${replicate}
  mkdir -p ${outdir}
  cd ${outdir}

  rattle cluster -i ${reads} -t 48 -o ${outdir} --iso --rna
  rattle cluster_summary -i ${reads} -c ${outdir}/clusters.out > ${outdir}/cluster_summary.tsv
  mkdir ${outdir}/clusters
  rattle extract_clusters -i ${reads} -c ${outdir}/clusters.out -o ${outdir}/clusters --fastq
  rattle correct -i ${reads} -c ${outdir}/clusters.out -o ${outdir} -t 48 -r 3
  rattle polish -i ${outdir}/consensi.fq -o ${outdir} -t 48 --rna

  seqtk seq -L 150 -A transcriptome.fq > assembly_ge150.fa
done

# assemble PacBio CCS replicates
for replicate in ENCFF313VYZ ENCFF667VXS ENCFF874VSI
do
  cd ${topdir}
  reads=$(realpath ../../data/${replicate}.fastq)
  
  outdir=${topdir}/${replicate}
  mkdir -p ${outdir}
  cd ${outdir}

  rattle cluster -i ${reads} -t 48 -o ${outdir}
  rattle cluster_summary -i ${reads} -c ${outdir}/clusters.out > ${outdir}/cluster_summary.tsv
  mkdir ${outdir}/clusters
  rattle extract_clusters -i ${reads} -c ${outdir}/clusters.out -o ${outdir}/clusters --fastq
  rattle correct -i ${reads} -c ${outdir}/clusters.out -o ${outdir} -t 48 -r 3
  rattle polish -i ${outdir}/consensi.fq -o ${outdir} -t 48
  
  seqtk seq -L 150 -A transcriptome.fq > assembly_ge150.fa
done


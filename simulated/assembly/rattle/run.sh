set -euo pipefail

# sanity checks
ls -1 ../../data/mouse_{cdna,drna}/sample.{2,10,18}M.fastq
which rattle

topdir=${PWD}

# run RATTLE for 2, 10, 18 million cDNA simulated reads
protocol=cdna
for n in 2 10 18
do
  cd ${topdir}
    
  reads=$(realpath ../../data/mouse_${protocol}/sample.${n}M.fastq)
    
  outdir=${topdir}/${protocol}_${n}M
  mkdir -p ${outdir}
  cd ${outdir}
    
  rattle cluster -i ${reads} -t 48 -o ${outdir} --iso
  rattle cluster_summary -i ${reads} -c ${outdir}/clusters.out > ${outdir}/cluster_summary.tsv

  mkdir ${outdir}/clusters
  rattle extract_clusters -i ${reads} -c ${outdir}/clusters.out -o ${outdir}/clusters --fastq

  rattle correct -i ${reads} -c ${outdir}/clusters.out -o ${outdir} -t 48 -r 3
  rattle polish -i ${outdir}/consensi.fq -o ${outdir} -t 48
done

# run RATTLE for 2, 10, 18 million dRNA simulated reads
protocol=drna
for n in 2 10 18
do
  cd ${topdir}
    
  reads=$(realpath ../../data/mouse_${protocol}/sample.${n}M.fastq)
    
  outdir=${topdir}/${protocol}_${n}M
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


set -euo pipefail

# set up file paths
reads=/path/to/porechop.fastq
outdir=/path/to/output/directory

# sanity checks
ls ${reads}
ls -d ${outdir}
which rattle

# run RATTLE

rattle cluster -i ${reads} -t 48 -o ${outdir} --iso

rattle cluster_summary -i ${reads} -c ${outdir}/clusters.out > ${outdir}/cluster_summary.tsv

mkdir ${outdir}/clusters
rattle extract_clusters -i ${reads} -c ${outdir}/clusters.out -o ${outdir}/clusters --fastq

rattle correct -i ${reads} -c ${outdir}/clusters.out -o ${outdir} -t 48 -r 2

rattle polish -i ${outdir}/consensi.fq -o ${outdir} -t 48


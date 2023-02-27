set -euo pipefail

# set up paths
ont_cdna_reads=$(realpath ../../data/ont_cdna_sirv_ercc.fastq)
ont_drna_reads=$(realtpath ../../data/ont_drna_sirv_ercc.fastq)
pacbio_ccs_reads=$(realpath ../../data/pacbio_ccs_sirv_ercc.fastq)

# sanity checks
ls -1 ${ont_cdna_reads} ${ont_drna_reads} ${pacbio_ccs_reads}
which rattle

topdir=${PWD}


# assemble ONT cDNA reads

outdir=${topdir}/ont_cdna
mkdir -p ${outdir}
cd ${outdir}

rattle cluster -i ${ont_cdna_reads} -t 48 -o ${outdir} --iso
rattle cluster_summary -i ${ont_cdna_reads} -c ${outdir}/clusters.out > ${outdir}/cluster_summary.tsv
mkdir ${outdir}/clusters
rattle extract_clusters -i ${ont_cdna_reads} -c ${outdir}/clusters.out -o ${outdir}/clusters --fastq
rattle correct -i ${ont_cdna_reads} -c ${outdir}/clusters.out -o ${outdir} -t 48 -r 3
rattle polish -i ${outdir}/consensi.fq -o ${outdir} -t 48

seqtk seq -L 150 -A transcriptome.fq > assembly_ge150.fa


# assemble ONT dRNA reads

outdir=${topdir}/ont_drna
mkdir -p ${outdir}
cd ${outdir}

rattle cluster -i ${ont_drna_reads} -t 48 -o ${outdir} --iso --rna
rattle cluster_summary -i ${ont_drna_reads} -c ${outdir}/clusters.out > ${outdir}/cluster_summary.tsv
mkdir ${outdir}/clusters
rattle extract_clusters -i ${ont_drna_reads} -c ${outdir}/clusters.out -o ${outdir}/clusters --fastq
rattle correct -i ${ont_drna_reads} -c ${outdir}/clusters.out -o ${outdir} -t 48 -r 3
rattle polish -i ${outdir}/consensi.fq -o ${outdir} -t 48 --rna

seqtk seq -L 150 -A transcriptome.fq > assembly_ge150.fa


# assemble PacBio CCS reads

outdir=${topdir}/pacbio_ccs
mkdir -p ${outdir}
cd ${outdir}

rattle cluster -i ${pacbio_ccs_reads} -t 48 -o ${outdir} --iso
rattle cluster_summary -i ${pacbio_ccs_reads} -c ${outdir}/clusters.out > ${outdir}/cluster_summary.tsv
mkdir ${outdir}/clusters
rattle extract_clusters -i ${pacbio_ccs_reads} -c ${outdir}/clusters.out -o ${outdir}/clusters --fastq
rattle correct -i ${pacbio_ccs_reads} -c ${outdir}/clusters.out -o ${outdir} -t 48 -r 3
rattle polish -i ${outdir}/consensi.fq -o ${outdir} -t 48

seqtk seq -L 150 -A transcriptome.fq > assembly_ge150.fa



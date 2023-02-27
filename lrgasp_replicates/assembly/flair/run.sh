set -euo pipefail

# set up paths
ont_cdna_reads=../../data/{ENCFF232YSU,ENCFF288PBL,ENCFF683TBO}_pychopper_fulllength_rescued.fastq
ont_drna_reads=../../data/{ENCFF349BIN,ENCFF412NKJ,ENCFF765AEC}.fastq
pacbio_ccs_reads=../../data/{ENCFF313VYZ,ENCFF667VXS,ENCFF874VSI}.fastq
flair=/path/to/flair.py
reference_genome_fasta=/path/to/lrgasp_grcm39_sirvs.fasta
reference_annotation_gtf=/path/to/lrgasp_gencode_vM27_sirvs.gtf

# sanity checks
ls -1 ${ont_cdna_reads} ${ont_drna_reads} ${pacbio_ccs_reads}
ls -1 ${reference_genome_fasta} ${reference_annotation_gtf}
ls ${flair}
which python gffread

topdir=${PWD}


# assemble ONT cDNA replicates
for replicate in ENCFF232YSU ENCFF288PBL ENCFF683TBO
do
  cd ${topdir}
  reads=$(realpath ../../data/${replicate}_pychopper_fulllength_rescued.fastq)

  outdir=${topdir}/${replicate}
  mkdir -p ${outdir}
  cd ${outdir}

  flair_tmp_dir=${outdir}/tmpdir
  mkdir -p ${flair_tmp_dir}

  python ${flair} align -t 48 -g ${reference_genome_fasta} -r ${reads} -v1.3
  python ${flair} correct -t 48 -g ${reference_genome_fasta} -q flair.aligned.bed --gtf ${reference_annotation_gtf}
  python ${flair} collapse -t 48 -g ${reference_genome_fasta} -r ${reads} -q flair_all_corrected.bed --temp_dir ${flair_tmp_dir} -s 3 --gtf ${reference_annotation_gtf}

  gffread -l 150 -w assembly_ge150.fa -g ${reference_genome_fasta} flair.collapse.isoforms.gtf
  gffread -l 150 --gtf flair.collapse.isoforms.gtf > assembly_ge150.gtf
done

# assemble ONT dRNA replicates
for replicate in ENCFF349BIN ENCFF412NKJ ENCFF765AEC
do
  cd ${topdir}
  reads=$(realpath ../../data/${replicate}.fastq)

  outdir=${topdir}/${replicate}
  mkdir -p ${outdir}
  cd ${outdir}

  flair_tmp_dir=${outdir}/tmpdir
  mkdir -p ${flair_tmp_dir}

  python ${flair} align -t 48 -g ${reference_genome_fasta} -r ${reads} -v1.3 --nvrna
  python ${flair} correct -t 48 -g ${reference_genome_fasta} -q flair.aligned.bed --gtf ${reference_annotation_gtf} --nvrna
  python ${flair} collapse -t 48 -g ${reference_genome_fasta} -r ${reads} -q flair_all_corrected.bed --temp_dir ${flair_tmp_dir} -s 3 --gtf ${reference_annotation_gtf}

  gffread -l 150 -w assembly_ge150.fa -g ${reference_genome_fasta} flair.collapse.isoforms.gtf
  gffread -l 150 --gtf flair.collapse.isoforms.gtf > assembly_ge150.gtf
done

# assemble PacBio CCS replicates
for replicate in ENCFF313VYZ ENCFF667VXS ENCFF874VSI
do
  cd ${topdir}
  reads=$(realpath ../../data/${replicate}.fastq)

  outdir=${topdir}/${replicate}
  mkdir -p ${outdir}
  cd ${outdir}

  flair_tmp_dir=${outdir}/tmpdir
  mkdir -p ${flair_tmp_dir}

  python ${flair} align -t 48 -g ${reference_genome_fasta} -r ${reads} -v1.3
  python ${flair} correct -t 48 -g ${reference_genome_fasta} -q flair.aligned.bed --gtf ${reference_annotation_gtf}
  python ${flair} collapse -t 48 -g ${reference_genome_fasta} -r ${reads} -q flair_all_corrected.bed --temp_dir ${flair_tmp_dir} -s 3 --gtf ${reference_annotation_gtf}

  gffread -l 150 -w assembly_ge150.fa -g ${reference_genome_fasta} flair.collapse.isoforms.gtf
  gffread -l 150 --gtf flair.collapse.isoforms.gtf > assembly_ge150.gtf
done


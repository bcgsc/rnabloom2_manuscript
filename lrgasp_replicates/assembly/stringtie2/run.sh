set -euo pipefail

# set up paths
ont_cdna_reads=../../lrgasp_replicates/data/{ENCFF232YSU,ENCFF288PBL,ENCFF683TBO}_pychopper_fulllength_rescued.fastq
ont_drna_reads=../../lrgasp_replicates/data/{ENCFF349BIN,ENCFF412NKJ,ENCFF765AEC}.fastq
pacbio_ccs_reads=../../lrgasp_replicates/data/{ENCFF313VYZ,ENCFF667VXS,ENCFF874VSI}.fastq
reference_genome_fasta=/path/to/lrgasp_grcm39_sirvs.fasta

# sanity checks
ls -1 ${ont_cdna_reads} ${ont_drna_reads} ${pacbio_ccs_reads}
ls ${reference_genome_fasta}
which stringtie samtools gffread minimap2

topdir=${PWD}


# assemble ONT cDNA replicates
for replicate in ENCFF232YSU ENCFF288PBL ENCFF683TBO
do
  cd ${topdir}
  reads=$(realpath ../../lrgasp_replicates/data/${replicate}_pychopper_fulllength_rescued.fastq)

  outdir=${topdir}/${replicate}
  mkdir -p ${outdir}
  cd ${outdir}

  # align reads to reference genome
  minimap2 -t 48 -a -x splice ${reference_genome_fasta} ${reads} | samtools sort -T ./tmp -O bam -o aln.bam
  samtools index aln.bam

  # assembly
  stringtie -p 48 -L -c 3 -s 3 -m 150 -o assembly.gtf aln.bam

  gffread -l 150 -w assembly_ge150.fa -g ${reference_genome_fasta} assembly.gtf
  gffread -l 150 --gtf assembly.gtf | awk -F '\t' -v OFS='\t' '{if ($7 != ".") print; else {$7="+" ; print}}' > assembly_ge150.gtf
done

# assemble ONT dRNA replicates
for replicate in ENCFF349BIN ENCFF412NKJ ENCFF765AEC
do
  cd ${topdir}
  reads=$(realpath ../../lrgasp_replicates/data/${replicate}.fastq)

  outdir=${topdir}/${replicate}
  mkdir -p ${outdir}
  cd ${outdir}

  # align reads to reference genome
  minimap2 -t 48 -a -x splice ${reference_genome_fasta} ${reads} | samtools sort -T ./tmp -O bam -o aln.bam
  samtools index aln.bam

  # assembly
  stringtie -p 48 -L -c 3 -s 3 -m 150 -o assembly.gtf aln.bam

  gffread -l 150 -w assembly_ge150.fa -g ${reference_genome_fasta} assembly.gtf
  gffread -l 150 --gtf assembly.gtf | awk -F '\t' -v OFS='\t' '{if ($7 != ".") print; else {$7="+" ; print}}' > assembly_ge150.gtf
done

# assemble PacBio CCS replicates
for replicate in ENCFF313VYZ ENCFF667VXS ENCFF874VSI
do
  cd ${topdir}
  reads=$(realpath ../../lrgasp_replicates/data/${replicate}.fastq)

  outdir=${topdir}/${replicate}
  mkdir -p ${outdir}
  cd ${outdir}

  # align reads to reference genome
  minimap2 -t 48 -a -x splice ${reference_genome_fasta} ${reads} | samtools sort -T ./tmp -O bam -o aln.bam
  samtools index aln.bam

  # assembly
  stringtie -p 48 -L -c 3 -s 3 -m 150 -o assembly.gtf aln.bam

  gffread -l 150 -w assembly_ge150.fa -g ${reference_genome_fasta} assembly.gtf
  gffread -l 150 --gtf assembly.gtf | awk -F '\t' -v OFS='\t' '{if ($7 != ".") print; else {$7="+" ; print}}' > assembly_ge150.gtf
done


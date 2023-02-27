set -euo pipefail

# set up paths
ont_cdna_reads=$(realpath ../../data/ont_cdna_sirv_ercc.fastq)
ont_drna_reads=$(realtpath ../../data/ont_drna_sirv_ercc.fastq)
pacbio_ccs_reads=$(realpath ../../data/pacbio_ccs_sirv_ercc.fastq)
reference_genome_fasta=/path/to/lrgasp_grcm39_sirvs.fasta

# sanity checks
ls -1 ${ont_cdna_reads} ${ont_drna_reads} ${pacbio_ccs_reads}
ls ${reference_genome_fasta}
which stringtie samtools gffread minimap2

topdir=${PWD}


# assemble ONT cDNA reads

outdir=${topdir}/ont_cdna
mkdir -p ${outdir}
cd ${outdir}

# align reads to reference genome
minimap2 -t 48 -a -x splice ${reference_genome_fasta} ${ont_cdna_reads} | samtools sort -T ./tmp -O bam -o aln.bam
samtools index aln.bam

# assembly
stringtie -p 48 -L -c 3 -s 3 -m 150 -o assembly.gtf aln.bam

# remove transcripts shorter than 150 nt and output FASTA and GTF files
gffread -l 150 -w assembly_ge150.fa -g ${reference_genome_fasta} assembly.gtf
gffread -l 150 --gtf assembly.gtf | awk -F '\t' -v OFS='\t' '{if ($7 != ".") print; else {$7="+" ; print}}' > assembly_ge150.gtf


# assemble ONT dRNA reads

outdir=${topdir}/ont_drna
mkdir -p ${outdir}
cd ${outdir}

# align reads to reference genome
minimap2 -t 48 -a -x splice ${reference_genome_fasta} ${ont_drna_reads} | samtools sort -T ./tmp -O bam -o aln.bam
samtools index aln.bam

# assembly
stringtie -p 48 -L -c 3 -s 3 -m 150 -o assembly.gtf aln.bam

# remove transcripts shorter than 150 nt and output FASTA and GTF files
gffread -l 150 -w assembly_ge150.fa -g ${reference_genome_fasta} assembly.gtf
gffread -l 150 --gtf assembly.gtf | awk -F '\t' -v OFS='\t' '{if ($7 != ".") print; else {$7="+" ; print}}' > assembly_ge150.gtf


# assemble PacBio CCS reads

outdir=${topdir}/pacbio_ccs
mkdir -p ${outdir}
cd ${outdir}

# align reads to reference genome
minimap2 -t 48 -a -x splice ${reference_genome_fasta} ${pacbio_ccs_reads} | samtools sort -T ./tmp -O bam -o aln.bam
samtools index aln.bam

# assembly
stringtie -p 48 -L -c 3 -s 3 -m 150 -o assembly.gtf aln.bam

# remove transcripts shorter than 150 nt and output FASTA and GTF files
gffread -l 150 -w assembly_ge150.fa -g ${reference_genome_fasta} assembly.gtf
gffread -l 150 --gtf assembly.gtf | awk -F '\t' -v OFS='\t' '{if ($7 != ".") print; else {$7="+" ; print}}' > assembly_ge150.gtf



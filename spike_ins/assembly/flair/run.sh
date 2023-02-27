set -euo pipefail

# set up paths
ont_cdna_reads=$(realpath ../../data/ont_cdna_sirv_ercc.fastq)
ont_drna_reads=$(realtpath ../../data/ont_drna_sirv_ercc.fastq)
pacbio_ccs_reads=$(realpath ../../data/pacbio_ccs_sirv_ercc.fastq)
flair=/path/to/flair.py
reference_genome_fasta=/path/to/lrgasp_grcm39_sirvs.fasta
reference_annotation_gtf=/path/to/lrgasp_gencode_vM27_sirvs.gtf

# sanity checks
ls -1 ${ont_cdna_reads} ${ont_drna_reads} ${pacbio_ccs_reads}
ls -1 ${reference_genome_fasta} ${reference_annotation_gtf}
ls ${flair}
which python gffread

topdir=${PWD}


# assemble ONT cDNA reads

outdir=${topdir}/ont_cdna
mkdir -p ${outdir}
cd ${outdir}

flair_tmp_dir=${outdir}/tmpdir
mkdir -p ${flair_tmp_dir}

python ${flair} align -t 48 -g ${reference_genome_fasta} -r ${ont_cdna_reads} -v1.3
python ${flair} correct -t 48 -g ${reference_genome_fasta} -q flair.aligned.bed --gtf ${reference_annotation_gtf}
python ${flair} collapse -t 48 -g ${reference_genome_fasta} -r ${ont_cdna_reads} -q flair_all_corrected.bed --temp_dir ${flair_tmp_dir} -s 3 --gtf ${reference_annotation_gtf}

# remove transcripts shorter than 150 nt and output FASTA and GTF files
gffread -l 150 -w assembly_ge150.fa -g ${reference_genome_fasta} flair.collapse.isoforms.gtf
gffread -l 150 --gtf flair.collapse.isoforms.gtf > assembly_ge150.gtf


# assemble ONT dRNA reads

outdir=${topdir}/ont_drna
mkdir -p ${outdir}
cd ${outdir}

flair_tmp_dir=${outdir}/tmpdir
mkdir -p ${flair_tmp_dir}

python ${flair} align -t 48 -g ${reference_genome_fasta} -r ${ont_drna_reads} -v1.3 --nvrna
python ${flair} correct -t 48 -g ${reference_genome_fasta} -q flair.aligned.bed --gtf ${reference_annotation_gtf} --nvrna
python ${flair} collapse -t 48 -g ${reference_genome_fasta} -r ${ont_drna_reads} -q flair_all_corrected.bed --temp_dir ${flair_tmp_dir} -s 3 --gtf ${reference_annotation_gtf}

# remove transcripts shorter than 150 nt and output FASTA and GTF files
gffread -l 150 -w assembly_ge150.fa -g ${reference_genome_fasta} flair.collapse.isoforms.gtf
gffread -l 150 --gtf flair.collapse.isoforms.gtf > assembly_ge150.gtf


# assemble PacBio CCS reads

outdir=${topdir}/pacbio_ccs
mkdir -p ${outdir}
cd ${outdir}

flair_tmp_dir=${outdir}/tmpdir
mkdir -p ${flair_tmp_dir}

python ${flair} align -t 48 -g ${reference_genome_fasta} -r ${pacbio_ccs_reads} -v1.3
python ${flair} correct -t 48 -g ${reference_genome_fasta} -q flair.aligned.bed --gtf ${reference_annotation_gtf}
python ${flair} collapse -t 48 -g ${reference_genome_fasta} -r ${pacbio_ccs_reads} -q flair_all_corrected.bed --temp_dir ${flair_tmp_dir} -s 3 --gtf ${reference_annotation_gtf}

# remove transcripts shorter than 150 nt and output FASTA and GTF files
gffread -l 150 -w assembly_ge150.fa -g ${reference_genome_fasta} flair.collapse.isoforms.gtf
gffread -l 150 --gtf flair.collapse.isoforms.gtf > assembly_ge150.gtf



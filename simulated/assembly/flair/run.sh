set -euo pipefail

# set up paths
flair=/path/to/flair.py
reference_genome_fasta=/path/to/lrgasp_grcm39_sirvs.fasta
reference_annotation_gtf=/path/to/lrgasp_gencode_vM27_sirvs.gtf

# sanity checks
ls -1 ../../data/mouse_{cdna,drna}/sample.{2,10,18}M.fastq
ls -1 ${reference_genome_fasta} ${reference_annotation_gtf}
ls ${flair}
which python gffread

topdir=${PWD}

# run FLAIR for 2, 10, 18 million cDNA simulated reads
protocol=cdna
for n in 2 10 18
do
  cd ${topdir}
    
  reads=$(realpath ../../data/mouse_${protocol}/sample.${n}M.fastq)
    
  outdir=${topdir}/${protocol}_${n}M
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

# run FLAIR for 2, 10, 18 million dRNA simulated reads
protocol=drna
for n in 2 10 18
do
  cd ${topdir}
    
  reads=$(realpath ../../data/mouse_${protocol}/sample.${n}M.fastq)
    
  outdir=${topdir}/${protocol}_${n}M
  mkdir -p ${outdir}
  cd ${outdir}
    
  flair_tmp_dir=${outdir}/tmpdir
  mkdir -p ${flair_tmp_dir}
    
  python ${flair} align -t 48 -g ${reference_genome_fasta} -r ${reads} -v1.3 --nvrna
  python ${flair} correct -t 48 -g ${reference_genome_fasta} -q flair.aligned.bed --gtf ${reference_annotation_gtf} --nvrna
  python ${flair} collapse -t 48 -g ${reference_genome_fasta} -r ${reads} -q flair_all_corrected.bed --temp_dir ${flair_tmp_dir} -s 3 --gtf ${reference_annotation_gtf}

  # remove transcripts shorter than 150 nt and output FASTA and GTF files
  gffread -l 150 -w assembly_ge150.fa -g ${reference_genome_fasta} flair.collapse.isoforms.gtf
  gffread -l 150 --gtf flair.collapse.isoforms.gtf > assembly_ge150.gtf
done


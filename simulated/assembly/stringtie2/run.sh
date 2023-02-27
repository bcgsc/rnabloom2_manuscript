set -euo pipefail

# set up paths
reference_genome_fasta=/path/to/lrgasp_grcm39_sirvs.fasta

# sanity checks
ls -1 ../../data/mouse_{cdna,drna}/sample.{2,10,18}M.fastq
ls ${reference_genome_fasta}
which stringtie samtools gffread minimap2

topdir=${PWD}

# run StringTie2 for 2, 10, 18 million cDNA simulated reads
for protocol in cdna drna
do
  for n in 2 10 18
  do
    cd ${topdir}

    reads=$(realpath ../../data/mouse_${protocol}/sample.${n}M.fastq)

    outdir=${topdir}/${protocol}_${n}M
    mkdir -p ${outdir}
    cd ${outdir}
      
    # align reads to reference genome
    minimap2 -t 48 -a -x splice ${reference_genome_fasta} ${reads} | samtools sort -T ./tmp -O bam -o aln.bam
    samtools index aln.bam

    # assembly
    stringtie -p 48 -L -c 3 -s 3 -m 150 -o assembly.gtf aln.bam
    
    # remove transcripts shorter than 150 nt and output FASTA and GTF files
    gffread -l 150 -w assembly_ge150.fa -g ${reference_genome_fasta} assembly.gtf
    gffread -l 150 --gtf assembly.gtf | awk -F '\t' -v OFS='\t' '{if ($7 != ".") print; else {$7="+" ; print}}' > assembly_ge150.gtf
  done
done



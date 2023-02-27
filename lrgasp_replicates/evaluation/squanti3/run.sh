set -euo pipefail

# set up paths
summary=/path/to/rnaseq_utils/scripts/extract_sqanti_summary.py
squanti=/path/to/SQANTI3-5.1/sqanti3_qc.py
reference_genome_fasta=/path/to/lrgasp_grcm39_sirvs.fasta
reference_annotation_gtf=/path/to/lrgasp_gencode_vM27_sirvs.gtf

# sanity checks
ls -1 ${summary} ${sqanti}
ls -1 ${reference_genome_fasta} ${reference_annotation_gtf}
ls -1 ../../assembly/{rnabloom2,rattle}/{ENCFF232YSU,ENCFF288PBL,ENCFF683TBO,ENCFF349BIN,ENCFF412NKJ,ENCFF765AEC,ENCFF313VYZ,ENCFF667VXS,ENCFF874VSI}/assembly_ge150.fa
ls -1 ../../assembly/{flair,stringtie2,stringtie2_gtf}/{ENCFF232YSU,ENCFF288PBL,ENCFF683TBO,ENCFF349BIN,ENCFF412NKJ,ENCFF765AEC,ENCFF313VYZ,ENCFF667VXS,ENCFF874VSI}/assembly_ge150.gtf
which python

topdir=${PWD}

# Run SQANTI3 for RNA-Bloom2 and RATTLE assembly FASTA files
for assembler in rnabloom2 rattle
do
  for replicate in ENCFF232YSU ENCFF288PBL ENCFF683TBO ENCFF349BIN ENCFF412NKJ ENCFF765AEC ENCFF313VYZ ENCFF667VXS ENCFF874VSI
  do
    cd ${topdir}
    
    assembly=$(realpath ../../assembly/${assembler}/${replicate}/assembly_ge150.fa)
    
    outdir=${replicate}_${assembler}
    mkdir -p ${outdir}
      
    python ${squanti} ${assembly} ${reference_annotation_gtf} ${reference_genome_fasta} \
      --fasta \
      --force_id_ignore \
      --dir ${outdir} \
      --cpus 48 \
      --skipORF

    python ${summary} ${outdir}/assembly_ge150_SQANTI3_report.html > ${outdir}/summary.tsv
  done
done

# Run SQANTI3 for FLAIR, StringTie2, StringTie2_GTF assembly GTF files
for assembler in flair stringtie2 stringtie2_gtf
  for replicate in ENCFF232YSU ENCFF288PBL ENCFF683TBO ENCFF349BIN ENCFF412NKJ ENCFF765AEC ENCFF313VYZ ENCFF667VXS ENCFF874VSI
  do
    cd ${topdir}
    
    assembly=$(realpath ../../assembly/${assembler}/${replicate}/assembly_ge150.gtf)
      
    outdir=${replicate}_${assembler}
    mkdir -p ${outdir}
      
    python ${squanti} ${assembly} ${reference_annotation_gtf} ${reference_genome_fasta} \
      --force_id_ignore \
      --dir ${outdir} \
      --cpus 48 \
      --skipORF

    python ${summary} ${outdir}/assembly_ge150_SQANTI3_report.html > ${outdir}/summary.tsv
  done
done


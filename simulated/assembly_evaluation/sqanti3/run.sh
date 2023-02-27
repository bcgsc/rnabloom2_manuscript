set -euo pipefail

# set up paths
gtf_filter=/path/to/rnaseq_utils/scripts/gtf_filter.py
summary=/path/to/rnaseq_utils/scripts/extract_sqanti_summary.py
squanti=/path/to/SQANTI3-5.1/sqanti3_qc.py
reference_genome_fasta=/path/to/lrgasp_grcm39_sirvs.fasta
reference_annotation_gtf=/path/to/lrgasp_gencode_vM27_sirvs.gtf

# sanity checks
ls -1 ${gtf_filter} ${summary} ${sqanti}
ls -1 ${reference_genome_fasta} ${reference_annotation_gtf}
ls -1 ../../data/mouse_{cdna,drna}/sample.{2,10,18}M_transcripts.txt
ls -1 ../../assembly/{rnabloom2,rattle}/{cdna,drna}_{2,10,18}M/assembly_ge150.fa
ls -1 ../../assembly/{flair,stringtie2,stringtie2_gtf}/{cdna,drna}_{2,10,18}M/assembly_ge150.gtf
which python

topdir=${PWD}

# extract filtered annotation GTF for each read set
for protocol in cdna drna
do
  for n in 2 10 18
  do
    transcript_ids=../../data/mouse_${protocol}/sample.${n}M_transcripts.txt
    python ${gtf_filter} ${reference_annotation_gtf} ${transcript_ids} --fix > ${protocol}_${n}M.gtf
  done
done

# Run SQANTI3 for RNA-Bloom2 and RATTLE assembly FASTA files
for assembler in rnabloom2 rattle
do
  for protocol in cdna drna
  do
    for n in 2 10 18
    do
      cd ${topdir}
      
      assembly=$(realpath ../../assembly/${assembler}/${protocol}_${n}M/assembly_ge150.fa)
      filtered_annotation_gtf=${protocol}_${n}M.gtf
      
      outdir=${protocol}_${n}M_${assembler}
      mkdir -p ${outdir}
      
      python ${squanti} ${assembly} ${filtered_annotation_gtf} ${reference_genome_fasta} \
        --fasta \
        --force_id_ignore \
        --dir ${outdir} \
        --cpus 48 \
        --skipORF

      python ${summary} ${outdir}/assembly_ge150_SQANTI3_report.html > ${outdir}/summary.tsv
    done
  done
done

# Run SQANTI3 for FLAIR, StringTie2, StringTie2_GTF assembly GTF files
for assembler in flair stringtie2 stringtie2_gtf
  for protocol in cdna drna
  do
    for n in 2 10 18
    do
      cd ${topdir}
      
      assembly=$(realpath ../../assembly/${assembler}/${protocol}_${n}M/assembly_ge150.gtf)
      filtered_annotation_gtf=${protocol}_${n}M.gtf
      
      outdir=${protocol}_${n}M_${assembler}
      mkdir -p ${outdir}
      
      python ${squanti} ${assembly} ${filtered_annotation_gtf} ${reference_genome_fasta} \
        --force_id_ignore \
        --dir ${outdir} \
        --cpus 48 \
        --skipORF

      python ${summary} ${outdir}/assembly_ge150_SQANTI3_report.html > ${outdir}/summary.tsv
    done
  done
done


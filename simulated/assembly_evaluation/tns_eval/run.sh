set -euo pipefail

# set up paths
tns_eval=/path/to/rnaseq_utils/scripts/tns_eval.py
reference_transcriptome_fasta=/path/to/lrgasp_gencode_vM27_sirvs.fa
reference_annotation_gtf=/path/to/lrgasp_gencode_vM27_sirvs.gtf

# sanity checks
ls ${tns_eval}
ls -1 ${reference_transcriptome_fasta} ${reference_annotation_gtf}
ls -1 ../../data/mouse_{cdna,drna}/tns_transcriptome_quantification.tsv
ls -1 ../../data/mouse_{cdna,drna}/sample.{2,10,18}M_transcripts.txt
ls -1 ../assembly/{rnabloom2,rattle,flair,stringtie2,stringtie2_gtf}/{cdna,drna}_{2,10,18}M/assembly_ge150.fa
which python minimap2


for protocol in cdna drna
do
  tpms=$(realpath ../../data/mouse_${protocol}/tns_transcriptome_quantification.tsv)
  
  for n in 2 10 18
  do
    transcript_ids=$(realpath ../../data/mouse_${protocol}/sample.${n}M_transcripts.txt)
    
    for assembler in rnabloom2 rattle flair stringtie2 stringtie2_gtf
    do
      assembly=$(realpath ../assembly/${assembler}/${protocol}_${n}M/assembly_ge150.fa)
      
      outprefix=${protocol}_${n}M_${assembler}_
      paf=${outprefix}aligned.paf.gz
      stats=${outprefix}stats.txt
      
      # align assembly to reference transcriptome
      minimap2 -x map-ont -c -t 12 ${reference_transcriptome_fasta} ${assembly} | gzip -c > ${paf}
      
      # evaluate alignments
      python ${tns_eval} ${assembly} ${paf} ${transcript_ids} ${reference_annotation_gtf} ${outprefix} --tpm ${tpms} > ${stats}
      
    done
  done
done

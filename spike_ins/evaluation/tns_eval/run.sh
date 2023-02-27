set -euo pipefail

# set up paths
tns_eval=/path/to/rnaseq_utils/scripts/tns_eval.py
reference_transcriptome_fasta=/path/to/lrgasp_gencode_vM27_sirvs.fa
reference_annotation_gtf=/path/to/lrgasp_gencode_vM27_sirvs.gtf
transcript_ids=$(realpath ./transcripts.txt)

# sanity checks
ls -1 ${tns_eval} ${transcript_ids}
ls -1 ${reference_transcriptome_fasta} ${reference_annotation_gtf}
ls -1 ../../data/{ont_cdna,ont_drna,pacbio_ccs}_tns_transcriptome_quantification.tsv
ls -1 ../assembly/{rnabloom2,rattle,flair,stringtie2,stringtie2_gtf}/{ont_cdna,ont_drna,pacbio_ccs}/assembly_ge150.fa
which python minimap2


for protocol in ont_cdna ont_drna pacbio_ccs
do
  tpms=$(realpath ../../data/${protocol}/tns_transcriptome_quantification.tsv)
  
  for assembler in rnabloom2 rattle flair stringtie2 stringtie2_gtf
  do
    assembly=$(realpath ../assembly/${assembler}/${protocol}/assembly_ge150.fa)

    outprefix=${protocol}_${assembler}_
    paf=${outprefix}aligned.paf.gz
    stats=${outprefix}stats.txt

    # align assembly to reference transcriptome
    minimap2 -x map-ont -c -t 12 ${reference_transcriptome_fasta} ${assembly} | gzip -c > ${paf}

    # evaluate alignments
    python ${tns_eval} ${assembly} ${paf} ${transcript_ids} ${reference_annotation_gtf} ${outprefix} --tpm ${tpms} > ${stats}
  
  done
done

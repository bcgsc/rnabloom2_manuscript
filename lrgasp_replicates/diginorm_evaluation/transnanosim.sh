set -euo pipefail

# set up paths
read_analysis=/path/to/NanoSim/src/read_analysis.py
tns_gene_exp=/path/to/rnaseq_utils/scripts/tns_gene_exp.py
reference_transcriptome_fasta=/path/to/lrgasp_gencode_vM27_sirvs.fa
reference_annotation_gtf=/path/to/lrgasp_gencode_vM27_sirvs.gtf

# sanity checks
ls -1 ${read_analysis} ${tns_gene_exp}
ls -1 ${reference_transcriptome_fasta} ${reference_annotation_gtf}
ls -1 ../diginorm/{ont_cdna,ont_drna,pacbio_ccs}_{long,hybrid}/rnabloom.longreads.corrected.long{,.seed}.fa.gz
which python

for procotol in ont_cdna_long ont_drna_long pacbio_ccs_long ont_cdna_hybrid ont_drna_hybrid pacbio_ccs_hybrid
do
  corrected=../diginorm/${procotol}/rnabloom.longreads.corrected.long.fa.gz
  normalized=../diginorm/${procotol}/rnabloom.longreads.corrected.long.seed.fa.gz
  
  # quanitfy transcript expression
  python ${read_analysis} quantify -e trans -i ${corrected} -rt ${reference_transcriptome_fasta} -o ${procotol}_corrected -t 16
  python ${read_analysis} quantify -e trans -i ${normalized} -rt ${reference_transcriptome_fasta} -o ${procotol}_normalized -t 16
  
  # tally gene expression
  python ${tns_gene_exp} ${procotol}_corrected_transcriptome_quantification.tsv ${reference_annotation_gtf} > ${procotol}_corrected_transcriptome_quantification.gene.tsv
  python ${tns_gene_exp} ${procotol}_normalized_transcriptome_quantification.tsv ${reference_annotation_gtf} > ${procotol}_normalized_transcriptome_quantification.gene.tsv
done


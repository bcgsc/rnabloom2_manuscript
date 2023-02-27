set -euo pipefail

# set up file paths
ont_cdna_reads=../../lrgasp_replicates/data/{ENCFF232YSU,ENCFF288PBL,ENCFF683TBO}_pychopper_fulllength_rescued.fastq
ont_drna_reads=../../lrgasp_replicates/data/{ENCFF349BIN,ENCFF412NKJ,ENCFF765AEC}.fastq
pacbio_ccs_reads=../../lrgasp_replicates/data/{ENCFF313VYZ,ENCFF667VXS,ENCFF874VSI}.fastq
reference_genome_fasta=/path/to/lrgasp_grcm39_sirvs.fasta
reference_transcriptome_fasta=/path/to/lrgasp_gencode_vM27_sirvs.fa
tns_read_analysis=/path/to/NanoSim/src/read_analysis.py

# sanity checks
ls -1 ${ont_cdna_reads} ${ont_drna_reads} ${pacbio_ccs_reads}
ls ${reference_genome_fasta}
ls ${tns_read_analysis}
which minimap2 samtools python

# spike-in reference names
regions="SIRV1 SIRV2 SIRV3 SIRV4 SIRV5 SIRV6 SIRV7 SIRV4001 SIRV4002 SIRV4003 SIRV6001 SIRV6002 SIRV6003 SIRV8001 SIRV8002 SIRV8003 SIRV10001 SIRV10002 SIRV10003 SIRV12001 SIRV12002 SIRV12003 ERCC-00002 ERCC-00003 ERCC-00004 ERCC-00009 ERCC-00012 ERCC-00013 ERCC-00014 ERCC-00016 ERCC-00017 ERCC-00019 ERCC-00022 ERCC-00024 ERCC-00025 ERCC-00028 ERCC-00031 ERCC-00033 ERCC-00034 ERCC-00035 ERCC-00039 ERCC-00040 ERCC-00041 ERCC-00042 ERCC-00043 ERCC-00044 ERCC-00046 ERCC-00048 ERCC-00051 ERCC-00053 ERCC-00054 ERCC-00057 ERCC-00058 ERCC-00059 ERCC-00060 ERCC-00061 ERCC-00062 ERCC-00067 ERCC-00069 ERCC-00071 ERCC-00073 ERCC-00074 ERCC-00075 ERCC-00076 ERCC-00077 ERCC-00078 ERCC-00079 ERCC-00081 ERCC-00083 ERCC-00084 ERCC-00085 ERCC-00086 ERCC-00092 ERCC-00095 ERCC-00096 ERCC-00097 ERCC-00098 ERCC-00099 ERCC-00104 ERCC-00108 ERCC-00109 ERCC-00111 ERCC-00112 ERCC-00113 ERCC-00116 ERCC-00117 ERCC-00120 ERCC-00123 ERCC-00126 ERCC-00130 ERCC-00131 ERCC-00134 ERCC-00136 ERCC-00137 ERCC-00138 ERCC-00142 ERCC-00143 ERCC-00144 ERCC-00145 ERCC-00147 ERCC-00148 ERCC-00150 ERCC-00154 ERCC-00156 ERCC-00157 ERCC-00158 ERCC-00160 ERCC-00162 ERCC-00163 ERCC-00164 ERCC-00165 ERCC-00168 ERCC-00170 ERCC-00171"

# combine read files from all replicates for each protocol
cat ${ont_cdna_reads} > ont_cdna_all_reads.fastq
cat ${ont_drna_reads} > ont_drna_all_reads.fastq
cat ${pacbio_ccs_reads} > pacbio_ccs_all_reads.fastq

for protocol in ont_cdna ont_drna pacbio_ccs
do
  # align reads to reference genome
  minimap2 -x splice -a --MD -L -Y -t 47 ${reference_genome_fasta} ${protocol}_all_reads.fastq | \
    samtools sort -T ./tmp -O bam -o ${protocol}_aln.bam
  
  samtools index ${protocol}_aln.bam

  # extract reads aligned uniquely to spike-ins
  samtools view -h -F 0x800 ${protocol}_aln.bam ${regions} | \
    grep -v 'SA:Z:' | \
    samtools view -hSu | \
    samtools sort -n -O BAM | \
    samtools fastq -n -c 6 -0 ${protocol}_sirv_ercc.fastq -
  
  # profile error rates
  python ${tns_read_analysis} transcriptome -t 16 --no_intron_retention \
    -rg ${reference_genome_fasta} -rt ${reference_transcriptome_fasta} \
    -i ${protocol}_sirv_ercc.fastq -o ${protocol}_tns
  
  # quantify expression
  python ${tns_read_analysis} quantify -t 16 -e trans \
    -rt ${reference_transcriptome_fasta} \
    -i ${protocol}_sirv_ercc.fastq -o ${protocol}_tns
done


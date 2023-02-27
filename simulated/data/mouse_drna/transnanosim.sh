set -euo pipefail

read_analysis=/path/to/NanoSim/src/read_analysis.py
simulator=/path/to/NanoSim/src/simulator.py
transcriptome_reference_fasta=/path/to/lrgasp_gencode_vM27_sirvs.fa
genome_reference_fasta=/path/to/lrgasp_grcm39_sirvs.fasta
polya_transcript_ids=../polya_transcript_ids.txt
reads=/path/to/ENCFF349BIN.fastq

# sanity checks
ls -1 ${read_analysis} ${simulator}
ls -1 ${transcriptome_reference_fasta} ${genome_reference_fasta} ${polya_transcript_ids} ${reads}
which python

# expression quantification with Trans-NanoSim
python ${read_analysis} quantify -t 16 -e trans \
  -rt ${transcriptome_reference_fasta} \
  -i ${reads} -o tns

# down-sample reads to 1000000 with seqtk
seqtk sample ${reads} 1000000 > sample.fastq

# characterize reads with Trans-NanoSim
python read_analysis.py transcriptome -t 16 --no_intron_retention \
  -rg ${genome_reference_fasta} \
  -rt ${genome_reference_fasta} \
  -i sample.fastq -o training

# simulate reads with Trans-NanoSim
python ${simulator} transcriptome -t 16 --no_model_ir --fastq \
  -b guppy -r dRNA \
  -rg ${genome_reference_fasta} \
  -rt ${genome_reference_fasta} \
  -e tns_transcriptome_quantification.tsv \
  --polya ${polya_transcript_ids} \
  -c training -o sim25M -n 25000000

# down-sample simulated reads to 2, 10, and 18 million reads
seqtk sample sim25M_aligned_reads.fastq 2000000 > sample.2M.fastq
seqtk sample sim25M_aligned_reads.fastq 10000000 > sample.10M.fastq
seqtk sample sim25M_aligned_reads.fastq 18000000 > sample.18M.fastq


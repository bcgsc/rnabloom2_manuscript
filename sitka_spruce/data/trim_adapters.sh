set -euo pipefail

# set up paths
input_fastq=/path/to/SRR19510936.fastq
output_fastq=/path/to/porechop.fastq
porechop=/path/to/porechop-runner.py

# sanity checks
ls -1 ${input_fastq} ${output_fastq} ${porechop}
which python

# run Porechop
python ${porechop} \
-i ${input_fastq} \
-o ${output_fastq} \
--check_reads 20000 --end_threshold 80 --end_size 100 \
--min_trim_size 8 --extra_end_trim 0 --min_split_read_size 150 \
--extra_middle_trim_good_side 0 --extra_middle_trim_bad_side 40


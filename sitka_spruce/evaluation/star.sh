set -euo pipefail

star_index=/path/to/star/index
out_prefix=/path/to/output/prefix

# separate file paths with `,`
reads1="/path/to/sample1_1.fastq,/path/to/sample2_1.fastq,..."
reads2="/path/to/sample1_2.fastq,/path/to/sample2_2.fastq,..."

# sanity checks
ls -d ${star_index}
which STAR

# run star
STAR --runThreadN 48 \
--genomeDir ${star_index} \
--readFilesIn ${reads1} ${reads2} \
--outFileNamePrefix ${out_prefix} \
--alignSJoverhangMin 8 \
--alignSJDBoverhangMin 1 \
--outFilterType BySJout \
--outSAMunmapped Within \
--outFilterMultimapNmax 20 \
--outFilterMismatchNoverLmax 0.04 \
--outFilterMismatchNmax 999 \
--alignIntronMin 20 --alignIntronMax 1000000 \
--alignMatesGapMax 1000000 \
--sjdbScore 1 \
--genomeLoad NoSharedMemory \
--outSAMtype BAM SortedByCoordinate \
--twopassMode Basic \
--readFilesCommand zcat \
--chimOutType WithinBAM --chimSegmentMin 40


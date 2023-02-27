set -euo pipefail

# set up paths
short_reads1="/path/to/sample1_1.fastq /path/to/sample2_1.fastq ..." # paths are separated by space character ` `
short_reads2="/path/to/sample1_2.fastq /path/to/sample2_2.fastq ..." # paths are separated by space character ` `
long_reads=/path/to/porechop.fastq
outdir=/path/to/output/directory
rnabloom_jar=/path/to/RNA-Bloom.jar

# sanity checks
ls -1 ${short_reads1} ${short_reads2} ${long_reads}
ls -d ${outdir}
ls ${rnabloom_jar}
which java minimap2 ntcard racon

# run RNA-Bloom2
java -Xmx150g -jar ${rnabloom_jar} -t 48 -outdir ${outdir} \
-long ${long_reads} -fpr 0.005 -overlap 200 -length 200 \
-left ${short_reads1} -right ${short_reads2} \
-lrrd 2


set -euo pipefail

# set up paths
reads=/path/to/porechop.fastq
outdir=/path/to/output/directory
rnabloom_jar=/path/to/RNA-Bloom.jar

# sanity checks
ls ${reads}
ls -d ${outdir}
ls ${rnabloom_jar}
which java minimap2 ntcard racon

# run RNA-Bloom2
java -Xmx150g -jar ${rnabloom_jar} -t 48 -outdir ${outdir} \
-long ${reads} -fpr 0.005 -overlap 200 -length 200 \
-lrrd 2


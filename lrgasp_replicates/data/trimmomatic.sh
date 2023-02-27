set -euo pipefail

# set up paths
trimmomatic_jar=/path/to/trimmomatic-0.39.jar
reads1=ENCFF696TCH.fastq
reads2=ENCFF751FTE.fastq

# sanity checks
ls ${trimmomatic_jar}
ls -1 ${reads1} ${reads2}
which java

java -jar ${trimmomatic_jar} PE -phred33 \
  ${reads1} ${reads2} \
  ENCLB588OJP_trimmomatic_pe_1.fastq ENCLB588OJP_trimmomatic_se_1.fastq \
  ENCLB588OJP_trimmomatic_pe_2.fastq ENCLB588OJP_trimmomatic_se_2.fastq \
  ILLUMINACLIP:adapters.fa:2:30:10 \
  LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:25


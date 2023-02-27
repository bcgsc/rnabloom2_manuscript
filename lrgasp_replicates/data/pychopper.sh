set -euo pipefail

# set up paths
cdna_classifier=/path/to/nanoporetech/pychopper/scripts/cdna_classifier.py
primers=/path/to/nanoporetech/pychopper/primer_data/PCS110_primers.fas
reads={ENCFF232YSU,ENCFF288PBL,ENCFF683TBO}.fastq

#sanity checks
ls -1 ${cdna_classifier} ${primers}
ls -1 ${reads}

for replicate in ENCFF232YSU ENCFF288PBL ENCFF683TBO
do
  python ${cdna_classifier} -t 24 -m edlib -b ${primers} -Y 20000 \
    -S ${replicate}_pychopper_stats.tsv \
    -r ${replicate}_pychopper_report.pdf \
    -u ${replicate}_pychopper_unclassified.fastq \
    -w ${replicate}_pychopper_rescued.fastq \
    -K ${replicate}_pychopper_qcfail.fastq \
    ${replicate}.fastq ${replicate}_pychopper_PCS110_fulllength.fastq
  
  cat ${replicate}_pychopper_{fulllength,rescued}.fastq > ${replicate}_pychopper_fulllength_rescued.fastq
done

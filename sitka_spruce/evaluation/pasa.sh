set -euo pipefail

# set up paths
pasa_dir=/path/to/PASApipeline-v2.5.2
transcripts=/path/to/rnabloom.transcripts.fa
genome=/path/to/genome/assembly.fa

# sanity checks
ls -d ${pasa_dir}
ls ${pasa_dir}/bin/seqclean
ls ${pasa_dir}/pasa_conf/pasa.alignAssembly.Template.txt
ls ${pasa_dir}/Launch_PASA_pipeline.pl
ls ${pasa_dir}/scripts/pasa_asmbls_to_training_set.dbi
ls -1 ${transcripts} ${genome}

# extract IDs to generate `FL_accs.txt`
grep '^>' ${transcripts} | sed -e 's/^>//g' -e 's/ .*//g' > FL_accs.txt

# clean assembly
${pasa_dir}/bin/seqclean ${transcripts}

# set up PASA config
sed -e "s#<__DATABASE__>#$PWD/database.sqlite#" -e 's/^validate/#validate/' ${pasa_dir}/pasa_conf/pasa.alignAssembly.Template.txt > alignAssembly.config

# run PASA
export MINIMAP2_CUSTOM_OPTS=' --split-prefix mm2_tmp '

${pasa_dir}/Launch_PASA_pipeline.pl -c alignAssembly.config \
--CPU 24 -C -R -g ${genome} \
--ALT_SPLICE -t ${transcripts}.clean \
-T -u ${transcripts} \
-f FL_accs.txt \
--ALIGNERS minimap2 --MAX_INTRON_LENGTH 1000000 \
--TRANSDECODER

${pasa_dir}/scripts/pasa_asmbls_to_training_set.dbi \
--pasa_transcripts_fasta ./database.sqlite.assemblies.fasta \
--pasa_transcripts_gff3 ./database.sqlite.pasa_assemblies.gff3


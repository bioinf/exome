#!/bin/bash

# Input are directories in '' and name of experiment (prefix of output RAW VCF)
# Cohorts of 30+ GVCFs are cool, yep

#INPUTDIRS=$1
EXPNAME=$1

#for DIR in $INPUTDIRS
#do
#    ls -d -1 $DIR/*.g.vcf >> gvcfs.list
#done

java -Xmx64g -jar /Molly/barbitoff/software/gatk-protected/target/GenomeAnalysisTK.jar -T GenotypeGVCFs -R /Molly/barbitoff/reference/GATK_b37/human_g1k_v37.fasta -V gvcfs.list -o ${EXPNAME}.raw.vcf

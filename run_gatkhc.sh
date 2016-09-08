#!/bin/bash

# Running GATK HaplotypeCaller in GVCF mode for a directory of BAMs

PLATFORM=$1

#mkdir ../vcfs/

for RCB in *.recal.bam
do
    while [ $(jobs | wc -l) -ge 24 ]; do sleep 1; done
    java -Xmx8g -jar /Molly/barbitoff/software/gatk-protected/target/GenomeAnalysisTK.jar -T HaplotypeCaller -R /Molly/barbitoff/reference/GATK_b37/human_g1k_v37.fasta -L /Molly/barbitoff/reference/${PLATFORM}.intervals -I $RCB -o ../vcfs/${RCB%%.recal.bam}.g.vcf -ERC GVCF &> ./gatk_logs/${RCB%%.recal.bam}.HaplotypeCaller.log &
done

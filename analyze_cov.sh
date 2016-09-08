#!/bin/bash

# Analyzing covariates for estimating BQSR effect from data

PLATFORM=$1

for BAM in *.realigned.bam
do
    java -Xmx20g -jar /Molly/barbitoff/software/gatk-protected/target/GenomeAnalysisTK.jar -T BaseRecalibrator -R /Molly/barbitoff/reference/GATK_b37/human_g1k_v37.fasta -I $BAM -knownSites /Molly/barbitoff/gatk-bundle-b37/dbsnp_138.b37.vcf -knownSites /Molly/barbitoff/gatk-bundle-b37/Mills_and_1000G_gold_standard.indels.b37.vcf -L /Molly/barbitoff/reference/${PLATFORM}.intervals -BQSR ${BAM%%.realigned.bam}.recal.table -o ${BAM%%.realigned.bam}.recal.after.table > ./gatk_logs/${BAM%%.realigned.bam}.SPBaseRecalibrator.log
done

mkdir gatk_logs/recal_tables

mv *.table gatk_logs/recal_tables/

echo 'Analysis of covariates done! Make plots locally, if you want'

#!/bin/bash

# SNP and INDEL VQSR
# Making two passes of model generation - with new dbSNP, but the tranches plots will look fucking weird - manually check tranches file and VQSLOD value -> less than 20 is unappropriate!

PREFIX=$1
MODE=$2

if [[ $MODE == "SNP" ]]
then
    java -Xmx64g -jar /Molly/barbitoff/software/gatk-protected/target/GenomeAnalysisTK.jar -T VariantRecalibrator \
        -R /Molly/barbitoff/reference/GATK_b37/human_g1k_v37.fasta \
        -input ${PREFIX}.raw.vcf \
        -resource:hapmap,known=false,training=true,truth=true,prior=15.0 /Molly/barbitoff/gatk-bundle-b37/hapmap_3.3.b37.vcf \
        -resource:omni,known=false,training=true,truth=true,prior=12.0 /Molly/barbitoff/gatk-bundle-b37/1000G_omni2.5.b37.vcf \
        -resource:mills,known=false,training=true,truth=true,prior=12.0 /Molly/barbitoff/gatk-bundle-b37/Mills_and_1000G_gold_standard.indels.b37.vcf \
        -resource:dbsnp,known=true,training=false,truth=false,prior=2.0 /Molly/barbitoff/gatk-bundle-b37/dbsnp_138.b37.vcf \
        -an QD -an MQ -an MQRankSum -an ReadPosRankSum -an FS -an SOR -an InbreedingCoeff \
        -mode SNP \
        -recalFile ${PREFIX}.snp.recal \
        -tranchesFile ${PREFIX}.snp.tranches \
        -rscriptFile ${PREFIX}.snp.plots.R
else
    java -Xmx64g -jar /Molly/barbitoff/software/gatk-protected/target/GenomeAnalysisTK.jar -T VariantRecalibrator \
        -R /Molly/barbitoff/reference/GATK_b37/human_g1k_v37.fasta \
        -input ${PREFIX}.snp.recal.vcf \
        --maxGaussians 4 \
        -resource:mills,known=false,training=true,truth=true,prior=12.0 /Molly/barbitoff/gatk-bundle-b37/Mills_and_1000G_gold_standard.indels.b37.vcf \
        -resource:dbsnp,known=true,training=false,truth=false,prior=2.0 /Molly/barbitoff/gatk-bundle-b37/dbsnp_138.b37.vcf \
        -an QD -an MQRankSum -an ReadPosRankSum -an FS -an SOR -an InbreedingCoeff \
        -mode INDEL \
        -recalFile ${PREFIX}.indel.recal \
        -tranchesFile ${PREFIX}.indel.tranches \
        -rscriptFile ${PREFIX}.indel.plots.R
fi


#!/bin/bash

# Refining the genotypes, then annotating-splitting  VCF file

PREFIX=$1

# Genotype refinement - here we do filter out genotypes with low GQ score using prior of 1000G

java -Xmx64g -jar /Molly/barbitoff/software/gatk-protected/target/GenomeAnalysisTK.jar -T CalculateGenotypePosteriors -R /Molly/barbitoff/reference/GATK_b37/human_g1k_v37.fasta -V ${PREFIX}.out.vcf \
	--supporting /Molly/barbitoff/gatk-bundle-b37/1000G_phase3_v4_20130502.sites.vcf -o ${PREFIX}.GR.vcf

java -Xmx64g -jar /Molly/barbitoff/software/gatk-protected/target/GenomeAnalysisTK.jar -T VariantFiltration  -R /Molly/barbitoff/reference/GATK_b37/human_g1k_v37.fasta -V ${PREFIX}.GR.vcf -G_filter "GQ < 20.0" -G_filterName lowGQ -o ${PREFIX}.GF.vcf

mkdir gt_refine
mv *.out.* gt_refine/
mv *.GR.* gt_refine/


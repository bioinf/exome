#!/bin/bash

# This is phasing (only in trios and pairs, so a little bit of pain in the butt

PREFIX=$1
PEDFILE=$2

java -jar /Molly/barbitoff/software/gatk-protected/target/GenomeAnalysisTK.jar -T PhaseByTransmission \ 
     -R /Molly/barbitoff/reference/GATK_b37/human_g1k_v37.fasta \
     -V ${PREFIX}.complete.vcf \
     -ped $PEDFILE \
     -o ${PREFIX}.complete.phased.vcf

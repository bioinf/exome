#!/bin/bash

# This make export-ready single sample VCF files for our little two-X-chromosomed clinicians' convenience
grep -oP 'run_\d+.sample_\d+' gvcfs.list > samples.list

for i in $( cat samples.list )
do
	java -Xmx4g -jar /Molly/barbitoff/software/gatk-protected/target/GenomeAnalysisTK.jar -T SelectVariants -R /Molly/barbitoff/reference/GATK_b37/human_g1k_v37.fasta -V runs_1-4.complete.vcf -sn $i --excludeNonVariants -o ${i}.vcf &
done

for i in run_*.vcf
do
	for j in `seq 1 22`; do sed -i 's/^'"$j"'/chr'"$j"'/' $i; done
	for j in 'X Y M'; do sed -i 's/^'"$j"'/chr'"$j"'/' $i; done
done

mkdir ssVCFs

mv run_* ssVCFs/

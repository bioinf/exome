#1/bin/bash

# Run BQSR for WES data
# Note that the platform must be specified to correct only using the target regions

PLATFORM=$1
# illumina or roche

for BAM in *.realigned.bam
do
	while [ $( jobs | wc -l ) ge 12 ]; do sleep 1; done
	java -Xmx20g -jar /Molly/barbitoff/software/gatk-protected/target/GenomeAnalysisTK.jar -T BaseRecalibrator -R /Molly/barbitoff/reference/GATK_b37/human_g1k_v37.fasta -I $BAM -knownSites /Molly/barbitoff/gatk-bundle-b37/dbsnp_138.b37.vcf -knownSites /Molly/barbitoff/gatk-bundle-b37/Mills_and_1000G_gold_standard.indels.b37.vcf -L /Molly/barbitoff/reference/${PLATFORM}.intervals -o ${BAM%%.realigned.bam}.recal.table 2> ./gatk_logs/${BAM%%.realigned.bam}.BaseRecalibrator.log &
done
wait

for BAM in *.realigned.bam
do
	while [ $( jobs | wc -l ) ge 12 ]; do sleep 1; done
	java -Xmx20g -jar /Molly/barbitoff/software/gatk-protected/target/GenomeAnalysisTK.jar -T PrintReads -R /Molly/barbitoff/reference/GATK_b37/human_g1k_v37.fasta -I $BAM -BQSR ${BAM%%.realigned.bam}.recal.table -o ${BAM%%.realigned.bam}.recal.bam 2> ./gatk_logs/${BAM%%.realigned.bam}.PrintReads.log &
done
wait

#mkdir realigned
mkdir gatk_logs/recal_tables

mv *.realigned.* realigned/
mv *.recal.table gatk_logs/recal_tables/

echo 'Recalibration of base qualities done, BAMs are ready for calling!'

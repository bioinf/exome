#!/bin/bash

# Indel realignment using GATK

PLATFORM=$1
# illumina or roche

# Index directory of deduplicated bam files
# Indexing is required for GATK to work properly

for BAM in *.dedup.bam
do
    /Molly/barbitoff/software/samtools_latest/samtools index $BAM &
done
wait

#echo 'Indexing done, ready to use GATK!'

mkdir gatk_logs

for DDB in *.dedup.bam
do
    while [ $(jobs | wc -l) -ge 6 ] ; do sleep 1; done
    java -Xmx2g -jar /Molly/barbitoff/software/gatk-protected/target/GenomeAnalysisTK.jar -T RealignerTargetCreator -R /Molly/barbitoff/reference/GATK_b37/human_g1k_v37.fasta -I $DDB -L /Molly/barbitoff/reference/${PLATFORM}.intervals -known /Molly/barbitoff/gatk-bundle-b37/Mills_and_1000G_gold_standard.indels.b37.vcf -o ${DDB%%.dedup.bam}.target.intervals &> ./gatk_logs/${DDB%%.dedup.bam}.TargetCreator.log &
done
wait

#echo 'Intervals for realignment created!'

for DDB in *.dedup.bam
do
    while [ $(jobs | wc -l) -ge 6 ] ; do sleep 1; done
    java -Xmx2g -jar /Molly/barbitoff/software/gatk-protected/target/GenomeAnalysisTK.jar -T IndelRealigner -R /Molly/barbitoff/reference/GATK_b37/human_g1k_v37.fasta -I $DDB -targetIntervals ${DDB%%.dedup.bam}.target.intervals -L /Molly/barbitoff/reference/${PLATFORM}.intervals -known /Molly/barbitoff/gatk-bundle-b37/Mills_and_1000G_gold_standard.indels.b37.vcf -o ${DDB%%.dedup.bam}.realigned.bam &> ./gatk_logs/${DDB%%.dedup.bam}.IndelRealigner.log &
done
wait

mkdir ./gatk_logs/realigner_intervals
mv *.intervals ./gatk_logs/realigner_intervals

#mkdir dedupped
mv *.dedup.* dedupped

echo 'Finished realigning indel segments, BAMs ready for BQSR!'

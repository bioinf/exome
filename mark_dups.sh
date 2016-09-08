#!/bin/bash 

# Marking duplicate reads in BAM files

mkdir picard_logs

for BAM in *.bam
do
    while [ $(jobs | wc -l) -ge 8 ] ; do sleep 1; done
    java -Xmx2g -jar /Molly/barbitoff/software/picard-tools-2.0.1/picard.jar MarkDuplicates I=$BAM O=${BAM%%.bam}.dedup.bam M=picard_logs/${BAM%%.bam}.metrics ASSUME_SORTED=true &> picard_logs/${BAM%%.bam}.log &  
done
wait

echo 'Finished marking duplicates, ready for calculating HSMetrics!'

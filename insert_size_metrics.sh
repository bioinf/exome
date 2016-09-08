#!/bin/bash

for BAM in *.dedup.bam
do
    java -Xmx4g -jar /Molly/barbitoff/software/picard-tools-2.0.1/picard.jar CollectInsertSizeMetrics I=$BAM O=../../insert_size_metrics/${BAMM%%.dedup.bam}.is.out H=../../insert_size_metrics/${BAM%%.dedup.bam}.is.pdf &
done

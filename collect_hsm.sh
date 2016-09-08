#!/bin/bash

# Calculating HS metrics using Picard

mkdir ../hs_metrics

PLATFORM=$1

for BAM in *.dedup.bam
do
    while [ $(jobs | wc -l) -ge 6 ] ; do sleep 1; done
    java -Xmx2g -jar /Molly/barbitoff/software/picard-tools-2.0.1/picard.jar CalculateHsMetrics BAIT_INTERVALS=/Molly/barbitoff/reference/${PLATFORM}.intervals TARGET_INTERVALS=/Molly/barbitoff/reference/${PLATFORM}.intervals INPUT=$BAM OUTPUT=../hs_metrics/${BAM%%.dedup.bam}.HS.metrics NEAR_DISTANCE=0 &
done
wait

cd ../hs_metrics
echo SAMPLE > sample

for METRIC in *.metrics
do
    TAG=${METRIC%%.metrics}
    awk '{ if (NR == 8) print }' $METRIC > tmp
    echo $TAG > tmp2
    paste tmp2 tmp  >> data
    rm tm*
done

awk '{   if (NR == 7) print }' $METRIC > tmpheader
paste sample tmpheader > header
cat header data > ${METRIC%%.sample*}.metrics
rm data header tmpheader sample

echo 'Done with HSMetrics'

#!/bin/bash

# Running bwa mem for high-quality alignment of WGS or WES data
# Assuming INPUT is given in format run_X.sample_X.lane_X.R(1/2).fastq.gz
# Assuming at most two lanes per sample
# Merging BAMs right after alignment step

MULTILANE=$1

for FQ in fastqs/*R1.fastq.gz
do
    TMPTAG=${FQ%%.R1.fastq.gz}
    TAG=${TMPTAG##fastqs/}
    /Molly/barbitoff/software/fermikit/fermi.kit/bwa mem -M -t 12 -R "@RG\tID:$TAG\tSM:${TAG%%.lane*}\tLIB:1\tPL:illumina" /Molly/barbitoff/reference/GATK_b37/human_g1k_v37.fasta ${TMPTAG}.R1.fastq.gz ${TMPTAG}.R2.fastq.gz | /Molly/barbitoff/software/samtools_latest/samtools view -bS - > bams/${TAG}.bam 
done

cd bams

#for i in *.bam
#do
#	echo ${i%%.lane_*} >> bams.list
#done

#sort -u bams.list > tmp
#mv tmp bams.list

for i in *.bam
do
    TAG=${i%%.bam}
    /Molly/barbitoff/software/samtools_latest/samtools sort $i ${TAG}.sorted &
done
wait

for i in *.sorted.bam
do
	mv $i ${i%%.sorted.bam}.bam
done

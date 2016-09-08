#!/bin/bash

RUN=$1

for FQ in *.fastq.gz
do
    echo $FQ > name
    mv $FQ run_${RUN}.sample_${FQ%%_*}.lane_$( grep -oP 'L00\K\d' name ).R$( grep -oP '_R\K\d' name ).fastq.gz
    rm name
done


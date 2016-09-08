#!/bin/bash

VCF=$1

grep -v '#' $VCF | grep 'VARTYPE=SNP' - | grep -v 'EFF=SYNO' - | cut -f 1-2,4-5 - | awk '{print $1"\t"$2"\t"substr($3,1,1)"\t"substr($4,1,1)}' - |sed 's/\t/,/g' - | python /Molly/barbitoff/software/fathmm-MKL/fathmm-MKL.py - ${VCF%%.vcf}.fathmmMKL.txt /Molly/barbitoff/software/fathmm-MKL/fathmm-MKL_Current.tab.gz

grep -v 'Pred' ${VCF%%.vcf}.fathmmMKL.txt > ${VCF%%.vcf}.fathmm.txt
rm  ${VCF%%.vcf}.fathmmMKL.txt

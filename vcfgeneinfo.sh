#!/bin/bash

# This is a bash-based wrapper for Py shit

PREFIX=$1

grep -P "#" ${PREFIX}.wgc.vcf > tmpheader
grep -v '#CHROM' tmpheader > header
grep '#CHROM' tmpheader > colnames
echo '##INFO=<ID=GENEINFO,Number=.,Type=String,Description="Gene description">' > newline
grep -v -P "#" ${PREFIX}.wgc.vcf | grep -v -P '\t\*\t' - > vcf
/Molly/barbitoff/GATK-scripts/vcfgeneinfo.py vcf /Molly/barbitoff/reference/go.tsv newvcf
cat header newline colnames newvcf > ${PREFIX}.wgi.vcf
rm header tmpheader colnames newline vcf newvcf

#!/usr/bin/env python

# This thing gets as input a vcf file without header and prepends GENEINFO field to INFO

import sys


ifile, gofile, ofile = sys.argv[1:]

with open(gofile, 'r') as go:
    genes = {}
    for line in go:
        content = line.strip().split('\t')
        if content[2] in genes:
            continue
        info_field = content[9].replace(' ', '_')
        genes[content[2]] = info_field

with open(ofile, 'w') as out:
    with open(ifile, 'r') as vcf:
        for line in vcf:
            content = line.split('\t')
            try:
                a = content[7].split('|')[4]
            except IndexError:
                print line
                sys.exit()
            if content[7].split('|')[4] not in genes:
                out.write(line)
            else:
                out.write('\t'.join(content[:8]) + ';GENEINFO=' + genes[content[7].split('|')[4]] + '\t' + '\t'.join(content[8:]))


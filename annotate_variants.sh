#!/bin/bash

# This thing combines GATK VariantAnnotator, SnpEff and SnpSift to filter, rank and annotate variant calls
# I think this is gonna produce some sets of files like .pathogenic.vcf with clinvar high CLNSIG and HIGH or MODERATE impact in SnpEff fields
# Alongside a normal fully annotated VCF file will surely be present

PREFIX=$1

# Changing mitochondiral annotations
sed -i 's/MT\t/M\t/' ${PREFIX}.GF.vcf

/Molly/barbitoff/software/vcflib/bin/vcfbreakmulti ${PREFIX}.GF.vcf > ${PREFIX}.ua.vcf

# Here we run SnpEff on our GF.vcf
java -Xmx64g -jar /Molly/barbitoff/software/snpEff/snpEff.jar -noHgvs -v -o gatk hg19 ${PREFIX}.ua.vcf > ${PREFIX}.SE.vcf 2> ${PREFIX}.SE.Progress.log

# Here we will add ID from dbSNP
java -Xmx64g -jar /Molly/barbitoff/software/snpEff/SnpSift.jar annotate -v -noInfo /Molly/barbitoff/gatk-bundle-b37/dbsnp_138.b37.vcf ${PREFIX}.SE.vcf > ${PREFIX}.dbSNP.vcf 2> ${PREFIX}.dbSNP.Progress.log

# Here we will add certain fields from ClinVar
java -Xmx64g -jar /Molly/barbitoff/software/snpEff/SnpSift.jar annotate -v -noId -info PM,OM,CLNSIG,CLNDBN,CLNREVSTAT /Molly/barbitoff/reference/GENCODE_19/clinvar_20160302.vcf ${PREFIX}.dbSNP.vcf > ${PREFIX}.annotated.vcf

# Annotating ext_afs
java -Xmx64g -jar /Molly/barbitoff/software/snpEff/SnpSift.jar annotate -v -noId -info X1000Gp3_AF /Molly/barbitoff/reference/1000G_phase3_v4_20130502.sites.vcf ${PREFIX}.annotated.vcf > ${PREFIX}.annotated2.vcf
java -Xmx64g -jar /Molly/barbitoff/software/snpEff/SnpSift.jar annotate -v -noId -info ExAC_AF /Molly/barbitoff/reference/ExAC.r0.3.1.sites.vep.vcf ${PREFIX}.annotated2.vcf > ${PREFIX}.annotated3.vcf
java -Xmx64g -jar /Molly/barbitoff/software/snpEff/SnpSift.jar annotate -v -noId -info ESP6500_AF /Molly/barbitoff/reference/ESP6500.sites.vcf ${PREFIX}.annotated3.vcf > ${PREFIX}.annotated4.vcf

# Here we will annotate files using GWAS catalog
java -Xmx64g -jar /Molly/barbitoff/software/snpEff/SnpSift.jar gwasCat -db /Molly/barbitoff/reference/gwascatalog.txt ${PREFIX}.annotated4.vcf > ${PREFIX}.wgc.vcf

# And add gene info to annotation and do a little metric cleanup
/Molly/barbitoff/GATK-scripts/vcfgeneinfo.sh $PREFIX

# And annotate types of variation
java -jar /Molly/barbitoff/software/snpEff/SnpSift.jar varType ${PREFIX}.wgi.vcf > ${PREFIX}.torminfo.vcf

java -Xmx64g -jar /Molly/barbitoff/software/snpEff/SnpSift.jar rmInfo ${PREFIX}.torminfo.vcf "AC" "AN" "BaseQRankSum" "ClippingRankSum" "DP" "ExcessHet" "InbreedingCoeff" \
	"MLEAC" "MLEAF" "MQRankSum" "PG" "ReadPosRankSum" "SOR" "culprit" "POSITIVE_TRAIN_SITE" > ${PREFIX}.complete.vcf

java -Xmx64g -jar /Molly/barbitoff/software/snpEff/SnpSift.jar dbnsfp -db /Molly/barbitoff/software/dbNSFP2.9.txt.gz -f PROVEAN_pred,SIFT_pred,Polyphen2_HVAR_pred -v ${PREFIX}.complete.vcf > ${PREFIX}.dbnsfp.vcf

# Outputted is a VCF file with dbSNP and ClinVar annotations, also, we output a VCF file of pathogenic or likely pathogenic ClinVar variants and HIGH impact level
#java -Xmx64g -jar /Molly/barbitoff/software/snpEff/SnpSift.jar filter -v "( EFF[*].IMPACT = 'MODERATE' ) | ( EFF[*].IMPACT = 'HIGH' )" ${PREFIX}.dbnsfp.vcf > ${PREFIX}.modhigheff.vcf
#java -Xmx64g -jar /Molly/barbitoff/software/snpEff/SnpSift.jar filter -v "( EFF[*].IMPACT = 'HIGH' )" ${PREFIX}.dbnsfp.vcf > ${PREFIX}.higheff.vcf
#java -Xmx64g -jar /Molly/barbitoff/software/snpEff/SnpSift.jar filter -v "( CLNSIG >= 4 ) & ( CLNSIG < 255 )" ${PREFIX}.dbnsfp.vcf > ${PREFIX}.clnvpath.vcf

mkdir annotation
mv *.GF* annotation
mv *.dbSNP* annotation
mv *.SE* annotation
mv *.annotated* annotation
mv *.wgc.vcf* annotation
mv *.wgi.vcf* annotation
mv *.torminfo.vcf* annotation
mv *.ua.vcf* annotation
mv *.complere.* annotation

# Final parsing stages - making CSV-file for everything!
# /Molly/barbitoff/GATK-scripts/make_fathmm.sh ${PREFIX}.dbnsfp.vcf
# /Molly/barbitoff/software/csvKnit.py ${PREFIX}.dbnsfp.vcf

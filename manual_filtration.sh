#!/bin/bash

PREFIX=$1

java -jar $GATK -T SelectVariants -R /Molly/barbitoff/reference/GATK_b37/human_g1k_v37.fasta -V ${PREFIX}.raw.vcf -o ${PREFIX}.SNP.vcf -selectType SNP
java -jar $GATK -T SelectVariants -R /Molly/barbitoff/reference/GATK_b37/human_g1k_v37.fasta -V ${PREFIX}.raw.vcf -o ${PREFIX}.INDEL.vcf -selectType INDEL
java -jar $GATK -T VariantFiltration -R /Molly/barbitoff/reference/GATK_b37/human_g1k_v37.fasta -V ${PREFIX}.SNP.vcf -filter "QD < 2.0 || FS > 60.0 || SOR > 4.0 || MQ < 40.0 || MQRankSum < -12.5 || ReadPosRankSum < -8.0" -filterName SNP_filter -o ${PREFIX}.F1.vcf
java -jar $GATK -T VariantFiltration -R /Molly/barbitoff/reference/GATK_b37/human_g1k_v37.fasta -V ${PREFIX}.INDEL.vcf -filter "QD < 2.0 || FS > 200.0 || SOR > 10.0 || InbreedingCoeff < -0.8 || ReadPosRankSum < -12.0" -filterName INDEL_filter -o ${PREFIX}.F2.vcf
java -jar $GATK -T CombineVariants -R /Molly/barbitoff/reference/GATK_b37/human_g1k_v37.fasta -V:foo ${PREFIX}.F1.vcf -V:bar ${PREFIX}.F2.vcf -o ${PREFIX}.F3.vcf --genotypemergeoption PRIORITIZE --rod_priority_list "foo,bar" 
java -jar $GATK -T SelectVariants -R /Molly/barbitoff/reference/GATK_b37/human_g1k_v37.fasta -V ${PREFIX}.F3.vcf -o ${PREFIX}.out.vcf -se "vc.IsNotFiltered()" --excludeNonVariants

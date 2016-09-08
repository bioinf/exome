# Applying recalibration - straightforward

# INPUTS: prefix of VCF files and recal files to use
# INPUTS: mode (SNP/INDEL)
# INPUTS: truth score threshold for variant filtration

PREFIX=$1
MODE=$2
TSCORE=$3

if [[ $MODE = "SNP" ]]
then
    echo 'I am here'
    java -Xmx64g -jar /Molly/barbitoff/software/gatk-protected/target/GenomeAnalysisTK.jar -T ApplyRecalibration \
        -R /Molly/barbitoff/reference/GATK_b37/human_g1k_v37.fasta \
        -input ${PREFIX}.raw.vcf \
        -mode SNP \
        -recalFile ${PREFIX}.snp.recal \
        -tranchesFile ${PREFIX}.snp.tranches \
        -o ${PREFIX}.snp.recal.vcf \
        -ts_filter_level $TSCORE
else
    echo 'I am strangely not here'
    java -Xmx64g -jar /Molly/barbitoff/software/gatk-protected/target/GenomeAnalysisTK.jar -T ApplyRecalibration \
        -R /Molly/barbitoff/reference/GATK_b37/human_g1k_v37.fasta \
        -input ${PREFIX}.snp.recal.vcf \
        -mode INDEL \
        -recalFile ${PREFIX}.indel.recal \
        -tranchesFile ${PREFIX}.indel.tranches \
        -o ${PREFIX}.recal.vcf \
        -ts_filter_level $TSCORE \
    # FILTERING ALL PASS FILTERING SITES FROM THE CALLSET
    mkdir vqsr
    java -Xmx64g -jar /Molly/barbitoff/software/gatk-protected/target/GenomeAnalysisTK.jar -T SelectVariants -R /Molly/barbitoff/reference/GATK_b37/human_g1k_v37.fasta -V ${PREFIX}.recal.vcf -select 'vc.isNotFiltered()' -o ${PREFIX}.out.vcf
    mv *.recal* vqsr/
    mv *tranches* vqsr/
    mv *.plots.* vqsr/
    mv *.raw* vqsr/
fi


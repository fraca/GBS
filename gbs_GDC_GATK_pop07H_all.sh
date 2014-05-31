#!/bin/bash

array=(07H03 07H10 07H11 07H15 07H16 07H17 07H18_uni 07H19 07H20_uni 07H22 07H24 07H25 07H26 07H28)
len=${#array[*]}
  
 
  
#RealignerTargetCreator
java -jar /usr/local/GenomeAnalysisTK-2.7-2/GenomeAnalysisTK.jar -T RealignerTargetCreator -R /gdc_home3/marcof/Genome/Araly1_assembly_scaffolds.fasta -I bams_rg/07H03.bam -I bams_rg/07H10.bam -I bams_rg/07H11.bam -I bams_rg/07H15.bam -I bams_rg/07H16.bam -I bams_rg/07H17.bam -I bams_rg/07H18_uni.bam -I bams_rg/07H19.bam -I bams_rg/07H20_uni.bam -I bams_rg/07H22.bam -I bams_rg/07H24.bam -I bams_rg/07H25.bam -I bams_rg/07H26.bam -I bams_rg/07H28.bam -o temp.indelrealigner.intervals




i=0
while [ $i -lt $len ]; do
echo "$i: ${array[$i]}"

#IndelRealigner
java -jar /usr/local/GenomeAnalysisTK-2.7-2/GenomeAnalysisTK.jar -T IndelRealigner -R /gdc_home3/marcof/Genome/Araly1_assembly_scaffolds.fasta -I bams_rg/${array[$i]}.bam -targetIntervals temp.indelrealigner.intervals -o ${array[$i]}_temp3.bam

let i++
done  

#UnifiedGenotyper
java -Xmx5000m -jar /usr/local/GenomeAnalysisTK-2.7-2/GenomeAnalysisTK.jar -T UnifiedGenotyper -nct 4 -nt 4 --sample_ploidy 2 -stand_call_conf 20 -stand_emit_conf 20 -R /gdc_home3/marcof/Genome/Araly1_assembly_scaffolds.fasta -I 07H03_temp3.bam -I 07H10_temp3.bam -I 07H11_temp3.bam -I 07H15_temp3.bam -I 07H16_temp3.bam -I 07H17_temp3.bam -I 07H18_uni_temp3.bam -I 07H19_temp3.bam -I 07H20_uni_temp3.bam -I 07H22_temp3.bam -I 07H24_temp3.bam -I 07H25_temp3.bam -I 07H26_temp3.bam -I 07H28_temp3.bam -o temp.vcf

#variant filtration
java -Xmx2g -jar /usr/local/GenomeAnalysisTK-2.7-2/GenomeAnalysisTK.jar \
    -R /gdc_home3/marcof/Genome/Araly1_assembly_scaffolds.fasta \
    -T VariantFiltration \
    -o temp_filter.vcf \
    --variant temp.vcf \
    --filterExpression "QUAL < 20 || DP < 5" \
    --filterName "QUAL20_DP5"


#BaseRecalibrator
java -Xmx2g -jar /usr/local/GenomeAnalysisTK-2.7-2/GenomeAnalysisTK.jar \
  -T BaseRecalibrator \
  -I 07H03_temp3.bam \
  -I 07H10_temp3.bam \
  -I 07H11_temp3.bam \
  -I 07H15_temp3.bam \
  -I 07H16_temp3.bam \
  -I 07H17_temp3.bam \
  -I 07H18_uni_temp3.bam \
  -I 07H19_temp3.bam \
  -I 07H20_uni_temp3.bam \
  -I 07H22_temp3.bam \
  -I 07H24_temp3.bam \
  -I 07H25_temp3.bam \
  -I 07H26_temp3.bam \
  -I 07H28_temp3.bam \
  -R /gdc_home3/marcof/Genome/Araly1_assembly_scaffolds.fasta \
  -knownSites temp_filter.vcf \
  -o temp.table
   
#rm temp_filter.vcf

mkdir bams_ok

i=0
while [ $i -lt $len ]; do
echo "$i: ${array[$i]}"

#PrintReads
  java -jar /usr/local/GenomeAnalysisTK-2.7-2/GenomeAnalysisTK.jar -T PrintReads -R /gdc_home3/marcof/Genome/Araly1_assembly_scaffolds.fasta -I ${array[$i]}_temp3.bam -BQSR temp.table -o bams_ok/${array[$i]}.bam
  
let i++
done


##da qui rifare
#UnifiedGenotyper
java -Xmx5000m -jar /usr/local/GenomeAnalysisTK-2.7-2/GenomeAnalysisTK.jar -T UnifiedGenotyper -nct 4 -nt 4 --sample_ploidy 2 -stand_call_conf 20 -stand_emit_conf 20 -R /gdc_home3/marcof/Genome/Araly1_assembly_scaffolds.fasta -I bams_ok/07H03.bam -I bams_ok/07H10.bam -I bams_ok/07H11.bam -I bams_ok/07H15.bam -I bams_ok/07H16.bam -I bams_ok/07H17.bam -I bams_ok/07H18_uni.bam -I bams_ok/07H19.bam -I bams_ok/07H20_uni.bam -I bams_ok/07H22.bam -I bams_ok/07H24.bam -I bams_ok/07H25.bam -I bams_ok/07H26.bam -I bams_ok/07H28.bam -o GBS.vcf


#variant filtration
java -Xmx2g -jar /usr/local/GenomeAnalysisTK-2.7-2/GenomeAnalysisTK.jar \
  -R /gdc_home3/marcof/Genome/Araly1_assembly_scaffolds.fasta \
  -T VariantFiltration \
  -o GBS_p07H_GATK_all.vcf \
  --variant GBS.vcf \
  --filterExpression "QUAL < 20 || DP < 5" \
  --filterName "QUAL20_DP5"

  

#rm *_temp.bam
#rm temp_metrics
#rm *_temp2.bam
#rm temp_filter.vcf
#rm *_temp3.bam
#rm temp.table


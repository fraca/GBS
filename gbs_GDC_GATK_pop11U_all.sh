#!/bin/bash

array=(11U01 11U02 11U04 11U07_uni 11U09 11U10_uni 11U12 11U13_uni 11U14 11U15 11U16_uni 11U17 11U18 11U19_uni 11U20_uni 11U21 11U22 11U23_uni 11U24 11U25_uni 11U26 11U27_uni 11U28 11U29 11U30)
len=${#array[*]}

 
  
#RealignerTargetCreator
java -jar /usr/local/GenomeAnalysisTK-2.7-2/GenomeAnalysisTK.jar -T RealignerTargetCreator -R /gdc_home3/marcof/Genome/Araly1_assembly_scaffolds.fasta -I bams_rg/11U01.bam -I bams_rg/11U02.bam -I bams_rg/11U04.bam -I bams_rg/11U07_uni.bam -I bams_rg/11U09.bam -I bams_rg/11U10_uni.bam -I bams_rg/11U12.bam -I bams_rg/11U13_uni.bam -I bams_rg/11U14.bam -I bams_rg/11U15.bam -I bams_rg/11U16_uni.bam -I bams_rg/11U17.bam -I bams_rg/11U18.bam -I bams_rg/11U19_uni.bam -I bams_rg/11U20_uni.bam -I bams_rg/11U21.bam -I bams_rg/11U22.bam -I bams_rg/11U23_uni.bam -I bams_rg/11U24.bam -I bams_rg/11U25_uni.bam -I bams_rg/11U26.bam -I bams_rg/11U27_uni.bam -I bams_rg/11U28.bam -I bams_rg/11U29.bam -I bams_rg/11U30.bam -o temp.indelrealigner_pop11U.intervals




i=0
while [ $i -lt $len ]; do
echo "$i: ${array[$i]}"

#IndelRealigner
java -jar /usr/local/GenomeAnalysisTK-2.7-2/GenomeAnalysisTK.jar -T IndelRealigner -R /gdc_home3/marcof/Genome/Araly1_assembly_scaffolds.fasta -I bams_rg/${array[$i]}.bam -targetIntervals temp.indelrealigner_pop11U.intervals -o ${array[$i]}_temp3.bam

let i++
done  

#UnifiedGenotyper
java -Xmx5000m -jar /usr/local/GenomeAnalysisTK-2.7-2/GenomeAnalysisTK.jar -T UnifiedGenotyper -nct 4 -nt 4 --sample_ploidy 2 -stand_call_conf 20 -stand_emit_conf 20 -R /gdc_home3/marcof/Genome/Araly1_assembly_scaffolds.fasta -I 11U01_temp3.bam -I 11U02_temp3.bam -I 11U04_temp3.bam -I 11U07_uni_temp3.bam -I 11U09_temp3.bam -I 11U10_uni_temp3.bam -I 11U12_temp3.bam -I 11U13_uni_temp3.bam -I 11U14_temp3.bam -I 11U15_temp3.bam -I 11U16_uni_temp3.bam -I 11U17_temp3.bam -I 11U18_temp3.bam -I 11U19_uni_temp3.bam -I 11U20_uni_temp3.bam -I 11U21_temp3.bam -I 11U22_temp3.bam -I 11U23_uni_temp3.bam -I 11U24_temp3.bam -I 11U25_uni_temp3.bam -I 11U26_temp3.bam -I 11U27_uni_temp3.bam -I 11U28_temp3.bam -I 11U29_temp3.bam -I 11U30_temp3.bam -o temp_pop11U.vcf

#variant filtration
java -Xmx2g -jar /usr/local/GenomeAnalysisTK-2.7-2/GenomeAnalysisTK.jar \
    -R /gdc_home3/marcof/Genome/Araly1_assembly_scaffolds.fasta \
    -T VariantFiltration \
    -o temp_filter_pop11U.vcf \
    --variant temp_pop11U.vcf \
    --filterExpression "QUAL < 20 || DP < 5" \
    --filterName "QUAL20_DP5"


#BaseRecalibrator
java -Xmx2g -jar /usr/local/GenomeAnalysisTK-2.7-2/GenomeAnalysisTK.jar \
  -T BaseRecalibrator \
  -I 11U01_temp3.bam \
  -I 11U02_temp3.bam \
  -I 11U04_temp3.bam \
  -I 11U07_uni_temp3.bam \
  -I 11U09_temp3.bam \
  -I 11U10_uni_temp3.bam \
  -I 11U12_temp3.bam \
  -I 11U13_uni_temp3.bam \
  -I 11U14_temp3.bam \
  -I 11U15_temp3.bam \
  -I 11U16_uni_temp3.bam \
  -I 11U17_temp3.bam \
  -I 11U18_temp3.bam \
  -I 11U19_uni_temp3.bam \
  -I 11U20_uni_temp3.bam \
  -I 11U21_temp3.bam \
  -I 11U22_temp3.bam \
  -I 11U23_uni_temp3.bam \
  -I 11U24_temp3.bam \
  -I 11U25_uni_temp3.bam \
  -I 11U26_temp3.bam \
  -I 11U27_uni_temp3.bam \
  -I 11U28_temp3.bam \
  -I 11U29_temp3.bam \
  -I 11U30_temp3.bam \
  -R /gdc_home3/marcof/Genome/Araly1_assembly_scaffolds.fasta \
  -knownSites temp_filter_pop11U.vcf \
  -o temp.table_pop11U
   
#rm temp_filter.vcf

mkdir bams_ok

i=0
while [ $i -lt $len ]; do
echo "$i: ${array[$i]}"

#PrintReads
  java -jar /usr/local/GenomeAnalysisTK-2.7-2/GenomeAnalysisTK.jar -T PrintReads -R /gdc_home3/marcof/Genome/Araly1_assembly_scaffolds.fasta -I ${array[$i]}_temp3.bam -BQSR temp.table_pop11U -o bams_ok/${array[$i]}.bam
  
let i++
done



#UnifiedGenotyper
java -Xmx5000m -jar /usr/local/GenomeAnalysisTK-2.7-2/GenomeAnalysisTK.jar -T UnifiedGenotyper -nct 4 -nt 4 --sample_ploidy 2 -stand_call_conf 20 -stand_emit_conf 20 -R /gdc_home3/marcof/Genome/Araly1_assembly_scaffolds.fasta -I bams_ok/11U01.bam -I bams_ok/11U02.bam -I bams_ok/11U04.bam -I bams_ok/11U07_uni.bam -I bams_ok/11U09.bam -I bams_ok/11U10_uni.bam -I bams_ok/11U12.bam -I bams_ok/11U13_uni.bam -I bams_ok/11U14.bam -I bams_ok/11U15.bam -I bams_ok/11U16_uni.bam -I bams_ok/11U17.bam -I bams_ok/11U18.bam -I bams_ok/11U19_uni.bam -I bams_ok/11U20_uni.bam -I bams_ok/11U21.bam -I bams_ok/11U22.bam -I bams_ok/11U23_uni.bam -I bams_ok/11U24.bam -I bams_ok/11U25_uni.bam -I bams_ok/11U26.bam -I bams_ok/11U27_uni.bam -I bams_ok/11U28.bam -I bams_ok/11U29.bam -I bams_ok/11U30.bam -o GBS_pop11U.vcf


#variant filtration
java -Xmx2g -jar /usr/local/GenomeAnalysisTK-2.7-2/GenomeAnalysisTK.jar \
  -R /gdc_home3/marcof/Genome/Araly1_assembly_scaffolds.fasta \
  -T VariantFiltration \
  -o GBS_p11U_GATK_all.vcf \
  --variant GBS_pop11U.vcf \
  --filterExpression "QUAL < 20 || DP < 5" \
  --filterName "QUAL20_DP5"

  

#rm *_temp.bam
#rm temp_metrics
#rm *_temp2.bam
#rm temp_filter.vcf
#rm *_temp3.bam
#rm temp.table


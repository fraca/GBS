#########################################################################
#########################################################################
Pipeline x GBS data 
#########################################################################
#########################################################################

Pipeline for analyze Genome By Sequencing data ( NGS technique based on restiction enzyme).

Quality control with FastQC.
Demultiplexing with preprocess_radtags (Stacks), based on barcode and cutting siteof the restriction enyme.
Alignment to A. lyrata genome v1.0 (BWA-MEM)
Removing duplicate (Picard tools)
Selecting reads with MAPQ when > 20 (samtools)
SNP Calling:
Clean and sort with picard-tools
GATK RealignerTargetCreator and IndelRealigner
GATK UnifiedGenotyper to get an initial good set of SNPs
GATK  BaseRecalibrator to get a recalibrated mapping file
GATK UnifiedGenotyper again on this recalibrated file
Filter the results for quality and coverage
In-house R script (gbs_gatk) to calculate SNP population frequencies

Software used:

- process_radtags (Stacks, Catchen et al. 2013)
- trim-fastq.pl (Popoolation, Kofler et al. 2012)
- bwa mem (bwa, Li et al. 2013)
- samtools (samtools, Li et al. 2009)
- SortSam.jar (Picard tools, http://picard.sourceforge.net)
- MarkDuplicates.jar (Picard tools, http://picard.sourceforge.net)
- GATK (GATK McKenna et al. 2010)

scripts:

GBS_april1.sh
dempultiplexing of the fastq files.

GBS_april2.sh
Trimming, Alignement and remove duplicate.
Create bams files for each sample.

GBS_april4.sh
Create mpileup file (to see all position covered).


gbs_GDC_GATK_pop07H_all.sh
SNP calling with the GATK recommended pipeline for the 14 individuals of population 07H.

gbs_GDC_GATK_pop11U_all.sh
SNP calling with the GATK recommended pipeline for the 25 individuals of population 11U.


GBS
==============

Pipeline for analyze Genome By Sequencing data ( NGS technique based on restiction enzyme).



- Demultiplexing with preprocess_radtags (Stacks), based on barcode and cutting site of the restriction enzyme.
- Trimming with trim-fastq.pl (Popoolation).
- Alignment to A. lyrata genome v1.0 (BWA-MEM).
- Removing duplicate (Picard tools).
- Selecting reads with MAPQ when > 20 (samtools).
- SNP calling with Varscan.

Software used:

- process_radtags (Stacks, Catchen et al. 2013)
- trim-fastq.pl (Popoolation, Kofler et al. 2012)
- BWA MEM (Li et al. 2013)
- samtools (samtools, Li et al. 2009)
- SortSam.jar (Picard tools, http://picard.sourceforge.net)
- MarkDuplicates.jar (Picard tools, http://picard.sourceforge.net)
- genomeCoverageBed (Bedtools, Quinlan & Hall 2010)
- mpileup2snp (Varscan, Kobolt et al. 2012)

scripts:

- 1) GBS_demultiplex.sh
dempultiplexing and trimming of the fastq files.

- 2) GBS_alignment.sh
Alignment, remove duplicate, selecting proper aligned reads.
Coverage calculations.
Create bams files for each sample.

- 3) GBS_SNPcall.sh
SNP calling with Varscan.




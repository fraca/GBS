GBS
==============

Pipeline for analyzing Genotyping-By-Sequencing pair-end data (NGS technique based on digest by restiction enzyme).

M. Fracassetti, P. C. Griffin and Y. Willi (2015). Validation of pooled whole-genome re-sequencing in *Arabidopsis lyrata*. Manuscript submitted for publication.
 


- Demultiplexing with preprocess_radtags (Stacks), based on barcode and cutting site of the restriction enzyme.
- Trimming with trim-fastq.pl (PoPoolation).
- Alignment to Arabidopsis lyrata genome v1.0 (BWA-MEM).
- Removal of duplicates (Picard tools).
- Selection of reads with MAPQ >20 (SAMtools).
- SNP calling with VarScan.

Software used:

- process_radtags (Stacks, Catchen et al. 2013)
- trim-fastq.pl (PoPoolation, Kofler et al. 2012)
- bwa mem (BWA Li et al. 2013)
- samtools (SAMtools, Li et al. 2009)
- SortSam.jar (Picard tools, http://picard.sourceforge.net)
- MarkDuplicates.jar (Picard tools, http://picard.sourceforge.net)
- genomeCoverageBed (BEDTools, Quinlan & Hall 2010)
- mpileup2snp (VarScan, Kobolt et al. 2012)

Run the following scripts:

1. **GBS_demultiplex.sh** dempultiplexing and trimming of the fastq files.

2. **GBS_alignment.sh** Alignment, removal of duplicates, selection of properly aligned reads. Coverage calculations. Creation of bam files for each sample.

3. **GBS_SNPcall.sh** SNP calling with VarScan.

Fracassetti M, Griffin PC, Willi Y (2015) Validation of Pooled Whole-Genome Re-Sequencing in Arabidopsis lyrata (U Melcher, Ed,). PLOS ONE, 10, e0140462.


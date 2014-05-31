#! /bin/bash

# Request "/bin/bash" as shell
#$ -S /bin/bash

# Give a job name
#$ -N GBS_april4

# Start the job from the current working directory
#$ -cwd

# Merge standard output and standard error
#$ -j y

# Redirect standard output (default is <JOB_NAME>.o<JOB_ID>)
#$ -o GBS_april4.out

# Set parallel environement (pe): shared memory with 4 cores
#    (number of cores is stored in variable NSLOTS)
#$ -pe smp 1

# Set the queue for the job: any queue on machine "smp" (kepler)
#$ -q *@smp

# Wait until job named helloFirst is finished
#$ -hold_jid GBS_april3


###############################################################################

#### input and file needed ######

# barcode directory /scratch/fracassettim/lane_input/barcode/
# check EOF for each barcode

bin_dir="/home/fracassettim/pipe_bin/"
path_gen="/scratch/fracassettim/Genome_Alyrata/Araly1_assembly_scaffolds.fasta"



###############################################################################


samtools mpileup -f $path_gen bams/07H03.bam bams/07H15.bam bams/07H18_uni.bam bams/07H22.bam bams/07H26.bam bams/07H10.bam bams/07H16.bam bams/07H19.bam bams/07H24.bam bams/07H28.bam bams/07H11.bam bams/07H17.bam bams/07H20_uni.bam bams/07H25.bam  > pop07H.mpileup

grep '[[:blank:]][*][[:blank:]]' -v pop07H.mpileup > pop07H_corto.mpileup



samtools mpileup -f $path_gen bams/11U01.bam bams/11U10_uni.bam bams/11U16_uni.bam bams/11U21.bam bams/11U26.bam bams/11U02.bam bams/11U12.bam bams/11U17.bam bams/11U22.bam bams/11U27_uni.bam bams/11U04.bam bams/11U13_uni.bam bams/11U18.bam bams/11U23_uni.bam bams/11U28.bam bams/11U07_uni.bam bams/11U14.bam bams/11U19_uni.bam bams/11U24.bam bams/11U29.bam bams/11U09.bam bams/11U15.bam bams/11U20_uni.bam bams/11U25_uni.bam bams/11U30.bam > pop11U.mpileup

grep '[[:blank:]][*][[:blank:]]' -v pop11U.mpileup > pop11U_corto.mpileup




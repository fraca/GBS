#! /bin/bash

# Request "/bin/bash" as shell
#$ -S /bin/bash

# Give a job name
#$ -N GBS_april1

# Start the job from the current working directory
#$ -cwd

# Merge standard output and standard error
#$ -j y

# Redirect standard output (default is <JOB_NAME>.o<JOB_ID>)
#$ -o GBS_april1.out

# Set parallel environement (pe): shared memory with 4 cores
#    (number of cores is stored in variable NSLOTS)
#$ -pe smp 1

# Set the queue for the job: any queue on machine "smp" (kepler)
#$ -q *@smp

###############################################################################

#### input and file needed ######

# barcode directory /scratch/fracassettim/lane_input/barcode/
# check EOF for each barcode

bin_dir="/home/fracassettim/pipe_bin/"
path_gen="/scratch/fracassettim/Genome_Alyrata/Araly1_assembly_scaffolds.fasta"



###############################################################################

# chose to merge the lane from begin, more simple and better for find snp share between more individuals

cat /scratch/fracassettim/lane_input/lane4_Undetermined_L004_R1_001.fastq /scratch/fracassettim/lane_input/lane5_Undetermined_L005_R1_001.fastq > R1.fq

cat /scratch/fracassettim/lane_input/lane4_Undetermined_L004_R2_001.fastq /scratch/fracassettim/lane_input/lane5_Undetermined_L005_R2_001.fastq > R2.fq


mkdir demulti

for file in /scratch/fracassettim/lane_input/barcode/*
do

  $bin_dir"process_radtags" -1 R1.fq -2 R2.fq -o demulti/ -b $file -e mspI -c -q -r -E phred33

done

rm R1.fq R2.fq


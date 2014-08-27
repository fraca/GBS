#! /bin/bash

# Request "/bin/bash" as shell
#$ -S /bin/bash

# Give a job name
#$ -N GBS_demultiplex

# Start the job from the current working directory
#$ -cwd

# Merge standard output and standard error
#$ -j y

# Redirect standard output (default is <JOB_NAME>.o<JOB_ID>)
#$ -o GBS_demultiplex.out

# Set parallel environement (pe): shared memory with 4 cores
#    (number of cores is stored in variable NSLOTS)
#$ -pe smp 2

# Set the queue for the job: any queue on machine "smp" (kepler)
#$ -q *@smp

###############################################################################

#### input and file needed ######

# barcode directory /scratch/fracassettim/lane_input/barcode/
# check EOF for each barcode

bin_dir="/home/fracassettim/pipe_bin/"



###############################################################################

# chose to merge the lane from begin, more simple and better for find snp share between more individuals

##to change the directory

gunzip lane*

cat lane4_Undetermined_L004_R1_001.fastq lane5_Undetermined_L005_R1_001.fastq > R1.fq

cat lane4_Undetermined_L004_R2_001.fastq lane5_Undetermined_L005_R2_001.fastq > R2.fq


mkdir demulti

##to change the directory
for file in barcode/*
do

  $bin_dir"process_radtags" -1 R1.fq -2 R2.fq -o demulti/ -b $file -e mspI -c -q -r -E phred33 --adapter_1 GATCGGAAGAGCGGTTCAGCAGGAATGCCGAGACCGATCTCGTATGCCGTCTTCTGCTTG --adapter_2 AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGTAGATCTCGGTGGTCGCCGTATCATT --adapter_mm 2

done

rm lane*
#rm R1.fq R2.fq

mkdir demulti_filt

##to change the directory
while IFS= read -r lineA && IFS= read -r lineB <&3; do
  echo "$lineA" "$lineB";
  ###da fare
  perl $bin_dir"basic-pipeline/trim-fastq.pl" --input1 demulti/sample_$lineA.1.fq --input2 demulti/sample_$lineA.2.fq --output demulti_filt/$lineA  --quality-threshold 20 --min-length 50 --no-5p-trim --disable-zipped-output --fastq-type sanger
  
done <barcode_nj.txt 3<nomi_nj.txt


#rm demulti



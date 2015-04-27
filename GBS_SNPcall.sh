#! /bin/bash

# Request "/bin/bash" as shell
#$ -S /bin/bash

# Give a job name
#$ -N GBS_SNPcall

# Start the job from the current working directory
#$ -cwd

# Merge standard output and standard error
#$ -j y

# Redirect standard output (default is <JOB_NAME>.o<JOB_ID>)
#$ -o GBS_SNPcall.out

# Set parallel environement (pe): shared memory with 4 cores
#    (number of cores is stored in variable NSLOTS)
#$ -pe smp 2

# Set the queue for the job: any queue on machine "smp" (kepler)
#$ -q *@smp

# Wait until job named helloFirst is finished
#$ -hold_jid GBS_alignment


###############################################################################

#### input and file needed ######

# barcode directory /scratch/fracassettim/lane_input/barcode/
# check EOF for each barcode

bin_dir="/scratch/fracassettim/pipe_bin/"
path_gen="/scratch/fracassettim/Genomes/Alyrata_18_P_thaliana"
n_threads=2

###############################################################################


###pop07H

samtools mpileup -B -Q 0 -R -d 500 -f $path_gen".fasta" bams/07H03.bam bams/07H15.bam bams/07H18_with_HpaII.bam bams/07H22.bam bams/07H26.bam bams/07H10.bam bams/07H16.bam bams/07H19.bam bams/07H24.bam bams/07H28.bam bams/07H11.bam bams/07H17.bam bams/07H20_with_HpaII.bam bams/07H25.bam  > pop07H.mpileup

#grep '[[:blank:]][*][[:blank:]]' -v pop07H.mpileup | awk '{print $1"_"$2}' > p07H_all.pos

awk '$4 >= 5 && $7 >= 5 && $10 >= 5 && $13 >= 5 && $16 >= 5 && $19 >= 5 && $22 >= 5 && $25 >= 5 && $28 >= 5 && $31 >= 5 && $34 >= 5 && $37 >= 5 && $40 >= 5 && $43 >= 5 && $4 <= 500 && $7 <= 500 && $10 <= 500 && $13 <= 500 && $16 <= 500 && $19 <= 500 && $22 <= 500 && $25 <= 500 && $28 <= 500 && $31 <= 500 && $34 <= 500 && $37 <= 500 && $40 <= 500 && $43 <= 500 {print $1" "$2}' pop07H.mpileup > p07H_5_500.pos
grep ^scaffold p07H_5_500.pos > temp
mv temp p07H_5_500.pos

awk '$4 >= 1 && $7 >= 1 && $10 >= 1 && $13 >= 1 && $16 >= 1 && $19 >= 1 && $22 >= 1 && $25 >= 1 && $28 >= 1 && $31 >= 1 && $34 >= 1 && $37 >= 1 && $40 >= 1 && $43 >= 1 && $4 <= 500 && $7 <= 500 && $10 <= 500 && $13 <= 500 && $16 <= 500 && $19 <= 500 && $22 <= 500 && $25 <= 500 && $28 <= 500 && $31 <= 500 && $34 <= 500 && $37 <= 500 && $40 <= 500 && $43 <= 500 {print $1" "$2}' pop07H.mpileup > p07H_1_500.pos
grep ^scaffold p07H_1_500.pos > temp
mv temp p07H_1_500.pos


java -Xmx2g -jar $bin_dir"VarScan.v2.3.7.jar" mpileup2snp pop07H.mpileup --min-coverage 5 --min-reads2 2 --min-avg-qual 20 --p-value 0.05 > pop07H.varscan

awk '$10 == 0 && $4 !~/,/ { print $1 "_" $2 " " $3 " " $4 " " ($8+($9*2))/(($7+$8+$9)*2)}' pop07H.varscan > GBS_p07H_all.freq

awk '$10 <= 1 && $4 !~/,/ { print $1 "_" $2 " " $3 " " $4 " " ($8+($9*2))/(($7+$8+$9)*2)}' pop07H.varscan > GBS_p07H_10miss.freq # 10 % missing 1.4

awk '$10 <= 2 && $4 !~/,/ { print $1 "_" $2 " " $3 " " $4 " " ($8+($9*2))/(($7+$8+$9)*2)}' pop07H.varscan > GBS_p07H_20miss.freq # 20 % missing 2.8

awk '$10 <= 7 && $4 !~/,/ { print $1 "_" $2 " " $3 " " $4 " " ($8+($9*2))/(($7+$8+$9)*2)}' pop07H.varscan > GBS_p07H_50miss.freq # 50 % 

grep ^scaffold GBS_p07H_all.freq > temp
mv temp GBS_p07H_all.freq

grep ^scaffold GBS_p07H_10miss.freq > temp
mv temp GBS_p07H_10miss.freq

grep ^scaffold GBS_p07H_20miss.freq > temp
mv temp GBS_p07H_20miss.freq

grep ^scaffold GBS_p07H_50miss.freq > temp
mv temp GBS_p07H_50miss.freq


###pop11U

samtools mpileup -B -Q 0 -R -d 500 -f $path_gen".fasta" bams/11U01.bam bams/11U10_with_HpaII.bam bams/11U16.bam bams/11U21.bam bams/11U26.bam bams/11U02.bam bams/11U12.bam bams/11U17.bam bams/11U22.bam bams/11U27.bam bams/11U04.bam bams/11U13.bam bams/11U18.bam bams/11U23_with_HpaII.bam bams/11U28.bam bams/11U07_with_HpaII.bam bams/11U14.bam bams/11U19.bam bams/11U24.bam bams/11U29.bam bams/11U09.bam bams/11U15.bam bams/11U20_with_HpaII.bam bams/11U25.bam bams/11U30.bam > pop11U.mpileup

#grep '[[:blank:]][*][[:blank:]]' -v pop11U.mpileup | awk '{print $1"_"$2}' > p11U_all.pos

awk '$4 >= 5 && $7 >= 5 && $10 >= 5 && $13 >= 5 && $16 >= 5 && $19 >= 5 && $22 >= 5 && $25 >= 5 && $28 >= 5 && $31 >= 5 && $34 >= 5 && $37 >= 5 && $40 >= 5 && $43 >= 5 && $46 >= 5 && $49 >= 5 && $52 >= 5 && $55 >= 5 && $58 >= 5 && $61 >= 5 && $64 >= 5 && $67 >= 5 && $70 >= 5 && $73 >= 5 && $76 >= 5 && $4 <= 500 && $7 <= 500 && $10 <= 500 && $13 <= 500 && $16 <= 500 && $19 <= 500 && $22 <= 500 && $25 <= 500 && $28 <= 500 && $31 <= 500 && $34 <= 500 && $37 <= 500 && $40 <= 500 && $43 <= 500 && $46 <= 500 && $49 <= 500 && $52 <= 500 && $55 <= 500 && $58 <= 500 && $61 <= 500 && $64 <= 500 && $67 <= 500 && $70 <= 500 && $73 <= 500 && $76 <= 500 {print $1" "$2}' pop11U.mpileup > p11U_5_500.pos
grep ^scaffold p11U_5_500.pos > temp
mv temp p11U_5_500.pos

awk '$4 >= 1 && $7 >= 1 && $10 >= 1 && $13 >= 1 && $16 >= 1 && $19 >= 1 && $22 >= 1 && $25 >= 1 && $28 >= 1 && $31 >= 1 && $34 >= 1 && $37 >= 1 && $40 >= 1 && $43 >= 1 && $46 >= 1 && $49 >= 1 && $52 >= 1 && $55 >= 1 && $58 >= 1 && $61 >= 1 && $64 >= 1 && $67 >= 1 && $70 >= 1 && $73 >= 1 && $76 >= 1 && $4 <= 500 && $7 <= 500 && $10 <= 500 && $13 <= 500 && $16 <= 500 && $19 <= 500 && $22 <= 500 && $25 <= 500 && $28 <= 500 && $31 <= 500 && $34 <= 500 && $37 <= 500 && $40 <= 500 && $43 <= 500 && $46 <= 500 && $49 <= 500 && $52 <= 500 && $55 <= 500 && $58 <= 500 && $61 <= 500 && $64 <= 500 && $67 <= 500 && $70 <= 500 && $73 <= 500 && $76 <= 500 {print $1" "$2}' pop11U.mpileup > p11U_1_500.pos
grep ^scaffold p11U_1_500.pos > temp
mv temp p11U_1_500.pos



java -Xmx2g -jar $bin_dir"VarScan.v2.3.7.jar" mpileup2snp pop11U.mpileup --min-coverage 5 --min-reads2 2 --min-avg-qual 20 --p-value 0.05 > pop11U.varscan

awk '$10 == 0 && $4 !~/,/ { print $1 "_" $2 " " $3 " " $4 " " ($8+($9*2))/(($7+$8+$9)*2)}' pop11U.varscan > GBS_p11U_all.freq

awk '$10 <= 2 && $4 !~/,/ { print $1 "_" $2 " " $3 " " $4 " " ($8+($9*2))/(($7+$8+$9)*2)}' pop11U.varscan > GBS_p11U_10miss.freq # 10 % missing 2.5

awk '$10 <= 5 && $4 !~/,/ { print $1 "_" $2 " " $3 " " $4 " " ($8+($9*2))/(($7+$8+$9)*2)}' pop11U.varscan > GBS_p11U_20miss.freq # 20 % missing 5

awk '$10 <= 13 && $4 !~/,/ { print $1 "_" $2 " " $3 " " $4 " " ($8+($9*2))/(($7+$8+$9)*2)}' pop11U.varscan > GBS_p11U_50miss.freq # 50 % missing 5



grep ^scaffold GBS_p11U_all.freq > temp
mv temp GBS_p11U_all.freq

grep ^scaffold GBS_p11U_10miss.freq > temp
mv temp GBS_p11U_10miss.freq

grep ^scaffold GBS_p11U_20miss.freq > temp
mv temp GBS_p11U_20miss.freq

grep ^scaffold GBS_p11U_50miss.freq > temp
mv temp GBS_p11U_50miss.freq


#! /bin/bash

# Request "/bin/bash" as shell
#$ -S /bin/bash

# Give a job name
#$ -N GBS_alignment

# Start the job from the current working directory
#$ -cwd

# Merge standard output and standard error
#$ -j y

# Redirect standard output (default is <JOB_NAME>.o<JOB_ID>)
#$ -o GBS_alignment.out

# Set parallel environement (pe): shared memory with 4 cores
#    (number of cores is stored in variable NSLOTS)
#$ -pe smp 20

# Set the queue for the job: any queue on machine "smp" (kepler)
#$ -q *@smp

# Wait until job named helloFirst is finished
#$ -hold_jid GBS_demultiplex


###############################################################################

#### input and file needed ######

# barcode directory /scratch/fracassettim/lane_input/barcode/
# check EOF for each barcode

bin_dir="/home/fracassettim/pipe_bin/"
path_gen="/scratch/fracassettim/Genomes/Alyrata_18_P_thaliana"
n_threads=20


###############################################################################

echo "Deep read min 5 max 500" > GBS_5dp_cov
echo -e "ind average_deep_read tpercentual_covered" >> GBS_5dp_cov

echo "Deep read min 2 max 500" > GBS_2dp_cov
echo -e "ind average_deep_read tpercentual_covered" >> GBS_2dp_cov

mkdir bams


while IFS= read -r lineA && IFS= read -r lineB <&3; do
  echo "$lineA" "$lineB";
  ###da fare
  bwa mem -t $n_threads $path_gen".fasta" demulti_filt/$lineA"_1" demulti_filt/$lineA"_2" > bla.sam

  samtools view -@ $n_threads -Sb bla.sam > bla.bam

  java -Xmx2g -jar $bin_dir"SortSam.jar" I=bla.bam O=bla_sort.bam VALIDATION_STRINGENCY=SILENT SO=coordinate
 
  samtools index bla_sort.bam

  samtools view -@ $n_threads -q 20 -f 0x0002 -F 0x0004 -F 0x0008 -b bla_sort.bam > bla_filt.bam

  samtools index bla_filt.bam
  
  java -Xmx2g -jar $bin_dir"MarkDuplicates.jar" I=bla_filt.bam O=bams/$lineB.bam M=dupstat.txt VALIDATION_STRINGENCY=SILENT REMOVE_DUPLICATES=true CREATE_INDEX=true

  samtools index bams/$lineB.bam      
  
  $bin_dir"/bedtools/genomeCoverageBed" -ibam "bams/"$lineB".bam" | grep "^genome" > temp_cov
  
  awk -vind="$lineB" ' {if($2>=5 && $2<=500) {{bla+=$5; mpond+=$2*$3; sum+=$3}}} END { print  ind, bla, mpond/sum}' temp_cov >> GBS_5dp_cov
  awk -vind="$lineB" ' {if($2>=2 && $2<=500) {{bla+=$5; mpond+=$2*$3; sum+=$3}}} END { print  ind, bla, mpond/sum}' temp_cov >> GBS_2dp_cov
  rm temp_cov
  
done <barcode_nj.txt 3<nomi_nj.txt

rm *.sam *.bam *.bai


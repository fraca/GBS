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

  java -Xmx2g -jar $bin_dir"MarkDuplicates.jar" I=bla_sort.bam O=bla_rd.bam M=dupstat.txt VALIDATION_STRINGENCY=SILENT REMOVE_DUPLICATES=true CREATE_INDEX=true

  samtools view -@ $n_threads -q 20 -f 0x0002 -F 0x0004 -F 0x0008 -b bla_rd.bam > bams/$lineB.bam
  
  $bin_dir"/bedtools/genomeCoverageBed" -ibam "bams/"$lineB".bam" | grep "^genome" > temp_cov
  
  awk -vind="$lineB" ' {if($2>=5 && $2<=500) {{bla+=$5; mpond+=$2*$3; sum+=$3}}} END { print  ind, bla, mpond/sum}' temp_cov >> GBS_5dp_cov
  awk -vind="$lineB" ' {if($2>=2 && $2<=500) {{bla+=$5; mpond+=$2*$3; sum+=$3}}} END { print  ind, bla, mpond/sum}' temp_cov >> GBS_2dp_cov
  rm temp_cov
  
done <barcode_nj.txt 3<nomi_nj.txt



##### merging sam files

samtools merge -@ $n_threads -f temp.bam bams/07H01.bam bams/07H01_with_HpaII.bam
samtools sort -@ $n_threads temp.bam bams/07H01_uni

$bin_dir"/bedtools/genomeCoverageBed" -ibam "bams/07H01_uni.bam" | grep "^genome" > temp_cov
awk -vind="07H01_uni" ' {if($2>=5 && $2<=500) {{bla+=$5; mpond+=$2*$3; sum+=$3}}} END { print  ind, bla, mpond/sum}' temp_cov >> GBS_5dp_cov
awk -vind="07H01_uni" ' {if($2>=2 && $2<=500) {{bla+=$5; mpond+=$2*$3; sum+=$3}}} END { print  ind, bla, mpond/sum}' temp_cov >> GBS_2dp_cov
rm temp_cov

samtools merge -@ $n_threads -f temp.bam bams/07H18.bam bams/07H18_with_HpaII.bam
samtools sort -@ $n_threads temp.bam bams/07H18_uni

$bin_dir"/bedtools/genomeCoverageBed" -ibam "bams/07H18_uni.bam" | grep "^genome" > temp_cov
awk -vind="07H18_uni" ' {if($2>=5 && $2<=500) {{bla+=$5; mpond+=$2*$3; sum+=$3}}} END { print  ind, bla, mpond/sum}' temp_cov >> GBS_5dp_cov
awk -vind="07H18_uni" ' {if($2>=2 && $2<=500) {{bla+=$5; mpond+=$2*$3; sum+=$3}}} END { print  ind, bla, mpond/sum}' temp_cov >> GBS_2dp_cov
rm temp_cov

samtools merge -@ $n_threads -f temp.bam bams/07H20.bam bams/07H20_with_HpaII.bam
samtools sort -@ $n_threads temp.bam bams/07H20_uni

$bin_dir"/bedtools/genomeCoverageBed" -ibam "bams/07H20_uni.bam" | grep "^genome" > temp_cov
awk -vind="07H20_uni" ' {if($2>=5 && $2<=500) {{bla+=$5; mpond+=$2*$3; sum+=$3}}} END { print  ind, bla, mpond/sum}' temp_cov >> GBS_5dp_cov
awk -vind="07H20_uni" ' {if($2>=2 && $2<=500) {{bla+=$5; mpond+=$2*$3; sum+=$3}}} END { print  ind, bla, mpond/sum}' temp_cov >> GBS_2dp_cov
rm temp_cov

samtools merge -@ $n_threads -f temp.bam bams/07H23.bam bams/07H23_with_HpaII.bam
samtools sort -@ $n_threads temp.bam bams/07H23_uni

$bin_dir"/bedtools/genomeCoverageBed" -ibam "bams/07H23_uni.bam" | grep "^genome" > temp_cov
awk -vind="07H23_uni" ' {if($2>=5 && $2<=500) {{bla+=$5; mpond+=$2*$3; sum+=$3}}} END { print  ind, bla, mpond/sum}' temp_cov >> GBS_5dp_cov
awk -vind="07H23_uni" ' {if($2>=2 && $2<=500) {{bla+=$5; mpond+=$2*$3; sum+=$3}}} END { print  ind, bla, mpond/sum}' temp_cov >> GBS_2dp_cov
rm temp_cov

samtools merge -@ $n_threads -f temp.bam bams/11U07.bam bams/11U07_with_HpaII.bam
samtools sort -@ $n_threads temp.bam bams/11U07_uni

$bin_dir"/bedtools/genomeCoverageBed" -ibam "bams/11U07_uni.bam" | grep "^genome" > temp_cov
awk -vind="11U07_uni" ' {if($2>=5 && $2<=500) {{bla+=$5; mpond+=$2*$3; sum+=$3}}} END { print  ind, bla, mpond/sum}' temp_cov >> GBS_5dp_cov
awk -vind="11U07_uni" ' {if($2>=2 && $2<=500) {{bla+=$5; mpond+=$2*$3; sum+=$3}}} END { print  ind, bla, mpond/sum}' temp_cov >> GBS_2dp_cov
rm temp_cov

samtools merge -@ $n_threads -f temp.bam bams/11U10.bam bams/11U10_with_HpaII.bam
samtools sort -@ $n_threads temp.bam bams/11U10_uni

$bin_dir"/bedtools/genomeCoverageBed" -ibam "bams/11U10_uni.bam" | grep "^genome" > temp_cov
awk -vind="11U10_uni" ' {if($2>=5 && $2<=500) {{bla+=$5; mpond+=$2*$3; sum+=$3}}} END { print  ind, bla, mpond/sum}' temp_cov >> GBS_5dp_cov
awk -vind="11U10_uni" ' {if($2>=2 && $2<=500) {{bla+=$5; mpond+=$2*$3; sum+=$3}}} END { print  ind, bla, mpond/sum}' temp_cov >> GBS_2dp_cov
rm temp_cov

samtools merge -@ $n_threads -f temp.bam bams/11U13.bam bams/11U13_with_HpaII.bam bams/11U13_full_repeat.bam bams/11U13_half_repeat.bam
samtools sort -@ $n_threads temp.bam bams/11U13_uni

$bin_dir"/bedtools/genomeCoverageBed" -ibam "bams/11U13_uni.bam" | grep "^genome" > temp_cov
awk -vind="11U13_uni" ' {if($2>=5 && $2<=500) {{bla+=$5; mpond+=$2*$3; sum+=$3}}} END { print  ind, bla, mpond/sum}' temp_cov >> GBS_5dp_cov
awk -vind="11U13_uni" ' {if($2>=2 && $2<=500) {{bla+=$5; mpond+=$2*$3; sum+=$3}}} END { print  ind, bla, mpond/sum}' temp_cov >> GBS_2dp_cov
rm temp_cov

samtools merge -@ $n_threads -f temp.bam bams/11U16.bam bams/11U16_with_HpaII.bam bams/11U16_full_repeat.bam bams/11U16_half_repeat.bam
samtools sort -@ $n_threads temp.bam bams/11U16_uni

$bin_dir"/bedtools/genomeCoverageBed" -ibam "bams/11U16_uni.bam" | grep "^genome" > temp_cov
awk -vind="11U16_uni" ' {if($2>=5 && $2<=500) {{bla+=$5; mpond+=$2*$3; sum+=$3}}} END { print  ind, bla, mpond/sum}' temp_cov >> GBS_5dp_cov
awk -vind="11U16_uni" ' {if($2>=2 && $2<=500) {{bla+=$5; mpond+=$2*$3; sum+=$3}}} END { print  ind, bla, mpond/sum}' temp_cov >> GBS_2dp_cov
rm temp_cov

samtools merge -@ $n_threads -f temp.bam bams/11U19.bam bams/11U19_with_HpaII.bam
samtools sort -@ $n_threads temp.bam bams/11U19_uni

$bin_dir"/bedtools/genomeCoverageBed" -ibam "bams/11U19_uni.bam" | grep "^genome" > temp_cov
awk -vind="11U19_uni" ' {if($2>=5 && $2<=500) {{bla+=$5; mpond+=$2*$3; sum+=$3}}} END { print  ind, bla, mpond/sum}' temp_cov >> GBS_5dp_cov
awk -vind="11U19_uni" ' {if($2>=2 && $2<=500) {{bla+=$5; mpond+=$2*$3; sum+=$3}}} END { print  ind, bla, mpond/sum}' temp_cov >> GBS_2dp_cov
rm temp_cov

samtools merge -@ $n_threads -f temp.bam bams/11U20.bam bams/11U20_with_HpaII.bam
samtools sort -@ $n_threads temp.bam bams/11U20_uni

$bin_dir"/bedtools/genomeCoverageBed" -ibam "bams/11U20_uni.bam" | grep "^genome" > temp_cov
awk -vind="11U20_uni" ' {if($2>=5 && $2<=500) {{bla+=$5; mpond+=$2*$3; sum+=$3}}} END { print  ind, bla, mpond/sum}' temp_cov >> GBS_5dp_cov
awk -vind="11U20_uni" ' {if($2>=2 && $2<=500) {{bla+=$5; mpond+=$2*$3; sum+=$3}}} END { print  ind, bla, mpond/sum}' temp_cov >> GBS_2dp_cov
rm temp_cov

samtools merge -@ $n_threads -f temp.bam bams/11U23.bam bams/11U23_with_HpaII.bam
samtools sort -@ $n_threads temp.bam bams/11U23_uni

$bin_dir"/bedtools/genomeCoverageBed" -ibam "bams/11U23_uni.bam" | grep "^genome" > temp_cov
awk -vind="11U23_uni" ' {if($2>=5 && $2<=500) {{bla+=$5; mpond+=$2*$3; sum+=$3}}} END { print  ind, bla, mpond/sum}' temp_cov >> GBS_5dp_cov
awk -vind="11U23_uni" ' {if($2>=2 && $2<=500) {{bla+=$5; mpond+=$2*$3; sum+=$3}}} END { print  ind, bla, mpond/sum}' temp_cov >> GBS_2dp_cov
rm temp_cov

samtools merge -@ $n_threads -f temp.bam bams/11U25.bam bams/11U25_with_HpaII.bam bams/11U25_full_repeat.bam bams/11U25_half_repeat.bam
samtools sort -@ $n_threads temp.bam bams/11U25_uni

$bin_dir"/bedtools/genomeCoverageBed" -ibam "bams/11U25_uni.bam" | grep "^genome" > temp_cov
awk -vind="11U25_uni" ' {if($2>=5 && $2<=500) {{bla+=$5; mpond+=$2*$3; sum+=$3}}} END { print  ind, bla, mpond/sum}' temp_cov >> GBS_5dp_cov
awk -vind="11U25_uni" ' {if($2>=2 && $2<=500) {{bla+=$5; mpond+=$2*$3; sum+=$3}}} END { print  ind, bla, mpond/sum}' temp_cov >> GBS_2dp_cov
rm temp_cov

samtools merge -@ $n_threads -f temp.bam bams/11U27.bam bams/11U27_with_HpaII.bam bams/11U27_full_repeat.bam bams/11U27_half_repeat.bam
samtools sort -@ $n_threads temp.bam bams/11U27_uni

$bin_dir"/bedtools/genomeCoverageBed" -ibam "bams/11U27_uni.bam" | grep "^genome" > temp_cov
awk -vind="11U27_uni" ' {if($2>=5 && $2<=500) {{bla+=$5; mpond+=$2*$3; sum+=$3}}} END { print  ind, bla, mpond/sum}' temp_cov >> GBS_5dp_cov
awk -vind="11U27_uni" ' {if($2>=2 && $2<=500) {{bla+=$5; mpond+=$2*$3; sum+=$3}}} END { print  ind, bla, mpond/sum}' temp_cov >> GBS_2dp_cov
rm temp_cov


rm *.sam *.bam *.bai
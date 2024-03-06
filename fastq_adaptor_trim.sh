#!/bin/bash                                                                                                                                                                    
# Trim the illumina adaptors from fastq files

#SBATCH --job-name=trim_fq                                                                                                                                                                                                                                                                                                                                         
SBATCH -n 5                                                                                                                                                                                                                                                                                                                                                                      
#SBATCH --time=00-07:00:00                                                                                                                                                                           
#SBATCH --mem=256gb                                                                                                                                                                                   
#SBATCH --partition=Intel                                                                                                                                                                              

#SBATCH --error="tirm_logs/"%x-%j.err                                                                                                                                                                    
#SBATCH --output="trim_logs/"%x-%j.out                                                                                                                                                                   
                                                                                                                                                                        
#SBATCH --mail-type=ALL
#SBATCH --mail-user=maryam.labaf001@umb.ed

##SBATCH --export=NONE                                                                                                                                                                               
##. /etc/profile

echo "Started at `date`"

################ Check and load dependent softwares ################   
module load anaconda3-2020.07-gcc-10.2.0-z5oxtnq
source /share/apps/linux-centos8-cascadelake/gcc-10.2.0/anaconda3-2020.07-z5oxtnq27xljqkd6w2scuy36na4wi7ee/etc/profile.d/conda.sh
conda activate WGBS_conda_env

module load  fastqc-0.11.9-gcc-10.2.0-osi6pqc
export PATH=/data01/maryam.labaf001/tools/TrimGalore-0.6.10/:$PATH

# Print versions of software used
echo "Using versions:"
echo -e "\tfastqc: `fastqc --version`"
echo -e "\tTrimGalore: `TrimGalore --version`"
################ INPUT FILES ################   
FQ_PATH=$1 #/PATH/to/fastqfiles/
TRIM_FQ=$2 #/PATH/to/OUTPUT
PAIRED_FLAG=$3 

mkdir -p $TRIM_FQ
mkdir -p trim_logs

cd $FQ_PATH
# create sample sheet for fastq file 
for file in `ls *_R1_001.fastq.gz`; do  NAME=${file%_R1_001.fastq.gz}; echo $NAME; done | uniq > sample.txt

for sample in $(cat $"sample.txt"); do
    echo $sample
    if [ $PAIRED_FLAG = '0' ]; then
      R1=$sample"_R1_001.fastq.gz"
      echo $FQ_PATH$R1
      trim_galore --illumina $FQ_PATH$R1 -o $TRIM_FQ
    else
      R1=$sample"_R1_001.fastq.gz"
      R2=$sample"_R2_001.fastq.gz"
      echo $FQ_PATH$R1 "and" $FQ_PATH$R2
      trim_galore  --paired --illumina --quality 25 --gzip  $R1  $R2  -o $TRIM_FQ
      #trim_galore  --paired --illumina --quality 25 --gzip  $FQ_PATH$R1  $FQ_PATH$R2  -o $TRIM_FQ
  fi
done



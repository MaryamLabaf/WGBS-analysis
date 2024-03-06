#!/bin/bash
# Extract the methylation information from the Bismark alignment output

#SBATCH --job-name=bismark_methyl                                                                                                                                                                                                                                                                                                                                                                                                      
#SBATCH -n 8                                                                                                                                                                                                                                                                                                                                                                                                                     
#SBATCH --time=00-50:00:00                                                                                                                                                                                                  
#SBATCH --mem=256gb                                                                                                                                                                                                         
#SBATCH --partition=Intel                                                                                                                                                                                                    
                                                                                                                                                                                 
#SBATCH --error="bismark_logs/"%x-%j.err                                                                                                                                                                                    
#SBATCH --output="bismark_logs/"%x-%j.out                                                                                                                                                                                   
                                                                                                                                                                             
#SBATCH --mail-type=ALL                                                                                                                                                                                                                                                                                                                                                                                                
#SBATCH --mail-user=maryam.labaf001@umb.edu                                                                                                                                                                                 

##SBATCH --export=NONE                                                                                                                                                                                                      
##. /etc/profile

echo "Started at `date`"
################ Check Bismark depend softwares ################                                                                                                                                                            
module load  bowtie2-2.4.2-gcc-10.2.0-4o66eku
module load samtools-1.10-gcc-9.3.0-flukja5

export PATH=$PATH:/data01/maryam.labaf001/tools/Bismark-0.24.1

# Print out versions of software used                                                                                                                                                                                              
echo "Using versions:"
echo -e "\tsamtools: `samtools --version`"
echo -e "\tbowtie2: `bowtie2 --version`"
echo -e "\tbismark: `bismark --version`"

####################  Input and Output PATH ###########################                 
SAMPLE=$1       
BAM_FILE=$2

Genome_DIR="/data01/maryam.labaf001/Genome/bismark_genome/"

###################### Running deduplicate_bismark ########################
## The bam files output of bismark needs to be sorted and indexed, then mark for 
## duplication, then pass to M-plot

cd $BAM_FILE$SAMPLE

find *.bam | xargs basename -s .bam | xargs -I{} samtools sort -@ 10 -m 1G -n -o {}.sorted.bam  {}.bam
find *.bam | xargs basename -s .bam | xargs -I{} deduplicate_bismark --bam --paired {}.bam

## use the results in the mbias step as the parameters in the extraction process

PARAMS="--multicore 14 --buffer_size 75% --ucsc" #--bedGraph --counts --scaffolds
TRIMS="--ignore 10 --ignore_r2 10 --ignore_3prime 10 --ignore_3prime_r2 10"

bismark_methylation_extractor $PARAMS $TRIMS *deduplicated.bam
bismark2bedGraph  --remove_spaces -o $SAMPLE

find *.cov.gz | xargs basename -s .cov.gz | xargs -I{} coverage2cytosine --merge_CpG --zero_based --genome_folder ${Genome_DIR} -o {} {}.cov.gz

bismark2report
bismark2summary

echo "Finish Run"
echo "end time is `date`"

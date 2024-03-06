#!/bin/bash

#SBATCH --job-name=bismark                                                                                                                                                                                                  
### Math setting                                                                                                                                                                                                            
#SBATCH -n 8                                                                                                                                                                                                                       
#SBATCH --account=math                                                                                                                                                                                                             
#SBATCH --time=00-50:00:00                                                                                                                                                                                                         
#SBATCH --mem=256gb                                                                                                                                                                                                                
#SBATCH --partition=Intel                                                                                                                                                                                                          

### Scavenger setting                                                                                                                                                                                                              
##SBATCH -n 24                                                                                                                                                                                                                     
##SBATCH --time=00-10:00:00                                                                                                                                                                                                        
##SBATCH --mem=32gb                                                                                                                                                                                                                
###SBATCH --partition=Intel6240,Intel6248,DGXA100                                                                                                                                                                                  
##SBATCH --partition=Intel6240,Intel6248                                                                                                                                                                                           
###SBATCH --account=kourosh.zarringhalam                                                                                                                                                                                           

#SBATCH --error="bismark_logs/"%x-%j.err                                                                                                                                                                                           
#SBATCH --output="bismark_logs/"%x-%j.out                                                                                                                                                                                          

### Array job                                                                                                                                                                                                                      
##SBATCH --array=0-1000:10                                                                                                                                                                                                         

#Optional                                                                                                                                                                                                                          
# mail alert at start, end and/or failure of execution                                                                                                                                                                             
# see the sbatch man page for other options                                                                                                                                                                                        
#SBATCH --mail-type=ALL                                                                                                                                                                                                            
# send mail to this address                                                                                                                                                                                                        
#SBATCH --mail-user=maryam.labaf001@umb.edu                                                                                                                                                                                        


##SBATCH --export=NONE                                                                                                                                                                                                             
##. /etc/profile                                                                                                                                                                                                                   

echo "Started at `date`"

################ Check Bismark depend softwares ################                                                                                                                                                                   
module load  bowtie2-2.4.2-gcc-10.2.0-4o66eku
module load samtools-1.10-gcc-9.3.0-flukja5

export PATH=$PATH:/mathspace/data01/maryam.labaf001/tools/Bismark-0.24.1

# Print out versions of software used                                                                                                                                                                                              
echo "Using versions:"
echo -e "\tsamtools: `samtools --version`"
echo -e "\tbowtie2: `bowtie2 --version`"
echo -e "\tbismark: `bismark --version`"

####################  Input and Output Paths ###########################                 
# Use the same number of threads throughout                                                                                                                                                                                        
SAMPLE=$1
FASTQ_FILE=$2
OUTPUT_DIR=$3

cd $FASTQ_FILE

Genome_DIR="/mathspace/data01/maryam.labaf001/Msuite2/Genome/bismark_genome/"
#OUTPUT_DIR=$PATH_DIR"/msuite_test_posCntrl/"                                                                                                                                                                                      
#mkdir msuite2_logs                                                                                                                                                                                                                
mkdir -p $OUTPUT_DIR

####################  Run alignment ###########################                 
cd $FASTQ_FILE
bismark --parallel 8 --genome_folder $Genome_DIR -output_dir $OUTPUT_DIR$SAMPLE -1 $SAMPLE"_val_1.fq.gz" -2 $SAMPLE"_val_2.fq.gz" 

echo "Finish Run"
echo "end time is `date`"

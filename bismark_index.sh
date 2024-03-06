#!/bin/bash                                                                                                                                                                    
# Bisulfite conversion and indexing to allow Bowtie alignments using grch38_core+bs_controls 
# Reference genomes containing spike-in methylation controls are downloaded via an amazon s3 bucket: s3://neb-em-seq-sra/
# GRCh38: https://neb-em-seq-sra.s3.amazonaws.com/grch38_core%2Bbs_controls.fa

#SBATCH --job-name=bismark_index                                                                                                                                                                                                                                                                                                                                         
#SBATCH -n 8                                                                                                                                                                                         
#SBATCH --account=math                                                                                                                                                                               
#SBATCH --time=00-50:00:00                                                                                                                                                                           
#SBATCH --mem=256gb                                                                                                                                                                                   
#SBATCH --partition=Intel                                                                                                                                                                            

#SBATCH --error="bismark_logs/"%x-%j.err                                                                                                                                                                    
#SBATCH --output="bismark_logs/"%x-%j.out                                                                                                                                                                   
                                                                                                                                                                        
#SBATCH --mail-type=ALL
#SBATCH --mail-user=maryam.labaf001@umb.ed

##SBATCH --export=NONE                                                                                                                                                                               
##. /etc/profile

echo "Started at `date`"

################ Check Bismark dependent softwares ################          
module load  bowtie2-2.4.2-gcc-10.2.0-4o66eku
module load samtools-1.10-gcc-9.3.0-flukja5

export PATH=$PATH:/data01/maryam.labaf001/tools/Bismark-0.24.1

# Print versions of software used
echo "Using versions:"
echo -e "\tsamtools: `samtools --version`"
echo -e "\tbowtie2: `bowtie2 --version`"
echo -e "\tbismark: `bismark --version`"

# Use the same number of threads throughout
NTHREADS=35

####################  Run Index ###########################
GENOME_DIR=$1 #PATH/to/Gemone/homo_sapiens/GRCh37/

bismark_genome_preparation --verbose $GENOME_DIR

echo "Finish Run"
echo "end time is `date`"


#!/bin/bash            

# BWA-METH conversion and indexing using grch38_core+bs_controls 
# Reference genomes containing spike-in methylation controls are downloaded via an amazon s3 bucket: s3://neb-em-seq-sra/
# GRCh38: https://neb-em-seq-sra.s3.amazonaws.com/grch38_core%2Bbs_controls.fa

#SBATCH --job-name=bwameth_index                                                                                                                                                                       
                                                                                                                                                                                 
#SBATCH -n 8                                                                                                                                                                                                                                                                                                                                                                     
#SBATCH --time=00-50:00:00                                                                                                                                                                           
#SBATCH --mem=256gb                                                                                                                                                                                   
#SBATCH --partition=Intel   

#SBATCH --error="bwameth_logs/"%x-%j.err                                                                                                                                                                    
#SBATCH --output="bwameth_logs/"%x-%j.out  

#SBATCH --mail-type=ALL
#SBATCH --mail-user=maryam.labaf001@umb.edu

##SBATCH --export=NONE                                                                                                                                                                               
##. /etc/profile
echo "Started at `date`"

################ load BWA-METH  depend softwares ################          
module load bwa-0.7.17-gcc-9.3.0-6zgicc2
module load samtools-1.10-gcc-9.3.0-flukja5
module load anaconda3-2020.07-gcc-10.2.0-z5oxtnq
BWAMETH_DIR="/data01/maryam.labaf001/tools/bwa-meth"

####################  Run Indexing ###########################
GENOME_DIR=$1 #PATH/to/Gemone/homo_sapiens/GRCh38/

INDEX_DIR=$1 #/PATH/to/INDEX_OUTPUT/

CD $INDEX_DIR
python $BWAMETH_DIR/bwameth.py index $GENOME_DIR

echo "Finish Run"
echo "end time is `date`"

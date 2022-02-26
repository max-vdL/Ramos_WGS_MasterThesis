#!/bin/bash
#
#SBATCH --job-name=pcr_dupl_d16
#SBATCH --cpus-per-task=24
#SBATCH --qos=long
#SBATCH --output=pcr_dupl_d16.out
#SBATCH --mail-type=ALL
#SBATCH --mail-user=maximilian.linde@imp.ac.at

# module load build-env/2020
# module load picard/2.18.27-java-1.8

java -jar $EBROOTPICARD/picard.jar MarkDuplicates I=Ramos_JG_d16_aligned.sorted.bam O=Ramos_JG_d16_marked.bam M=Ramos_JG_d16_metrics.txt

module load samtools/1.10-foss-2018b
samtools index Ramos_JG_d16_marked.bam
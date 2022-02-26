#!/bin/bash
#
#SBATCH --job-name=d16remDupl
#SBATCH --cpus-per-task=12
#SBATCH --output=out/d16remDupl.out
#SBATCH --mail-type=ALL
#SBATCH --qos=medium
#SBATCH --mail-user=maximilian.linde@imp.ac.at

module load samtools/1.10-foss-2018b
# samtools view -b -F 0x400 Ramos_JG_d16_marked_BQSR.bam > Ramos_JG_d16_noDup_BQSR.bam
samtools index Ramos_JG_d16_noDup_BQSR.bam
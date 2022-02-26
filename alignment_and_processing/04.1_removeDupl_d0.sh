#!/bin/bash
#
#SBATCH --job-name=d0remDupl
#SBATCH --cpus-per-task=12
#SBATCH --output=out/d0remDupl.out
#SBATCH --mail-type=ALL
#SBATCH --qos=medium
#SBATCH --mail-user=maximilian.linde@imp.ac.at

module load samtools/1.10-foss-2018b
# samtools view -b -F 0x400 Ramos_JG_d0_marked_BQSR.bam > Ramos_JG_d0_noDup_BQSR.bam
samtools index Ramos_JG_d0_noDup_BQSR.bam
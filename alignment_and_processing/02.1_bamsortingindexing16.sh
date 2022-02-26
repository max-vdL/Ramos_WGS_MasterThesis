#!/bin/bash
#
#SBATCH --job-name=d16sort
#SBATCH --cpus-per-task=8
#SBATCH --output=out/bam_sortingd16.out
#SBATCH --mail-type=ALL
#SBATCH --qos=medium
#SBATCH --mail-user=maximilian.linde@imp.ac.at

samtools sort /groups/pavri/bioinfo/max/wgs/ramos_JG/Ramos_JG_d16_aligned.bam -o Ramos_JG_d16_aligned.sorted.bam -@ 8

samtools index Ramos_JG_d16_aligned.sorted.bam -@ 8
#!/bin/bash
#
#SBATCH --job-name=d0sort
#SBATCH --cpus-per-task=8
#SBATCH --output=out/bam_sorting.out
#SBATCH --mail-type=ALL
#SBATCH --qos=medium
#SBATCH --mail-user=maximilian.linde@imp.ac.at

samtools sort /groups/pavri/bioinfo/max/wgs/ramos_JG/Ramos_JG_d0_aligned.bam -o Ramos_JG_d0_aligned.sorted.bam -@ 8

samtools index /groups/pavri/bioinfo/max/wgs/ramos_JG/Ramos_JG_d0_aligned.sorted.bam -@ 8
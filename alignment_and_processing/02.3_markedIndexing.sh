#!/bin/bash
#
#SBATCH --job-name=indexing
#SBATCH --cpus-per-task=4
#SBATCH --output=/groups/pavri/bioinfo/max/wgs/ramos_JG/out/vcfs_indexingd16.out
#SBATCH --mail-type=ALL
#SBATCH --qos=short
#SBATCH --mail-user=maximilian.linde@imp.ac.at
#SBATCH --dependency=afterok:27031253

module load samtools/1.10-foss-2018b
samtools index Ramos_JG_d16_marked.bam
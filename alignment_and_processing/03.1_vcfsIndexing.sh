#!/bin/bash
#
#SBATCH --job-name=indexing
#SBATCH --cpus-per-task=4
#SBATCH --output=vcfs_indexing.out
#SBATCH --mail-type=ALL
#SBATCH --qos=short
#SBATCH --mail-user=maximilian.linde@imp.ac.at

# module load gatk/4.0.1.2-java-1.8
gatk IndexFeatureFile -I vcfs/Mills_and_1000G_gold_standard.indels.hg38.vcf --verbosity DEBUG
#!/bin/bash
#
#SBATCH --job-name=varscan
#SBATCH --cpus-per-task=2
#SBATCH --output=out/varscan.out
#SBATCH --mail-type=ALL
#SBATCH --qos=medium
#SBATCH --mail-user=maximilian.linde@imp.ac.at

# source activate mySomaticSeq

varscan somatic --output-vcf Ramos_JG_d0.pileup Ramos_JG_d16.pileup Ramos_JG_varscan_SNVs.basename
#!/bin/bash
#
#SBATCH --job-name=d16BQSRnf
#SBATCH --cpus-per-task=4
#SBATCH --output=out/d16BQSRnf_marked.out
#SBATCH --mail-type=ALL
#SBATCH --qos=short
#SBATCH --mail-user=maximilian.linde@imp.ac.at
#SBATCH --mem=500G
#SBATCH --partition=m

nextflow run 03.4_BQSR_scatterd16.nf -profile cluster -with-conda environment_myUcsc.yml

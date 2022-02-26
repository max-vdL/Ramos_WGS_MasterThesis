#!/bin/bash
#
#SBATCH --job-name=d0BQSRnf
#SBATCH --cpus-per-task=8
#SBATCH --output=out/d0BQSRnf_marked.out
#SBATCH --mail-type=ALL
#SBATCH --qos=short
#SBATCH --mail-user=maximilian.linde@imp.ac.at
#SBATCH --mem=500G
#SBATCH --partition=m

nextflow run 03.4_BQSR_scatterd0.nf -profile cluster -with-conda environment_myUcsc.yml

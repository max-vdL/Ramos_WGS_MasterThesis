#!/bin/bash
#
#SBATCH --job-name=algn_d16
#SBATCH --cpus-per-task=24
#SBATCH --output=algn_d16.out
#SBATCH --qos=long
#SBATCH --mail-type=ALL
#SBATCH --mail-user=maximilian.linde@imp.ac.at

module load bwa/0.7.17-foss-2018b

bwa mem -t 24 -M -R '@RG\tID:Ramos_d16\tPL:illumina\tPU:Ramos_d16\tSM:Ramos_d16' /resources/references/igenomes/Homo_sapiens/UCSC/hg38/Sequence/BWAIndex/genome.fa 01.RawData/Ramos_JG_d16_1.fastq 01.RawData/Ramos_JG_d16_2.fastq > Ramos_JG_d16_aligned.sam

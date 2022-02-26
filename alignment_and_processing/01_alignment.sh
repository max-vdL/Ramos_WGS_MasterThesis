#!/bin/bash
#
#SBATCH --job-name=algn_d0
#SBATCH --cpus-per-task=24
#SBATCH --qos=long
#SBATCH --output=algn_d0.out
#SBATCH --mail-type=ALL
#SBATCH --mail-user=maximilian.linde@imp.ac.at

module load bwa/0.7.17-foss-2018b

bwa mem -t 24 -M -R '@RG\tID:Ramos_d0\tPL:illumina\tPU:Ramos_d0\tSM:Ramos_d0' /resources/references/igenomes/Homo_sapiens/UCSC/hg38/Sequence/BWAIndex/genome.fa 01.RawData/Ramos_JG_d0_1.fastq 01.RawData/Ramos_JG_d0_2.fastq > Ramos_JG_d0_aligned.sam

#!/bin/bash
#
#SBATCH --job-name=d0aBQSR
#SBATCH --cpus-per-task=12
#SBATCH --output=out/d0aBQSR_marked.out
#SBATCH --mail-type=ALL
#SBATCH --qos=medium
#SBATCH --mail-user=maximilian.linde@imp.ac.at

gatk ApplyBQSR  \
	-R "/groups/pavri/bioinfo/max/wgs/ramos_JG/resource/Homo_sapiens_assembly38.fasta" \
	-I "/groups/pavri/bioinfo/max/wgs/ramos_JG/Ramos_JG_d0_marked.bam" \
	-bqsr "/groups/pavri/bioinfo/max/wgs/ramos_JG/tables/recal_data_d0_combinded.table" \
	-O "/groups/pavri/bioinfo/max/wgs/ramos_JG/Ramos_JG_d0_marked_BQSR.bam" \
	--static-quantized-quals 10 \
	--static-quantized-quals 20 \
	--static-quantized-quals 30 
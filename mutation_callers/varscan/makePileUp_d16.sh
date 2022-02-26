#!/bin/bash
#
#SBATCH --job-name=d16PileUp
#SBATCH --cpus-per-task=2
#SBATCH --output=out/d16PileUp%a.out
#SBATCH --mail-type=ALL
#SBATCH --qos=medium
#SBATCH --array=1-25
#SBATCH --mail-user=maximilian.linde@imp.ac.at


region=`head -n $SLURM_ARRAY_TASK_ID 1.bed | tail -1 | awk 'FS="\t", OFS="" {print $1,":"$2"-"$3}'`

samtools mpileup -f /groups/pavri/bioinfo/max/wgs/ramos_JG/resource/Homo_sapiens_assembly38.fasta \
	-r $region \
	/groups/pavri/bioinfo/max/wgs/ramos_JG/Ramos_JG_d16_noDup_BQSR.bam \
	> /groups/pavri/bioinfo/max/wgs/ramos_JG/results/Varscan2/Ramos_d16_$SLURM_ARRAY_TASK_ID.pileup
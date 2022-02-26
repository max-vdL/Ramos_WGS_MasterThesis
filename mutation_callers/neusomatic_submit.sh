#!/bin/bash
#
#SBATCH --job-name=NeuSomatic
#SBATCH --cpus-per-task=6
#SBATCH --output=/groups/pavri/bioinfo/max/wgs/ramos_JG/out/Neusomatic_ensemble.out
#SBATCH --mail-type=ALL
#SBATCH --mem=80G
#SBATCH --qos=long
#SBATCH --partition=m
#SBATCH --mail-user=maximilian.linde@imp.ac.at

singularity exec /groups/pavri/bioinfo/max/wgs/ramos_JG/NeuSomatic/neusomatic_latest.sif /bin/bash -c \
"python /opt/neusomatic/neusomatic/python/preprocess.py \
	--mode call \
	--reference /groups/pavri/bioinfo/max/wgs/ramos_JG/resource/hg38_selected.fasta \
	--region_bed genome.bed \
	--tumor_bam /groups/pavri/bioinfo/max/wgs/ramos_JG/Ramos_JG_d16_aligned.sorted.bam \
	--normal_bam /groups/pavri/bioinfo/max/wgs/ramos_JG/Ramos_JG_d0_aligned_BQSR.bam \
	--work work_ensemble \
	--min_mapq 10 \
	--num_threads 6 \
	--ensemble_tsv /groups/pavri/bioinfo/max/wgs/ramos_JG/snv_caller_results/sseq_complete_withVarscan/Ensemble_combined.tsv \
	--scan_alignments_binary /opt/neusomatic/neusomatic/bin/scan_alignments"

singularity exec /groups/pavri/bioinfo/max/wgs/ramos_JG/NeuSomatic/neusomatic-master/test/neusomatic_latest.sif /bin/bash -c \
"CUDA_VISIBLE_DEVICES= python /opt/neusomatic/neusomatic/python/call.py \
	--candidates_tsv work_ensemble/dataset/*/candidates*.tsv \
	--reference /groups/pavri/bioinfo/max/wgs/ramos_JG/resource/hg38_selected.fasta \
	--out work_ensemble \
	--checkpoint /groups/pavri/bioinfo/max/wgs/ramos_JG/NeuSomatic/neusomatic-master/neusomatic/models/NeuSomatic_v0.1.4_ensemble_SEQC-WGS-Spike.pth \
	--num_threads 6 \
	--batch_size 100"

singularity exec /groups/pavri/bioinfo/max/wgs/ramos_JG/NeuSomatic/neusomatic-master/test/neusomatic_latest.sif /bin/bash -c \
"python /opt/neusomatic/neusomatic/python/postprocess.py \
	--reference /groups/pavri/bioinfo/max/wgs/ramos_JG/resource/hg38_selected.fasta \
	--tumor_bam /groups/pavri/bioinfo/max/wgs/ramos_JG/Ramos_JG_d16_aligned.sorted.bam \
	--pred_vcf work_ensemble/pred.vcf \
	--candidates_vcf work_ensemble/work_tumor/filtered_candidates.vcf \
	--output_vcf work_ensemble/NeuSomatic_ensemble.vcf \
	--num_threads 6 \
	--ensemble_tsv /groups/pavri/bioinfo/max/wgs/ramos_JG/snv_caller_results/sseq_complete_withVarscan/Ensemble_combined.tsv \
	--work work_ensemble "
#!/usr/bin/env bash
#SBATCH --cpus-per-task=6
#SBATCH --output=somaticseq_Ramos/1/logs/strelka_slurm-%j.out
#SBATCH --error=somaticseq_Ramos/1/logs/strelka_slurm-%j.err
#SBATCH --mem 49152
#SBATCH --qos=long

set -e

echo -e "Start at `date +"%Y/%m/%d %H:%M:%S"`" 1>&2

singularity exec /groups/pavri/bioinfo/max/wgs/ramos_JG/.singularity/tabix:1.7.img bash -c "cat somaticseq_Ramos/1/1.bed | bgzip > somaticseq_Ramos/1/1.bed.gz"
singularity exec /groups/pavri/bioinfo/max/wgs/ramos_JG/.singularity/tabix:1.7.img tabix somaticseq_Ramos/1/1.bed.gz

singularity exec /groups/pavri/bioinfo/max/wgs/ramos_JG/.singularity/strelka:2.9.5.img \
/opt/strelka/bin/configureStrelkaSomaticWorkflow.py \
--tumorBam=/groups/pavri/bioinfo/max/wgs/ramos_JG/Ramos_JG_d16_aligned_BQSR.sorted.bam \
--normalBam=/groups/pavri/bioinfo/max/wgs/ramos_JG/Ramos_JG_d0_aligned_BQSR.bam \
--referenceFasta=/groups/pavri/bioinfo/max/wgs/ramos_JG/resource/hg38_selected.fasta  \
--callMemMb=6144 \
--region=chr1:1-248956422 --region=chr2:1-242193529 --region=chr3:1-198295559 --region=chr4:1-190214555 --region=chr5:1-181538259 --region=chr6:1-170805979 --region=chr7:1-159345973 --region=chr8:1-145138636 --region=chr9:1-138394717 --region=chr10:1-133797422 --region=chr11:1-135086622 --region=chr12:1-133275309 --region=chr13:1-114364328 --region=chr14:1-107043718 --region=chr15:1-101991189 --region=chr16:1-90338345 --region=chr17:1-83257441 --region=chr18:1-80373285 --region=chr19:1-58617616 --region=chr20:1-64444167 --region=chr21:1-46709983 --region=chr22:1-50818468 --region=chrX:1-156040895 --region=chrY:1-57227415 --region=chrM:1-16569  \
--callRegions=somaticseq_Ramos/1/1.bed.gz \
  \
--runDir=somaticseq_Ramos/1/Strelka

singularity exec /groups/pavri/bioinfo/max/wgs/ramos_JG/.singularity/strelka:2.9.5.img \
somaticseq_Ramos/1/Strelka/runWorkflow.py -m local -j 10

echo -e "Done at `date +"%Y/%m/%d %H:%M:%S"`" 1>&2

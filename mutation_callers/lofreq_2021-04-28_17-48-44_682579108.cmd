#!/usr/bin/env bash
#SBATCH --job-name=lofreq_
#SBATCH --output=somaticseq_Ramos/1/logs/lofreq_slurm-%j.out
#SBATCH --error=somaticseq_Ramos/1/logs/lofreq_slurm-%j.err
#SBATCH --mem 29152
#SBATCH --qos=long
#SBATCH --cpus-per-task=4

set -e

echo -e "Start at `date +"%Y/%m/%d %H:%M:%S"`" 1>&2

singularity exec /groups/pavri/bioinfo/max/wgs/ramos_JG/.singularity/lofreq:2.1.3.1-1.img \
lofreq somatic \
-t /groups/pavri/bioinfo/max/wgs/ramos_JG/Ramos_JG_d16_aligned_BQSR.sorted.bam \
-n /groups/pavri/bioinfo/max/wgs/ramos_JG/Ramos_JG_d0_aligned_BQSR.bam \
--call-indels \
--threads 8 \
--germline \
-l somaticseq_Ramos/1/1.bed \
-f /groups/pavri/bioinfo/max/wgs/ramos_JG/resource/Homo_sapiens_assembly38.fasta \
-o somaticseq_Ramos/1/LoFreq. \
 \
-d /groups/pavri/bioinfo/max/wgs/ramos_JG/vcfs/dbsnp_146.hg38.vcf.gz

echo -e "Done at `date +"%Y/%m/%d %H:%M:%S"`" 1>&2

#!/usr/bin/env bash
#SBATCH --output=somaticseq_Ramos/1/logs/scalpel_slurm-%j.out
#SBATCH --error=somaticseq_Ramos/1/logs/scalpel_slurm-%j.err
#SBATCH --mem 25152
#SBATCH --qos=long
#SBATCH --array=1-25
#SBATCH --cpus-per-task=6

region=$(sed -n "${SLURM_ARRAY_TASK_ID}{p;q}" /groups/pavri/bioinfo/max/wgs/ramos_JG/results/somaticseq_Ramos/1/1_scalpel.bed)


set -e

echo -e "Start at `date +"%Y/%m/%d %H:%M:%S"`" 1>&2

singularity exec /groups/pavri/bioinfo/max/wgs/ramos_JG/.singularity/scalpel:0.5.4.img bash -c \
"/opt/scalpel/scalpel-discovery --somatic \
--ref /groups/pavri/bioinfo/max/wgs/ramos_JG/resource/Homo_sapiens_assembly38.fasta \
--bed ${region} \
--normal /groups/pavri/bioinfo/max/wgs/ramos_JG/Ramos_JG_d0_aligned_BQSR.bam \
--tumor /groups/pavri/bioinfo/max/wgs/ramos_JG/Ramos_JG_d16_aligned_BQSR.sorted.bam \
--window 600 \
--numprocs 6 \
 \
 \
--dir somaticseq_Ramos/1/scalpel && \
/opt/scalpel/scalpel-export --somatic \
--db somaticseq_Ramos/1/scalpel/main/somatic.db.dir \
--ref /groups/pavri/bioinfo/max/wgs/ramos_JG/resource/Homo_sapiens_assembly38.fasta \
--bed ${region} \
 \
> somaticseq_Ramos/1/scalpel/scalpel${region}.vcf"

singularity exec /groups/pavri/bioinfo/max/wgs/ramos_JG/.singularity/scalpel:0.5.4.img bash -c \
"cat somaticseq_Ramos/1/scalpel/scalpel${region}.vcf | /opt/vcfsorter.pl /groups/pavri/bioinfo/max/wgs/ramos_JG/resource/Homo_sapiens_assembly38.dict - \
> somaticseq_Ramos/1/Scalpel_${region}.vcf"

echo -e "Done at `date +"%Y/%m/%d %H:%M:%S"`" 1>&2

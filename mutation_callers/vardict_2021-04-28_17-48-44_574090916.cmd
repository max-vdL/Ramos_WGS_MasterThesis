#!/usr/bin/env bash
#SBATCH --job-name=VarDict_split
#SBATCH --output=somaticseq_Ramos/1/logs/vardict_slurm-%j.out
#SBATCH --error=somaticseq_Ramos/1/logs/vardict_slurm-%j.err
#SBATCH --mem 69152
#SBATCH --qos=long
#SBATCH --cpus-per-task=4

set -e

echo -e "Start at `date +"%Y/%m/%d %H:%M:%S"`" 1>&2

JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64

singularity exec /groups/pavri/bioinfo/max/wgs/ramos_JG/.singularity/vardictjava:1.5.2.img bash -c \
"/opt/VarDict-1.5.2/bin/VarDict \
 \
-G /groups/pavri/bioinfo/max/wgs/ramos_JG/resource/Homo_sapiens_assembly38.fasta \
-f 0.05 -h \
-b '/groups/pavri/bioinfo/max/wgs/ramos_JG/Ramos_JG_d16_aligned_BQSR.sorted.bam|/groups/pavri/bioinfo/max/wgs/ramos_JG/Ramos_JG_d0_aligned_BQSR.bam' \
-Q 1 -c 1 -S 2 -E 3 -g 4 -th 6 somaticseq_Ramos/1/1.bed \
> somaticseq_Ramos/1/2021-04-28_17-48-44_574090916.var"

echo -e "Vardict complete, combining..."

singularity exec /groups/pavri/bioinfo/max/wgs/ramos_JG/.singularity/vardictjava:1.5.2.img \
bash -c "cat somaticseq_Ramos/1/2021-04-28_17-48-44_574090916.var | awk 'NR!=1' | /opt/VarDict/testsomatic.R | /opt/VarDict/var2vcf_paired.pl -N 'TUMOR|NORMAL' -f 0.05 \
> somaticseq_Ramos/1/VarDict.vcf"

echo -e "Done at `date +"%Y/%m/%d %H:%M:%S"`" 1>&2

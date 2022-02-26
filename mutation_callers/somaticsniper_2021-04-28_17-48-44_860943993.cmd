#!/usr/bin/env bash
#SBATCH --output=somaticseq_Ramos/logs/somaticsniper_slurm-%j.out
#SBATCH --error=somaticseq_Ramos/logs/somaticsniper_slurm-%j.err
#SBATCH --mem 6144
#SBATCH --qos=long

set -e

echo -e "Start at `date +"%Y/%m/%d %H:%M:%S"`" 1>&2

singularity exec /groups/pavri/bioinfo/max/wgs/ramos_JG/.singularity/somaticsniper:1.0.5.0-2.img \
/opt/somatic-sniper/build/bin/bam-somaticsniper \
-q 1 -Q 15 -s 0.00001 -F vcf  \
-f /groups/pavri/bioinfo/max/wgs/ramos_JG/resource/Homo_sapiens_assembly38.fasta \
/groups/pavri/bioinfo/max/wgs/ramos_JG/Ramos_JG_d16_aligned_BQSR.sorted.bam \
/groups/pavri/bioinfo/max/wgs/ramos_JG/Ramos_JG_d0_aligned_BQSR.bam \
somaticseq_Ramos/SomaticSniper.vcf

i=1
while [[ $i -le 1 ]]
do
singularity exec /groups/pavri/bioinfo/max/wgs/ramos_JG/.singularity/bedtools:2.26.0.img bash -c "bedtools intersect -a somaticseq_Ramos/SomaticSniper.vcf -b somaticseq_Ramos/${i}/${i}.bed -header | uniq > somaticseq_Ramos/${i}/SomaticSniper.vcf"
    i=$(( $i + 1 ))
done

echo -e "Done at `date +"%Y/%m/%d %H:%M:%S"`" 1>&2

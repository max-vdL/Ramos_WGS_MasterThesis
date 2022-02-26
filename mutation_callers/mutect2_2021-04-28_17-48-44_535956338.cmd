#!/usr/bin/env bash
#SBATCH --output=somaticseq_Ramos/1/logs/mutect2_slurm-%j.out
#SBATCH --error=somaticseq_Ramos/1/logs/mutect2_slurm-%j.err
#SBATCH --mem 49152
#SBATCH -c 24
#SBATCH --qos=long

set -e

echo -e "Start at `date +"%Y/%m/%d %H:%M:%S"`" 1>&2

tumor_name=`singularity exec /groups/pavri/bioinfo/max/wgs/ramos_JG/.singularity/samtools:1.7.img samtools view -H /groups/pavri/bioinfo/max/wgs/ramos_JG/Ramos_JG_d16_aligned_BQSR.sorted.bam | egrep -w '^@RG' | grep -Po 'SM:[^	$]+' | sed 's/SM://' | uniq | sed -e 's/[[:space:]]*$//'`
normal_name=`singularity exec /groups/pavri/bioinfo/max/wgs/ramos_JG/.singularity/samtools:1.7.img samtools view -H /groups/pavri/bioinfo/max/wgs/ramos_JG/Ramos_JG_d0_aligned_BQSR.bam | egrep -w '^@RG' | grep -Po 'SM:[^	$]+' | sed 's/SM://' | uniq | sed -e 's/[[:space:]]*$//'`


singularity exec /groups/pavri/bioinfo/max/wgs/ramos_JG/.singularity/gatk:4.0.5.2.img \
java -Xmx7g -jar /gatk/gatk.jar Mutect2 \
--reference /groups/pavri/bioinfo/max/wgs/ramos_JG/resource/Homo_sapiens_assembly38.fasta \
--intervals somaticseq_Ramos/1/1.bed \
--input /groups/pavri/bioinfo/max/wgs/ramos_JG/Ramos_JG_d0_aligned_BQSR.bam \
--input /groups/pavri/bioinfo/max/wgs/ramos_JG/Ramos_JG_d16_aligned_BQSR.sorted.bam \
--normal-sample ${normal_name} \
--tumor-sample ${tumor_name} \
--native-pair-hmm-threads 4 \
 \
--output somaticseq_Ramos/1/unfiltered.MuTect2.vcf

singularity exec /groups/pavri/bioinfo/max/wgs/ramos_JG/.singularity/gatk:4.0.5.2.img \
java -Xmx7g -jar /gatk/gatk.jar FilterMutectCalls \
--variant somaticseq_Ramos/1/unfiltered.MuTect2.vcf \
 \
--output somaticseq_Ramos/1/MuTect2.vcf

echo -e "Done at `date +"%Y/%m/%d %H:%M:%S"`" 1>&2

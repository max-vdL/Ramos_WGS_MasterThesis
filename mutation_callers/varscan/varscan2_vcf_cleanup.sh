sed -i '18s/[[:space:]]\+/\t/g' Ramos_JG_varscan_SNVs_backup.basename.snp.vcf 
sed -i '18s/[[:space:]]\+/\t/g' Ramos_JG_varscan_SNVs_backup.basename.indel.vcf

# cat Ramos_JG_varscan_SNVs_backup.basename.snp.vcf | awk '$1 ~ /^#/ {print $0;next} {print $0 | "sort -k1,1 -k2,2n"}' > Ramos_JG_varscan_SNVs_backup.basename.snp.sorted.vcf 
# cat Ramos_JG_varscan_SNVs_backup.basename.indel.vcf | awk '$1 ~ /^#/ {print $0;next} {print $0 | "sort -k1,1 -k2,2n"}' > Ramos_JG_varscan_SNVs_backup.basename.indel.sorted.vcf 

grep "^#" Ramos_JG_varscan_SNVs_backup.basename.snp.sorted.vcf > Ramos_JG_varscan_SNVs_backup.basename.snp.sorted2.vcf
grep -v "^#" Ramos_JG_varscan_SNVs_backup.basename.snp.sorted.vcf | sort -k1,1V -k2,2g >> Ramos_JG_varscan_SNVs_backup.basename.snp.sorted2.vcf

grep "^#" Ramos_JG_varscan_SNVs_backup.basename.indel.sorted.vcf > Ramos_JG_varscan_SNVs_backup.basename.indel.sorted2.vcf
grep -v "^#" Ramos_JG_varscan_SNVs_backup.basename.indel.sorted.vcf | sort -k1,1V -k2,2g >> Ramos_JG_varscan_SNVs_backup.basename.indel.sorted2.vcf
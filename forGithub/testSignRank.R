library(MutationalPatterns)
library(BSgenome)
ref_genome = "BSgenome.Hsapiens.UCSC.hg38"
library("BSgenome.Hsapiens.UCSC.hg38", character.only=TRUE)

# vcfs = c("/groups/pavri/bioinfo/max/wgs/ramos_JG/snv_caller_results/snv_vcfs/LoFreq.somatic_final.snvs.vcf", 
# 	"/groups/pavri/bioinfo/max/wgs/ramos_JG/snv_caller_results/snv_vcfs/MuTect2.vcf", 
# 	"/groups/pavri/bioinfo/max/wgs/ramos_JG/snv_caller_results/snv_vcfs/scalpel_combined.vcf", 
# 	"/groups/pavri/bioinfo/max/wgs/ramos_JG/snv_caller_results/snv_vcfs/NeuSomatic_standalone.vcf", 
	# "/groups/pavri/bioinfo/max/wgs/ramos_JG/snv_caller_results/snv_vcfs/Ramos_JG_varscan_SNVs_backup.basename.snp.vcf",
	# "/groups/pavri/bioinfo/max/wgs/ramos_JG/snv_caller_results/snv_vcfs/SomaticSniper.vcf",
	# "/groups/pavri/bioinfo/max/wgs/ramos_JG/snv_caller_results/snv_vcfs/strelka_somatic.snvs.vcf",
	# "/groups/pavri/bioinfo/max/wgs/ramos_JG/snv_caller_results/snv_vcfs/VarDict_split.vcf",
	# "/groups/pavri/bioinfo/max/wgs/ramos_JG/snv_caller_results/sseq_complete_noVarscan/SSeq.Classified.sSNV.vcf")

# names = c("LoFreq", "MuTect2", "Scalpel", "NeuSomatic_standalone", "SomaticSniper", "Strelka", "Vardict", "SSeq")
#  "Varscan2",

# vcfs = c("/groups/pavri/bioinfo/max/wgs/ramos_JG/snv_caller_results/snv_vcfs/LoFreq.somatic_final.snvs.vcf", 
# 	"/groups/pavri/bioinfo/max/wgs/ramos_JG/snv_caller_results/snv_vcfs/MuTect2.vcf",
# 	"/groups/pavri/bioinfo/max/wgs/ramos_JG/snv_caller_results/snv_vcfs/scalpel_combined.vcf")
# names = c("LoFreq", "MuTect2", "Scalpel")

vcfs = c("/groups/pavri/bioinfo/max/wgs/ramos_JG/snv_caller_results/sseq_complete_noVarscan/SSeq.Classified.sSNV.vcf",
	"/groups/pavri/bioinfo/max/wgs/ramos_JG/snv_caller_results/snv_vcfs/Ramos_JG_varscanSomatic_SNVs_backup.basename.snp.sorted.vcf")
names = c("SomaticSeq", "Varscan")

grl = read_vcfs_as_granges(vcfs, names, ref_genome)

mut_mat <- mut_matrix(vcf_list = grl, ref_genome = ref_genome)

mut_mat <- mut_mat + 0.0001
library("NMF")
estimate <- nmf(mut_mat, rank = 1:6, method = "brunet", nrun = 10, seed = 123456, .opt = "vP")

pdf("plots/SomaticSeq_SignRankEstimate.pdf")
plot(estimate)
dev.off()
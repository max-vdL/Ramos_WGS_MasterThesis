library(MutationalPatterns)
library(BSgenome)
ref_genome = "BSgenome.Hsapiens.UCSC.hg38"
library("BSgenome.Hsapiens.UCSC.hg38", character.only=TRUE)
library(optparse)
library(ggplot2)

option_list = list(
make_option(c("-f", "--file"), type="character", default=NULL, 
			help="path of vcf file(s)", metavar="character"),
make_option(c("-n", "--name"), type="character", default=NULL,
			help="name for each project"),
make_option("--bed", type="character", default=NULL,
			help="path of bed file")
)
opt_parser = OptionParser(option_list=option_list)
opt = parse_args(opt_parser)

# if multiple names/files in weird format: parse the list
if (substr(opt$file, 1, 1) == "[") {
	opt$file <- unlist(strsplit(substr(opt$file, 2, nchar(opt$file)-1), ','))
	opt$name <- unlist(strsplit(substr(opt$name, 2, nchar(opt$name)-1), ','))
}

grl = read_vcfs_as_granges(opt$file, opt$name, ref_genome)
bed = read.csv(opt$bed, sep = "\t", header = FALSE)
seql = bed$V3
seqlengths(grl) <- seql[1:length(seqlengths(grl))]
mut_mat <- mut_matrix(vcf_list = grl, ref_genome = ref_genome)


#### SIGNATURES
# nmf_res <- extract_signatures(mut_mat, rank = 3, nrun = 100, single_core = FALSE)

# pdf(paste("plots/signatures96_", opt$name, ".pdf", sep=""))
# plot_96_profile(nmf_res$signatures)
# dev.off()

#### SUPERVISED SIGNATURES
signatures = get_known_signatures()
fit_res <- fit_to_signatures(mut_mat, signatures)

pdf(paste("plots/supervised-signatures_", opt$name, ".pdf", sep=""))
plot_contribution(fit_res$contribution,
coord_flip = FALSE,
mode = "absolute")
dev.off()
	
#### SPECTRUM
pdf(paste("plots/spectrum96_", opt$name, ".pdf", sep=""))
plot_96_profile(mut_mat, condensed = TRUE)
dev.off()
pdf(paste("plots/spectrum192_", opt$name, ".pdf", sep=""))
plot_192_profile(mut_mat, condensed = TRUE)
dev.off()

#### RAINFALL
chromosomes <- seqnames(get(ref_genome))[1:22]
grl_single <- subset(grl[[1]], REF %in% c("A", "C", "G", "T") & ALT %in% c("A", "C", "G", "T"))

rainpl <- plot_rainfall(grl_single,  title = names(grl[1]), chromosomes = chromosomes, cex = 0.5 , ylim = 10^5)
rainpl$layers[[1]]$aes_params$alpha <- 0.5

ggsave(paste("plots/rainfall_", opt$name, ".pdf", sep=""), rainpl, width=11, height=8.5)
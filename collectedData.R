library(MutationalPatterns)
library(BSgenome)
ref_genome = "BSgenome.Hsapiens.UCSC.hg38"
library("BSgenome.Hsapiens.UCSC.hg38", character.only=TRUE)
library(optparse)
library(ggplot2)

option_list = list(
make_option(c("-f", "--file"), type="character", default=NULL, 
			help="path of file with names and vcf files", metavar="character"),
make_option(c("-n", "--name"), type="character", default=NULL,
			help="name for the project"),
make_option("--bed", type="character", default=NULL,
			help="path of bed file"),
make_option(c("-o", "--outdir"), type="character", default="plots",
			help="path out directory"),
make_option(c("-p", "--pos"), default=NULL,
			help="specific positions for subset of the input, only one input allowed if pos also given")
)
opt_parser = OptionParser(option_list=option_list)
opt = parse_args(opt_parser)

samples = read.csv(opt$file, header=FALSE, sep = "\t", comment.char="#")
names(samples) = c('files', 'names')

grl = read_vcfs_as_granges(samples$files, samples$names, ref_genome)
print(paste0("read done at ", Sys.time()))
bed = read.csv(opt$bed, sep = "\t", header = FALSE)
seql = bed$V3
seqlengths(grl) <- seql[1:length(seqlengths(grl))]

# read pos files if there are any. ONLY ONE ALLOWED ATM
if (!is.null(opt$pos)) {
	positions <- read.table(opt$pos, header = TRUE, sep = '\t')
	posGrl = GRanges(seqnames = positions$CHR, ranges = IRanges(start = positions$POS, end = positions$POS))
	overlap = as.list(findOverlaps(grl, posGrl))
	grl = grl[overlap]
	print(paste0("subset done at ", Sys.time()))
}

library("TxDb.Hsapiens.UCSC.hg38.knownGene")
genes_hg38 <- genes(TxDb.Hsapiens.UCSC.hg38.knownGene)
mut_mat <- mut_matrix(vcf_list = grl, ref_genome = ref_genome)
print(paste0("mut_mat done at ", Sys.time()))

#### SIGNATURES
# nmf_res <- extract_signatures(mut_mat, rank = 3, nrun = 100, single_core = FALSE)

# pdf(paste(opt$outdir, "/signatures96_", opt$name, ".pdf", sep=""))
# plot_96_profile(nmf_res$signatures)
# dev.off()

#### SUPERVISED SIGNATURES
signatures = get_known_signatures()
fit_res <- fit_to_signatures(mut_mat, signatures)

pdf(paste(opt$outdir, "/supervised-signatures_", opt$name, ".pdf", sep=""))
plot_contribution(fit_res$contribution,
	coord_flip = FALSE,
	mode = "absolute")
dev.off()
	
#### SPECTRUM
pdf(paste(opt$outdir, "/spectrum96_", opt$name, ".pdf", sep=""))
plot_96_profile(mut_mat, ymax = 0.1)
dev.off()

#### RAINFALL
# chromosomes <- seqnames(get(ref_genome))[1:22]
# grl_single <- subset(grl[[1]], REF %in% c("A", "C", "G", "T") & ALT %in% c("A", "C", "G", "T"))

# rainpl <- plot_rainfall(grl_single,  title = names(grl[1]), chromosomes = chromosomes, cex = 0.5 , ylim = 10^5)
# rainpl$layers[[1]]$aes_params$alpha <- 0.5

# ggsave(paste(opt$outdir, "/rainfall_", opt$name, ".pdf", sep=""), rainpl, width=11, height=8.5)

#### SPECTRUM WITH TRANSCRIPTION STRANDNESS
mut_mat <- mut_matrix_stranded(grl, ref_genome, genes_hg38)
print(paste0("mut_mat_s done at ", Sys.time()))
pdf(paste(opt$outdir, "/spectrum192_", opt$name, ".pdf", sep=""))
plot_192_profile(mut_mat, ymax = 0.1)
dev.off()

print(paste0("plotting done at ", Sys.time()))

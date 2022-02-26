library(MutationalPatterns)
library(BSgenome)
ref_genome = "BSgenome.Hsapiens.UCSC.hg38"
library("BSgenome.Hsapiens.UCSC.hg38", character.only=TRUE)
library(optparse)

option_list = list(
make_option(c("-f", "--file"), type="character", default=NULL, 
			help="path of vcf file(s)", metavar="character"),
make_option(c("-n", "--name"), type="character", default=NULL,
			help="name for each project"),
make_option("--bed", type="character", default=NULL,
			help="path of bed file"),
make_option(c("-o", "--out"), type="character", default=NULL,
			help="path of out plot file"),
make_option(c("-c", "--ctrl"), action="store_false", default=TRUE,
			help="control dataset generation, default TRUE, can be called to set FALSE"),
make_option(c("-p", "--pos"), default=NULL,
			help="specific positions for subset of the input, only one input allowed if pos also given")
)
opt_parser = OptionParser(option_list=option_list)
opt = parse_args(opt_parser)

grl = read_vcfs_as_granges(opt$file, opt$name, ref_genome)
bed = read.csv(opt$bed, sep = "\t", header = FALSE)
seql = bed$V3
print("reading vcf done")

# read pos files if there are any. ONLY ONE ALLOWED ATM
if (!is.null(opt$pos)) {
	positions <- read.table(opt$pos, header = TRUE, sep = '\t')
	posGrl = GRanges(seqnames = positions$CHR, ranges = IRanges(start = positions$POS, end = positions$POS))
	overlap = findOverlaps(posGrl, grl[[1]])
	grl = grl[[1]][overlap@to]
}

context = mut_context(grl, ref_genome, extension = 2)

# create fastas from the lists in fastas
print("creating fasta(s)...")
outfile = paste(opt$name, '.fasta', sep='')
write(context, outfile, sep='\n')

# create random samples
if (opt$ctrl) {
	controls=c()
	for (i in 1:50000) {
		control = sample(list('A', 'G', 'C', 'T'), 5, replace = TRUE)
		control = paste(unlist(control), collapse='')
		controls = c(controls, control)
	}
	write(controls, 'control_motifs50k.fasta', sep='\n')
}

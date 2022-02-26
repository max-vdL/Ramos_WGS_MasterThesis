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

# if multiple names/files: parse the list
if (substr(opt$file, 1, 1) == "[") {
	opt$file <- unlist(strsplit(substr(opt$file, 2, nchar(opt$file)-1), ','))
	opt$name <- unlist(strsplit(substr(opt$name, 2, nchar(opt$name)-1), ','))
}

grl = read_vcfs_as_granges(opt$file, opt$name, ref_genome)
bed = read.csv(opt$bed, sep = "\t", header = FALSE)
seql = bed$V3
# seqlengths(grl) <- seql[1:24]

# read pos files if there are any. ONLY ONE ALLOWED ATM
if (!is.null(opt$pos)) {
	positions <- read.table(opt$pos, header = TRUE, sep = '\t')
	posGrl = GRanges(seqnames = positions$CHR, ranges = IRanges(start = positions$POS, end = positions$POS))
	overlap = as.list(findOverlaps(grl, posGrl))
	grl = grl[overlap]
}

print("creating mut_matrix...")
mut_mat <- mut_matrix(vcf_list = grl, ref_genome = ref_genome, extension = 2)

fastas = vector("list", length = length(grl))

# add the motif as often to its sample list as its value is described in mut_mat
print("creating motifs...")
for (rowname in rownames(mut_mat)) {
	code = gsub(">.", "", rowname)
	code = gsub("[[:punct:]]", "", code)
	for (i in range(length(fastas))) {fastas[[i]] = c(fastas[[i]], rep(code, mut_mat[rowname, i]))}
}

# create fastas from the lists in fastas
print("creating fasta(s)...")
for (i in range(length(fastas))) {
	outfile = paste(opt$name[i], '.fasta', sep='')
	write(fastas[[i]], outfile, sep='\n')
}

# create random samples
if (opt$ctrl) {
	controls=c()
	for (i in 1:5000) {
		control = sample(list('A', 'G', 'C', 'T'), 5, replace = TRUE)
		control = paste(unlist(control), collapse='')
		controls = c(controls, control)
	}
	write(controls, 'control_motifs.fasta', sep='\n')
}

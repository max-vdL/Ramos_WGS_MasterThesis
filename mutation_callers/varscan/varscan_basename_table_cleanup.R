#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

file = read.delim(args[1], header=TRUE)

file$normal_reads <- file$normal_reads1 + file$normal_reads2
file$tumor_reads <- file$tumor_reads1 + file$tumor_reads2

less = file[c('chrom', 'position', 'ref', 'var',  'normal_reads', 'tumor_reads', 'normal_var_freq', "tumor_var_freq", "somatic_p_value", "somatic_status")]
# convert <- function(x) {as.numeric(sub("%","",x))/100}
# test <- lapply(less$normal_var_freq, convert)
# less$normal_var_freq <- test
# less$tumor_var_freq <- lapply(less$tumor_var_freq, convert)

less <- less[order(less$somatic_status, decreasing = TRUE),]
somatic = less[less$somatic_status == 'Somatic',]
write.table(somatic, 'vdj_varscan_somaticOnly.tsv', row.names = FALSE)

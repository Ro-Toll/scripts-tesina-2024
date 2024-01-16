#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly = TRUE)
if (length(args)==0) {
	stop("Please supply input filenames.", call.=FALSE)
}

tepid_filename <- args[1]
output_filename <- args[2]
thresh <- as.double(args[3])
operator <- args[4]

tepid_bed <- read.table(tepid_filename, header = FALSE)
operate <- match.fun(operator)
selected <- subset(tepid_bed, operate(rev(tepid_bed)[1], thresh))
write.table(selected, file = output_filename, sep = '\t',
	quote = FALSE, col.names = FALSE, row.names = FALSE)
print(paste0("Generated file: ", output_filename,
	" with MAF ", operator, thresh))


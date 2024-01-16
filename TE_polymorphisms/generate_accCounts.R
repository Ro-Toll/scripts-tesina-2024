#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly = TRUE)
if (length(args)==0) {
	stop("Please supply input filenames.", call.=FALSE)
}

tepid_filename <- args[1] 
output_filename <- args[2] 
accNB <- strtoi(args[3])

# print(tepid_filename)
# print(output_filename)
tepid_bed <- read.table(tepid_filename, header = FALSE)
tepid_bed[, ncol(tepid_bed)] <- tepid_bed[, ncol(tepid_bed)] / accNB
write.table(tepid_bed, file = output_filename, sep = '\t',
	quote = FALSE, col.names = FALSE, row.names = FALSE)

print(paste0("Generated file: ", output_filename))

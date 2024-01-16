#!/usr/bin/env Rscript

if (!require("dplyr")) install.packages("dplyr")
library(dplyr)

args <- commandArgs(trailingOnly = TRUE)
if (length(args)==0) {
    stop("Please supply input filenames.", call.=FALSE)
}

bed_filename <- args[1]
genome_filename <- args[2]
output_name <- args[3]

#### FUNCTIONs ----

read_bedfile <- function(bed_filename) {
    bed <- read.delim(bed_filename, header = FALSE)
    colnames(bed) <- c("chr", "start", "end", "strand",
                    "name", "family", "superfamily")
    bed$superfamily <- as.factor(bed$superfamily)
    bed
}

## --- Coverage
get_genome_size <- function(genome) {
    chrom_sizes <- read.delim(genome, header = FALSE)
    sum(chrom_sizes$V2)
}

generate_coverage_tables <- function(bedfile, genome_size, output_name) {
    bases_covered <- bedfile %>%
                    group_by(family) %>%
                    summarise(cov = sum(end - start))
    bases_covered$percentage <- (bases_covered$cov) * 100  / genome_size
    bases_covered$class <- "ClassII"
    bases_covered$class[grepl("LTR", bases_covered$family)] <- "ClassI"
    bases_covered$class <- as.factor(bases_covered$class)
    bases_covered_total <- bases_covered %>%
                group_by(class) %>%
                summarise(total = sum(cov))
    bases_covered_total$percentage <-
            (bases_covered_total$total) * 100  / genome_size
    # Write Coverage Tables
    write.table(subset(bases_covered, class == "ClassI", -class),
        output_name, quote = FALSE, sep = "\t",
        row.names = FALSE, col.names = FALSE)
    write.table(subset(bases_covered_total, class == "ClassI"),
        output_name, quote = FALSE, sep = "\t",
        row.names = FALSE, col.names = FALSE, append = TRUE)
    write.table(subset(bases_covered, class == "ClassII", -class),
        output_name, quote = FALSE, sep = "\t",
        row.names = FALSE, col.names = FALSE, append = TRUE)
    write.table(subset(bases_covered_total, class == "ClassII"),
            output_name, quote = FALSE, sep = "\t",
            row.names = FALSE, col.names = FALSE, append = TRUE)
}

genome_size <- get_genome_size(genome_filename)
bed <- read_bedfile(bed_filename)
generate_coverage_tables(bed, genome_size, output_name)
print(paste0("Generated output file: ", output_name))

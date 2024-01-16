#!/usr/bin/env Rscript

#.libPaths("C:/Program Files/R/R-4.3.0/library")

if (!require("dplyr")) install.packages("dplyr")
library(dplyr)

args <- commandArgs(trailingOnly = TRUE)
if (length(args)==0) {
    stop("Please supply input filenames.", call.=FALSE)
}

bed_filename <- args[1]
output_name <- args[2]

#### FUNCTIONs ----

read_bedfile <- function(bed_filename) {
    bed <- read.delim(bed_filename, header = FALSE)
    colnames(bed) <- c("chr", "start", "end", "strand",
                    "name", "family", "superfamily")
    bed$superfamily <- as.factor(bed$superfamily)
    bed
}

## --- TE counts
generate_te_count_table <- function(bed, output_name) {
    uniq_counts <- bed %>%
                    group_by(family) %>%
                    summarise(count = length(unique(name)))
    copy_counts <- bed %>%
                    group_by(family) %>%
                    summarise(count = length(name))
    name_counts <- uniq_counts
    name_counts$copies <- copy_counts$count
    # Totals by Class
    name_counts$class <- "ClassII"
    name_counts$class[grepl("LTR", name_counts$family)] <- "ClassI"
    name_counts$class <- as.factor(name_counts$class)
    name_counts_class <- name_counts %>%
                group_by(class) %>%
                summarise(total_uniq = sum(count), total_copies = sum(copies))
    # Write Tables
    write.table(subset(name_counts, class == "ClassI", -class),
        output_name, quote = FALSE, sep = "\t",
        row.names = FALSE, col.names = FALSE)
    write.table(subset(name_counts_class, class == "ClassI"),
        output_name, quote = FALSE, sep = "\t",
        row.names = FALSE, col.names = FALSE, append = TRUE)
    write.table(subset(name_counts, class == "ClassII", -class),
        output_name, quote = FALSE, sep = "\t",
        row.names = FALSE, col.names = FALSE, append = TRUE)
    write.table(subset(name_counts_class, class == "ClassII"),
            output_name, quote = FALSE, sep = "\t",
            row.names = FALSE, col.names = FALSE, append = TRUE)
}


bed <- read_bedfile(bed_filename)
generate_te_count_table(bed, output_name)
print(paste0("Generated output file: ", output_name))


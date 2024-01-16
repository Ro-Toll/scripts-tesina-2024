#!/bin/bash

gff=$1  # GFF file with a 'Classification' field
output=$2 # output file

sed -n 's/.*Classification=\([^;|$]\+\).*/\1/p' $gff | sort | uniq -c | sed 's/^[\s ]*//g' > $output

#!/bin/bash

tepid_bed=$1 # TEPID's output (insertions or deletions)
output=$2 # file to write script's output
acc_col=$3 # Column in TEPID's output with accession info
# 8 for insertions, 6 for deletions

paste $tepid_bed <(awk -v c=$acc_col '{print $c}' $tepid_bed | awk -F',' '{print NF}') > $output

echo " ~~> Generated: $output"
echo ''

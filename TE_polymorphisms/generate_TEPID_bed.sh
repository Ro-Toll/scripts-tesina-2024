#!/bin/bash

# Format: chr   start   end   strand   ID   family   superfamily

gff=$1			# reclassified GFF3
tepid_bed=$2	# BED output in TEPID's required format

awk '{print $1"\t"$4-1"\t"$5"\t"$7"\t##"$9"##\t&&"$9"&&"}' $gff | \
 sed -e 's/##.\+Name=\([^;]\+\).\+##/\1\t\1/g' \
     -e 's/&&.\+Classification=\([^;]\+\).\+&&/\1/g' | \
 awk '{count[$5]++; print $1"\t"$2"\t"$3"\t"$4"\t"$5"_"count[$5]"\t"$6"\t"$7}' >$tepid_bed

echo "~> Generated TEPID BED: $tepid_bed"
echo ''


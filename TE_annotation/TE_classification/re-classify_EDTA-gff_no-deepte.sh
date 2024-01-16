#!/bin/bash

original=$1		# EDTA's GFF3 to reclassify
new=$2			# To generate: reclassified GFF3	

# -- Reclassify EDTA's GFF - without using DeepTE
grep -v '^#' $original | \
	sed -e 's/LTR\//LTR_/g' \
	 -e 's/LTR_unknown/LTR/g' \
	 -e 's/DNA\/Helitron/DNA_Helitron/g' \
	 -e 's/DNA\//DNA_nMITE_/g' \
	 -e 's/MITE\//DNA_MITE_/g' \
	 -e 's/DTC/CACTA/g' \
	 -e 's/DTM/Mutator/g' \
	 -e 's/DTH/Harbinger/g' \
	 -e 's/DTT/TcMar/g' \
	 -e 's/DTA;/hAT;/g' \
	 -e 's/\(^[^\t]\+\)\t*\([^\t]\+\)\t*\([^\t]\+\)\t*\(.*\)Classification=\([^;]*\);\(.*$\)/\1\t\2\t\5\t\4Classification=\5;\6/g' \
	 > $new

echo "Generated reclassified GFF: $new"
echo ''

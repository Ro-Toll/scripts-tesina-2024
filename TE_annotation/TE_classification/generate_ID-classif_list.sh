#!/bin/bash

deepte_txt=$1 # DeepTE's txt output
classif_list=$2 # output in ID#Class format
workdir="$(dirname "${classif_list}")"
tmplist="$workdir/tmp"

# Generate ID list from DeepTE txt output
sed -n 's/\(^[^#]\+\).*/\1/p' ${deepte_txt} | sed 's/_[A-Z]\+//g' | sort | uniq > $tmplist

> $classif_list
while read id; do
	class=$(grep $id $deepte_txt | awk '{print $2}' | sort | uniq -c | sort -r | head -n1 | awk '{print $2}')
	if [ $class == "unknown" ]; then class=$(grep -m1 $id $deepte_txt | sed -n 's/.*#\([^(\|\t\|$]\+\).*/\1/p'); fi
	#if [ $class == "unknown" ]; then class=$(grep -m1 $id $deepte_txt | sed -n 's/.*#\([^:\{2\}]\+\).*/\1/p'); fi
	echo "$id#$class" >> $classif_list
done < $tmplist
rm $tmplist

# Rewrite EDTA's class
sed -i -e 's/\([^#]\+\)#LTR\//\1#LTR_/g' \
 -e 's/\([^#]\+\)#LTR_unknown/\1#LTR/g' \
 -e 's/\([^#]\+\)#DNA\/Helitron/\1#DNA_Helitron/g' \
 -e 's/\([^#]\+\)#DNA\//\1#DNA_nMITE_/g' \
 -e 's/\([^#]\+\)#MITE\//\1#DNA_MITE_/g' \
 -e 's/_DTC/_CACTA/g' \
 -e 's/_DTM/_Mutator/g' \
 -e 's/_DTH/_Harbinger/g' \
 -e 's/_DTT/_TcMar/g' \
 -e 's/_DTA/_hAT/g' \
 $classif_list

# Replace EDTA's class with DeepTE's
sed -i -e 's/#Class[I]\+_/#/g' \
 -e 's/#DNA_\(.*\)_nMITE/#DNA_nMITE_\1/g' \
 -e 's/#DNA_\(.*\)_MITE/#DNA_MITE_\1/g' \
 -e 's/#DNA_\(.*\)_unknown/#DNA_unknown_\1/g' \
 -e 's/#MITE/#DNA_MITE/g' \
 -e 's/#nMITE/#DNA_nMITE/g' \
 -e 's/#Helitron/#DNA_Helitron/g' \
 -e 's/#ClassII/#DNA/g' \
 -e 's/#ClassI/#LTR/g' \
 -e 's/#MITE$/#DNA_MITE/g' \
 -e 's/#nMITE$/#DNA_nMITE/g' $classif_list

echo "~> Generated ID#Class list: ${classif_list}"
echo ''
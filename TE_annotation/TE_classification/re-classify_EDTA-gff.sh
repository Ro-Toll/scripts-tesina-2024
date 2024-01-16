#!/bin/bash

original=$1		# EDTA's GFF3 to reclassify
classif_list=$2	# ID#Class list
new=$3			# To generate: reclassified GFF3	
workdir="$(dirname "${new}")"
tmp="$workdir/tmp"

grep -v '^#' $original > $tmp
>$new
while read l; do
	id=$(echo $l | sed -n 's/.*Name=\([^;]\+\).*/\1/p' | sed 's/_[A-Z]\+//g')
	classline=$(grep -m1 $id $classif_list)
	class=$(echo $classline | sed -n 's/.*#\(.*$\)/\1/p')
	echo $l | sed 's/ /\t/g' | sed "s/\(^[^\t]\+\)\t*\([^\t]\+\)\t*\([^\t]\+\)\t*\(.*\)Classification=[^;]\+;\(.*$\)/\1\t\2\t$classline\t\4Classification=$class;\5/g" >> $new
done < $tmp
rm $tmp

echo "~> Generated reclassified GFF: $new"
echo ''

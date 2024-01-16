#!/bin/bash

tepid_res=$1 # TEPID's BED output
tepid_bed=$2 # TEPID's BED input, Format: chr   start   end   strand   ID   family   superfamily
tepid_res_sf=$3 # file to write script's output
id_col=$4 # Column with ID info in TEPID's output
# From the merged INSERTIONS file, ID is 7th column
# From the merged DELETIONS file, ID is 5th column

> $tepid_res_sf
while read line; do
	multiple=$(echo $line | awk -v c=$id_col '{print $c}' | sed 's/,/,\n/g' | grep -c ',') 
	((multiple++))
	counter=0
	while [ $counter -lt $multiple ]; do
		((counter++))
		id=$(echo $line | awk -v c=$id_col '{print $c}' | awk -F ',' -v n=$counter '{print $n}')
		l=$(echo $line | awk -v c=$id_col -v id=$id '{for(i=1;i<=NF;i++) if (i==c) printf id"\t"; else if (i==NF) print $i; else printf $i"\t"}')
		sf=$(grep -m1 "$id" $tepid_bed | awk '{print $7}') # Get the superfamily
		echo -e $l"\t"$sf >> $tepid_res_sf
	done
done < $tepid_res
sed -i 's/ /\t/g' $tepid_res_sf

echo " ~~> Generated TEPID Result with Superfamily: ${tepid_res_sf}"
echo ''



#!/bin/bash

# -- FASTA
# Format: name#edtaclass::chr:start-end(strand)__deepteclass
# -- list (txt)
# Format: name#edtaclass::chr:start-end(strand)	deepteclass

original=$1		# DeepTE's FASTA to reclassify
classif_list=$2	# ID#Class list (txt)
new=$3			# To generate: reclassified FASTA	

cat $original > $new

while read l; do
	id=$(echo $l | sed -n 's/\(^[^#]\+\).*/\1/p' | sed 's/_[A-Z]\+//g')
	class=$(echo $l | sed -n 's/.*#\(.*$\)/\1/p')
	sed -i "s/>$id\([^#]*\)#\([^(]*\)\([^_\{2\}]*\).*/>$id\1#$class\3/g" $new	
done < $classif_list

echo "~> Generated reclassified FASTA: $new"
echo ''

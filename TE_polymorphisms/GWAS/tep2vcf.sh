#!/bin/bash

files=$1		# Comma-separated list of indel files in TEPID deletion result format
indel_order=$2 		# Comma-separated list of is and ds, in the same order as the files
ref=$3          # Reference genome fasta
elembed=$4      # TE/MITE/IR bedfile in TEPID's input format
reseqids=$5		# List of all accession names
out=$6			# Output filename

## Header
echo "##fileformat=VCFv4.0
##INFO=<ID=NS,Number=1,Type=Integer,Description=\"Number of Samples With Data\">
##INFO=<ID=AF,Number=.,Type=Float,Description=\"Allele Frequency\">
##FORMAT=<ID=GT,Number=1,Type=String,Description=\"Genotype\">" > $out
echo -ne "#CHROM\tPOS\tID\tREF\tALT\tQUAL\tFILTER\tINFO\tFORMAT\t" >> $out
sed -z 's/\n/\t/g;s/\t$/\n/' $reseqids >> $out

# Define all the accessions
header_accs=$(sed -z 's/\n/ /g;s/ $/\n/' $reseqids)

# Define which are ins and which are dels
a=()
for indel in ${indel_order//,/ }; do 
    a+=("$indel")
done

c=0
> ${out}.tmp.body
for f in ${files//,/ }; do
    echo -ne " Processing $f"
    ## General info (cols 1-9)
    if [ ${a[$c]} == 'i' ]; then # SPLTRDR/TEPID insertion
        echo -en "\t(insertions)\nGeneral info..."
        > ${out}.tmp.fa
        while read line; do
            elemid=$(echo $line | awk '{print $5}' | sed 's/\(.*_.*\)_.*/\1/g')
            grep -wm1 "$elemid" $elembed | awk '{print $1"\t"$2-1"\t"$3}' | \
             bedtools getfasta -fi $ref -bed stdin | grep -v '^>' >> ${out}.tmp.fa
        done < $f
        paste $f ${out}.tmp.fa > ${out}.tmp.bedfa
        awk '{FS=OFS="\t"} {counter[$5]++; print $1,$2,$5"_i"counter[$5],"###"$NF"###",$NF,".","PASS",".","GT"}' ${out}.tmp.bedfa | \
         sed 's/###\(.\).*###/\1/g' > ${out}.tmp.1
    
    elif [ ${a[$c]} == 'd' ]; then # TEPID deletion
        echo -en "\t(deletions)\nGeneral info..."
        awk '{FS=OFS="\t"} {print $1,$2-1,$3}' $f | bedtools getfasta -fi $ref -bed stdin | grep -v '^>' > ${out}.tmp.fa
        paste $f ${out}.tmp.fa > ${out}.tmp.bedfa
        awk '{FS=OFS="\t"} {counter[$5]++; print $1,$2,$5"_d"counter[$5],$NF,"###"$NF"###",".","PASS",".","GT"}' ${out}.tmp.bedfa | \
         sed 's/###\(.\).*###/\1/g' > ${out}.tmp.1
    fi 
    echo -ne " done! Accession columns...\t"
    ## Accession Columns (cols 10-NF)
    # Print 0|1 per accession in separate(\t) columns
    awk '{FS=OFS="\t"} {print $(NF-1)}' $f | sed 's/,/\t/g' | \
    awk -v h="$header_accs" '{FS=OFS="\t"} { for(i=1;i<=NF;i++) {indel[$i]++}; 
     split(h, accs, " ");
     for (i=1; i<=length(accs); i++) {$i=indel[accs[i]]+0; indel[accs[i]]=0;} print }' | \
     sed -e 's/0/0\/0/g' -e 's/1/1\/1/g' > ${out}.tmp.2

    echo -ne " done!\n"
    ## 'body'
    paste ${out}.tmp.1 ${out}.tmp.2 >> ${out}.tmp.body

    c=$((c+1));
done

## FINAL
cat ${out}.tmp.body >> $out
rm ${out}.tmp*

echo " ~~> Generated output: ${out}"
echo ''


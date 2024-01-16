#!/bin/bash

tepid_bed=$1 # BEDfile prepared as TEPID input, Format: chr   start   end   strand   ID   family   superfamily
output_dir=$2
superfamily_TSD="${output_dir}/superfamily_TSD.txt"
TE_list="${output_dir}/TE-list.txt"
TEfamily_superfamily="${output_dir}/TEfamily-superfamily.txt"

# ---- superfamily_TSD.txt (TE_info/superfamily_TSD.txt)
# a tab-delimited file with superfamilies in the 1st column and their respective TSD lengths in the 2nd column
echo "SuperFamily\tTSD length" > $superfamily_TSD
cat $tepid_bed | cut -f7 | sort | uniq | awk '{print $NF"\t"5}' >> $superfamily_TSD
sed -i 's/Helitron\t5/Helitron\t0/' $superfamily_TSD

# ---- TE-list.txt (TE_info/TE-list.txt)
# a list of the ~~names~~ FAMILIES of the TEs annotated in the reference genome
awk '{print $6}' $tepid_bed | sort | uniq | sed 's/^[ \t]*//' > $TE_list

# ---- TEfamily-superfamily.txt (TE_info/TEfamily-superfamily.txt)
# file with TE ~~names~~ FAMILIES in the 1st column and their respective superfamily in the 2nd column
awk '{print $6"\t"$7}' $tepid_bed | sort | uniq | sed 's/^[ \t]*//' > $TEfamily_superfamily


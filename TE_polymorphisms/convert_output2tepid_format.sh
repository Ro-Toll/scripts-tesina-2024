#!/bin/bash

spltrdr_format=$1	# chr   start   end   family   accs(splits)   [all accs]
tepid_bed=$2
tepid_format=$3		# chr   start   end   strand   id   acc,list   superfamily

cut -f1-4 $spltrdr_format | sed '1d' | awk -v OFS="\t" '{a[$4]++; print $1,$2,$3,".",$4"_"a[$4]; }' > ${tepid_format}.tmp_1

awk '{for(i=6;i<=NF;i++) printf $i"\t"; print "" }' $spltrdr_format | \
 awk '{FS=OFS="\t"} {if (NR==1) split($0, header, "\t")} {for(i=0;i<=NF;i++) 
 	{if($i==1) $i=header[i]; 
 	else if ($i==0) $i=""; 
 	else if($i=="-") $i=""} print }' | \
 sed 's/\([a-zA-Z0-9\-]\+\)\t\+/\1,/g' | \
 sed -e 's/,$//g' -e 's/\t//g' -e '1d' > ${tepid_format}.tmp_2

awk 'NR!=1{print $4}' $spltrdr_format | paste ${tepid_format}.tmp_1 ${tepid_format}.tmp_2 - \
 > $tepid_format

awk '{print $6"\t"$7}' $tepid_bed | sort | uniq > ${tepid_format}.tmp_sfs
while read l; do
fam=$(echo $l | awk '{print $1}')
sf=$(echo $l | awk '{print $2}')
sed -i "s/\t$fam$/\t$sf/g" $tepid_format
done < ${tepid_format}.tmp_sfs


rm ${tepid_format}.tmp_*
echo " ~~> Generated converted output: $tepid_format"
echo ''

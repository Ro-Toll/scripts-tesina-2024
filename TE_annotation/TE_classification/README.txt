
To reclassify EDTA's GFF after running DeepTE: 

1> generate_ID-classif_list.sh <DeepTE's txt output> <file to write script's output>
2> re-classify_DeepTE-fasta.sh <original FASTA> <ID#classif list> <output>
3> re-classify_EDTA-gff.sh <original GFF> <ID#classif list> <output>


To reclassify EDTA's GFF without running DeepTE:

> re-classify_EDTA-gff_no-deepte.sh <original GFF> <output>

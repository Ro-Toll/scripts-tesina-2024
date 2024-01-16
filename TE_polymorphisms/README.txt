
To generate TEPID's input BED, Format: chr   start   end   strand   ID   family   superfamily
> generate_TEPID_bed.sh <intact TE GFF> <script output>

To generate SPLITREADER's input files:
> generate_SPLTRDR_input.sh <TEPID BED input> <script's output dir>

To convert SPLITREADER's output to TEPID's output format + superfamily column:
> convert_output2tepid_format.sh <SPLITREADER output> <TEPID BED input> <script output>

To add superfamily info to TEPID's output:
> add_class_TEPID-result.sh <TEPID's output> <TEPID's BED input> <script output> <ID column in TEPID output>

To select MAF>=n% polymorphisms:
1> count_accs_per_variant.sh <TEPID's output> <script output: file1> <accession column in TEPID output>
2> generate_accCounts.R <file1> <script output: file2> <total number of accessions>
3> select_MAF-N.R <file2> <script output: file3> <MAF fraction to select> <opertator, such as ">=">

file1 -> Polymorphism BED with number of carrier accessions in the last column
file2 -> Polymorphism BED with fraction of carrier accessions in the last column
file3 -> Selected polymorphism BED with fraction of carrier accessions in the last column

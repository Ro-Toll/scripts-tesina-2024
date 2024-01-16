
To generate a VCF file from polymorphism file(s):
> tep2vcf.sh <polymorphism BED in TEPID output format + superfamily column> <insertion "i" or deletion "d"> <reference genome FASTA> <TEPID input BED> <file with list of all accessions> <script output>

^^In case of processing multiple polymorphism BED files into one VCF, provide filenames in a comma-separated string, and a comma-separated string indicating the type of each file (insertion or deletion)

To run TASSEL's GLM GWAS:
> run_tassel.sh <TASSEL-sorted VCF (save via GUI)> <phenotype file> <PCA results (run&save via GUI)> <min MAF> <max p-value> <number of permutations> <script output preffix>

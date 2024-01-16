#!/bin/bash

genotype=$1 # VCF file
phen=$2 # phenotype file
pca=$3 # PCA results (run via TASSEL's GUI)
maf=$4 # min frequency to filter VCF
maxP=$5 # max p-value of reported results
n_permutations=$6 # number of permutations
output=$7 # output file preffix

run_pipeline.pl -forkG -importGuess $genotype -filterAlign -filterAlignMinFreq $maf -forkP -importGuess $phen \
             -forkPCA -importGuess $pca -combineM -inputG -inputP -inputPCA -intersect \
             -FixedEffectLMPlugin -maxP $maxP -permute true -nperm $n_permutations -endPlugin -export $output

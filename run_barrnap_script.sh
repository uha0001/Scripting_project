#!/bin/bash
# This script should be used to run barrnap on previously installed barrnap_ENV environment at ASC.

# Load the anaconda module:
module load anaconda/2-4.2.0_cent

# Activate previously created barrnap_ENV at ASC:
source activate barrnap_ENV

# Loop through all the .fna files to run barrnap, file as input file, out as output file for each sequence inputs.
for file in *.fna
do 
out=${file%%.fna}_barrnap_out.fasta
done;

# Extract only predicted 16S rRNA sequence:
for f in *barrnap_out.fasta
do
output=${f%%.fasta}_16S.fasta
awk "/^>/ {n++} n>1 {exit} {print}" $f > $output
done;

# Create a file to concatenate all 16S rRNA barrnap into one output file:
cat *_16S.fasta >> 16SrRNA_barrnap_output.fasta

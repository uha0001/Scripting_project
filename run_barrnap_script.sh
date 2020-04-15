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

# Create a dir to move all barrnap output files:
mkdir genomes_barrnap
mv *barrnap_out.fasta genomes_barrnap

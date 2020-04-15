#!/bin/bash

# Load anaconda module
module load anaconda/2-4.2.0_cent
# Activate previously created antismash environment:
source activate antismash

#To run for all the fna sequences in current dir, use for loop, file as input file, out as output folder for each fna files:
for file in *.fna
do 
out=${file%%.fna}_antismash_out

# The command for antismash, many options are available, here only known BGCs will be indentified.
antismash  --taxon bacteria --input-type nucl  --knownclusterblast  --outputfolder $out 
done

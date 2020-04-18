#!/bin/bash

#load anaconda
module load anaconda/2-4.2.0_cent

#activate prokka environment 
source activate prokka


#copy genome sequence into the directory
cp ~/Scripting_project/Genome_Files/*.fna .

#time to run prokka
for k in *.fna
do
prokka $k --outdir "$k".prokka_annotation --prefix $k
done

#this will generate output with each genome into a seperate directory


#Once prokka completes its work 
# now it is time to remove genome sequence from directory
rm *.fna

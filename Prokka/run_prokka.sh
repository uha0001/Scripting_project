#!/bin/bash



cp ~/Scripting_project/Genome_Files/*.fna .


for k in *.fna
do
prokka $k --outdir "$k".prokka_annotation --prefix $k


#removing the genome sequence files
rm *.fna

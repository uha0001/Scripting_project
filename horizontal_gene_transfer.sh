#!/bin/bash

cd ~/Scripting_project/alien_hunter-1.7
cp ~/Scripting_project/Genome_Files/*.fna .

#usage alien_hunter file_name.fasta output_filename
for filename in ./*.fna
do
alien_hunter $filename $filename_output -c

done

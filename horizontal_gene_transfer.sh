#!/bin/bash

#for alien_hunter to work the input files should be in the alien_hunter-1.7 folder after alien_hunter installed.

cd ~/Scripting_project/alien_hunter-1.7
cp ~/Scripting_project/Genome_Files/*.fna .

#usage alien_hunter file_name.fna output_filename
for filename in ./*.fna
do
alien_hunter $filename output_filename

done

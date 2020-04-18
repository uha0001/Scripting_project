#!/bin/bash

cd ~/Scripting_project/alien_hunter-1.7
cp ~/Scripting_project/Genome_Files/*.fna .

#Raw data files from step 1 should be moved into the alien_hunter-1.7. Then the following command can be executed.
#Split the fasta files by '>' into a file each containing one sequence, and have the name of that file be the ID
#echo -e ">hello\nAAA\n>world\nATGCA" | awk '/^>/ {fout=sprintf("%s.fasta",substr($0,2));}{print >> fout;}' *.fna


#Alien_hunter calculates the percentage of each variable region depending on horizontally transferred or not.
#usage alien_hunter file_name.fasta output_filename
for filename in ./*.fna
do
alien_hunter $filename $filename_output_Filename -a

done

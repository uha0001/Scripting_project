#!/bin/bash

cd ~/Scripting_project/alien_hunter-1.7
cp ~/Scripting_project/genome_files/*.fna .

#Raw data files from step 1 should be moved into the alien_hunter-1.7. Then the following command can be executed.
#Split the fasta files by '>' into a file each containing one sequence, and have the name of that file be the ID
awk '/^>/{s=++d".fasta"} {print > s}' *.fna

#echo -e ">hello\nAAA\n>world\nATGCA" | awk '/^>/ {fout=sprintf("%s.fasta",substr($0,2));}{print >> fout;}' *.fna

#Alien_hunter calculates the percentage of each variable region depending on horizontally transferred or not.
for k in *.fasta
do
#usage alien_hunter file_name.fasta output_filename
alien_hunter .fasta Output_Filename
done


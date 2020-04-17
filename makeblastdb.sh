#!/bin/bash

#In this first part we are going to move to the folder with the output from the annotation and pasting in a single file the 
#Data_base.fa all the genomes
cd ~/Scripting_project/Prokka
cat ~/Scripting_project/Genome_Files/*.fna >> Data_base.fa

#Now we are going to create the data base from the single file we just created
makeblastdb -dbtype nucl -in Data_base.fa -out Data_Base.fa

#Create a new folder to put the neccesary input
mkdir Individual_query

#Split the .fna file (Annotation genome output) to create single files of individual genes to use as query
echo -e ">hello\nAAA\n>world\nATGCA" | awk '/^>/ {fout=sprintf("%s.fasta",substr($0,2));}{print >> fout;}' *.fna

#Move all the neccesary input to the new folder
mv ~/Scripting_project/Prokka/*.fa* ~/Scripting_project/Prokka/Individual_query/

#Move to the new folder where all the input for the rpsblast will be located to run the command
cd ~/Scripting_project/Prokka/Individual_query

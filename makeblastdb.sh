#!/bin/bash

cd ~/Scripting_project/Prokka
cat ~/Scripting_project/Genome_Files/*.fna >> Data_base.fa

makeblastdb -dbtype nucl -in Data_base.fa -out Data_Base.fa

mkdir Individual_query

echo -e ">hello\nAAA\n>world\nATGCA" | awk '/^>/ {fout=sprintf("%s.fasta",substr($0,2));}{print >> fout;}' *.fna

mv ~/Scripting_project/Prokka/*.fa* ~/Scripting_project/Prokka/Individual_query/

cd ~/Scripting_project/Prokka/Individual_query

#!/bin/bash

cd ~/Scripting_project/Prokka
cat ~/Scripting_project/Genome_Files/*.fna >> Data_base.frn

makeblastdb -dbtype nucl -in Data_base.frn -out Data_Base.frn

#echo -e ">hello\nAAA\n>world\nATGCA" | awk '/^>/ {fout=sprintf("%s.faa",substr($0,2));}{print >> fout;}' *.fasta

Done

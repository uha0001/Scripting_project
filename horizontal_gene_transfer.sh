#!/bin/bash

#After steps 1-5

#Identify the regions that are horizontally transferred:

#download the alien_hunter
wget ftp://ftp.sanger.ac.uk/pub/resources/software/alien_hunter/alien_hunter.tar.gz

#unzip the file in the folder you are working on
tar xvzf alien_hunter.tar.gz && cd alien_hunter-1.7

#Raw data files from step 1 should be moved into the alien_hunter-1.7. Then the following command can be executed.
#Split the fasta files by '>' into a file each containing one sequence, and have the name of that file be the ID
#echo -e ">hello\nAAA\n>world\nATGCA" | awk '/^>/ {fout=sprintf("%s.fasta",substr($0,2));}{print >> fout;}' *.fna

#Alien_hunter calculates the percentage of each variable region depending on horizontally transferred or not.
#usage alien_hunter file_name.fasta output_filename
#alien_hunter *.fasta Output_Filename



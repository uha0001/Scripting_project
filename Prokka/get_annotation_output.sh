#!/bin/bash

#Copying file with all annotated feature from prokka output files
cp -r ~/Scripting_project/Prokka/b*/*.tsv .


for k in *tsv
do 

Total=$(tail -n+2 $k* | wc -l)
echo Total number of genes >> Count_$k.txt
echo $Total >> Count_$k.txt


hypothetical=$(grep -o -i hypothetical $k* |wc -l)
echo Total number of hypothetical protein >> Count_$k.txt
echo $hypothetical >> Count_$k.txt


putative=$(grep -o -i putative $k* |wc -l)
echo Total number of genes with putative identification >> Count_$k.txt
echo $putative >> Count_$k.txt


confirmed=$((Total-hypothetical-putative))
echo Total number of genes with confirmed identification >> Count_$k.txt
echo $confirmed >> Count_$k.txt

done 

rm *.tsv


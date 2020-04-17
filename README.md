#### Scripting project for BIOL7180 (spring 2020)
### Group Members: Md Jahangir Alam, Ulku Huma Altindag, Basu Kafle and Natalia Rivera Rincon

### INTRODUCTION
Genomic datasets are considered goldmine for research in biological science. The enormous amount of publicly available data opens up grat ptential for reserach, collaboration and development of new toolsets. The purpose of our current project is to utilize to current state-of-the-art toolsets to analyze publicly available bacterial genomes. Bacteria is ubiquitous, therefore analysis of bacterial genomes would give us key insights in many life science applications such as antibiotic discovery, natural product discovery, evolutionary strength, DNA modification etc. We want to download 10 Bacillus draft genome sequence from NCBI to look at some of the key features in its genomes to derive some useful information.

 We want to select draft genomes that is not complete, but fewer number of contigs (~40) are provided. Our first goal is to predict species identity using a 16S rRNA prediction tool known as barrnap. The reason is that the species identity provided by the researcher in public database is occationally not reliable for draft genomes due to the frequent mistakes with high througput genome sequencing. In additin to that, now a days, 16S rRNA prediction tools give less error rate to identify bacterial species than experimentally sequenced 16S rRNA. Therefore we plan to predict 16S rRNA sequence using downloaded draft genomes using barrnap, then use that predicted sequence to BLASTn against 16S Microbial (NCBI) database to identify bacterial species. Assesment of genome sequence and assembly quality is important to identify the key characteistics of sequence. We plan to use Quast (QUality ASsessment Tool) to evaluate genome assmblies by computing various metrics such as #contigs, length of largest contig, total bp lengh, N50, N75, L50, L75, % GC, mismatches etc. For many decades, prokaryotes (bacteria and archea) and lower eukaryotes (fungi) have been used as a potential source for novel natual product discovery. Very often, the genes corresponding for producing whole metabolic pathway are colocated together as an operon in bacteria those are reffered as biosynthetic gene clusters (BGCs). Many computational tools are available to identify BGCs in bacterial and fungal genomes such as antiSMASH, PRISM, ARTS etc. We plan to use antiSMASH to identify BGCs present in bacillus genomes.
 
 

### The aim of this project is to analyze bacterial genomes using state-of-the-arts toolsets.

Here is the main steps of the pipeline:

Step 1: Download 10 Bacillus draft genome sequences from NCBI database.: https://www.ncbi.nlm.nih.gov/genome/browse#!/prokaryotes/
Filtering options: Kingdom: Bacteria, Group: Terrabacteria group, Subgroup: Firmicutes, Assembly level: Contig,
RefSeq category: representative, Find Bacillus genome sequences.

Step 2: Predict 16S rRNA sequence using Barrnap, then identify genome species by BLASTing predicted 16S rRNA against 16S Microbial RefSeq database.
GitHub Link: https://github.com/mza0150/barrnap
Instructions: use/run the following scripts: installing barrnap: install_barrnap_script.sh, running barrnap: run_barrnap_script.sh, finally run blastn and then parse: blastn_and_blast2table.sh

Step 3: Use Quast to find key features (e.g., #bp, #N50, #L50, #contigs etc) of all genomes
GitHub Link: http://quast.sourceforge.net/docs/manual.html
Instructions: genomes_statistics_quast.sh

Step 4: Use prokka to annotate genomes.
GitHub Link: https://github.com/tseemann/prokka

Step 5: Use antiSMASH to identify biosynthetic gene clusters(BGCs) in all genomes.
Link: https://docs.antismash.secondarymetabolites.org/
Instructions: use/run the following scripts: use install antiSMASH: install_antiSMASH.sh, run antiSMASH: run_antiSMASH.sh

Step 6: Identify extent of Horizontal Gene Transfer (HGT).

This step is optional to the analysis. Whole genome sequences can be gathered from the Step 1
In order to identify the horiontally transferred regions we will be using alien hunter with the raw sequences. Raw sequences should be split by '>' into a file each containing one sequence, and have the name of that file be the ID for alien hunter to work:

```echo -e ">hello\nAAA\n>world\nATGCA" | awk '/^>/ {fout=sprintf("%s.fasta",substr($0,2));}{print >> fout;}' *.fna```

Alien_hunter can be downloaded from using: 

```wget ftp://ftp.sanger.ac.uk/pub/resources/software/alien_hunter/alien_hunter.tar.gz```

After unzipping the tar.gz file, make sure to follow the steps to complete HGT analysis:

```tar xvzf alien_hunter.tar.gz```

Before running the alien hunter make sure to move into the Alien_hunter-1.7 folder along with the data files:

```alien_hunter *.fasta Output_filename```

output will generate a histogram in the text format giving the proportions of the horizontally tranferred regions. 


Step 7: Identify homology of a specific gene of interest (e.g., P450).
We are going to use rpsblast. We will need the raw data we had from the first step as a data base and the query that is going to be the output of the genome anottation step (f.e., P450).
We need to prepare the files of the genes we want to work with for that you are going to.....


After you have the necessary input you need to run the next command changing the names of the -db -query and -out. The number are already as 20 but you can change it accordling to your needs.  

>rpsblast -db database_name -query input_file -out output_file -num_descriptions 20 -num_alignments 20

#### Scripting project for BIOL7180 (spring 2020)
### Group Members: Md Jahangir Alam, Ulku Huma Altindag, Basu Kafle and Natalia Rivera Rincon

The aim of this project is to analyze bacterial genomes using state-of-the-arts toolsets.

Here is the main steps of the pipeline:

Step 1: Download 10 Bacillus draft genome sequences from NCBI database.: https://www.ncbi.nlm.nih.gov/genome/browse#!/prokaryotes/
Filtering options: Kingdom: Bacteria, Group: Terrabacteria group, Subgroup: Firmicutes, Assembly level: Contig,
RefSeq category: representative, Find Bacillus genome sequences.

Step 2: Predict 16S rRNA sequence using Barrnap, then identify genome species by BLASTing predicted 16S rRNA against 16S Microbial RefSeq database.
GitHub Link: https://github.com/mza0150/barrnap
Instructions: use/run the following scripts: installing barrnap: install_barrnap_script.sh, running barrnap: run_barrnap_script.sh

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

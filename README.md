### Scripting project for BIOL7180 (spring 2020)
### Group Members: Md Jahangir Alam, Ulku Huma Altindag, Basu Kafle and Natalia Rivera Rincon

The aim of this project is to analyze bacterial genomes using state-of-the-arts toolsets.

Here is the main steps of the pipeline:

Step 1: Download 10 Bacillus draft genome sequences from NCBI database.
Step 2: Predict 16S rRNA sequence using Barrnap, then identify genome species by BLASTing predicted 16S rRNA against 16S Microbial RefSeq database.
Step 3: Use Quast to find key features (e.g., #bp, #N50, #L50, #contigs etc) of all genomes.
Step 4: Use prokka to annotate genomes.
Step 5: Use antiSMASH to identify biosynthetic gene clusters(BGCs) in all genomes.
Step 6: Identify extent of Horizontal Gene Transfer (HGT).
Step 7: Identify homology of a specific gene of interest (e.g., P450).

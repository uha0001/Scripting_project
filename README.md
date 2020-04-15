### Scripting project for BIOL7180 (spring 2020)
### Group: Md Jahangir Alam, Ulku Huma Altindag, Basu Kafle and Natalia Riverra Rincon

The aim of this project is to analyze bacterial genomes using state-of-the-arts toolsets.

Here is the main steps of the pipeline:
Step 1: Download 10 Bacillus draft genome sequences form NCBI database.
Step 2: Predict 16S rRNA sequence using Barrnap, then identify genome species by BLASTing predicted 16S rRNA against 16S Microbial RefSeq database.
Step 3: Use Quast ro find key features (e.g., bp, N50, L50, contigs etc) of all genomes.
Step 4: Use prokka
Step 5: Use antiSMASH to identify biosynthetic gene clusters(BGCs) in all genomes.
Step 6: Identify Horizontal Gene Transfer.
Step 7: Identify homology of a specific gene of interests.

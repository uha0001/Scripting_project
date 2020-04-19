### GROUP ID: 20A
#### Scripting project for BIOL7180 (spring 2020)
#### Group Members: Md Jahangir Alam, Ulku Huma Altindag, Basu Kafle and Natalia Rivera Rincon
### Project Title: Analyze Bacterial Genomes Using State-of-the-Arts Toolsets.


### INTRODUCTION
Genomic datasets are considered goldmine for research in biological science. The enormous amount of publicly available data opens up great potential for research, collaboration and development of new toolsets. The purpose of our current project is to utilize current state-of-the-art toolsets to analyze publicly available bacterial genomes. Bacteria is ubiquitous, therefore analysis of bacterial genomes would give us key insights in many life science applications such as antibiotic discovery, natural product discovery, evolutionary strength, DNA modification etc. We want to download 10 Bacillus draft genome sequences from NCBI to look at some of the key features in its genomes to derive some useful information.

We want to select draft genomes that are not complete, but fewer numbers of contigs (~40) are provided. Our first goal is to predict species identity using a 16S rRNA prediction tool known as barrnap. The reason is that the species identity provided by the researcher in the public database is occasionally not reliable for draft genomes due to the frequent mistakes with high throughput genome sequencing. In addition to that, nowadays, 16S rRNA prediction tools give less error rate to identify bacterial species than experimentally sequenced 16S rRNA. Therefore we plan to predict 16S rRNA sequence using downloaded draft genomes using barrnap, then use that predicted sequence to BLASTn against 16S Microbial (NCBI) database to identify bacterial species. Assessment of genome sequence and assembly quality is important to identify the key characteristics of sequence. We plan to use Quast (QUality ASsessment Tool) to evaluate genome assemblies by computing various metrics such as #contigs, length of largest contig, total bp length, N50, N75, L50, L75, % GC, mismatches etc. For many decades, prokaryotes (bacteria and archaea) and lower eukaryotes (fungi) have been used as a potential source for novel natural product discovery. Very often, the genes corresponding to producing the whole metabolic pathway are collocated together as an operon in bacteria that are referred as biosynthetic gene clusters (BGCs). Many computational tools are available to identify BGCs in bacterial and fungal genomes such as antiSMASH, PRISM, ARTS etc. We plan to use antiSMASH to identify BGCs present in bacillus genomes. Bacteria respond to selective pressures and adapt to new environments by either acquiring new genetic traits as a result of mutation and horizontal gene transfer (HGT). Diversity in the novel metabolite production generates an additional dimension of biodiversity and is particularly important to natural and managed ecosystems. In order to predict the horizontally transferred regions we will be incorporating a tool that uses the k-means clusters to identify putative HGT events with the implementation of Interpolated Variable Order Motifs (IVOMs). alien_hunter determines the power of the relationship for the candidate regions and compares them. 


 ## Pipeline for analysis:

### Step 1: Download Genomes.
Download 10 Bacillus draft genome sequences from NCBI database.: https://www.ncbi.nlm.nih.gov/genome/browse#!/prokaryotes/
Filtering options: Kingdom: Bacteria, Group: Terrabacteria group, Subgroup: Firmicutes, Assembly level: Contig, RefSeq category : representative, Find Bacillus genome sequences.

### Step 2: Identify Species.
Predict 16S rRNA sequence using Barrnap, then identify genome species by BLASTing predicted 16S rRNA against 16S Microbial RefSeq database.

Link for more information: https://github.com/mza0150/barrnap

#### Instructions for installation:
We want to create our own conda environment to avoid any conflicts with other versions of dependencies.To install in Alabama supercomputer (ASC) run to following commands:

a. first, load anaconda module: 
module load anaconda/2-4.2.0_cent

b. then, create a conda environment: 
conda create -n barrnap_ENV

c. then, Activate newly created barrnap environment: 
source activate barrnap_ENV

d. finally, Install Barrnap into activated barrnap environment: 
conda install -c bioconda -c conda-forge barrnap

#### Instructions for usage: 
1. Make sure all the sequence files ( extentison w/ .fna) in curent directory.
Run run_barrnap_script.sh to predict 16S rRNA. 

2. Make sure the final output from run_barrnap_script.sh (16SrRNA_barrnap_output.fasta) is in the current directory. Also make sure blast2table.pl is installed and functioning properly (Follow instructions from Dr. Santos class).
Run blastn_and_blast2table.sh to blastn and purse.

### Step 3: Genome Sequence Quality Assesment.
Use Quast to find key features (e.g., #bp, #N50, #L50, #contigs etc) of all genomes.
Link for more information: http://quast.sourceforge.net/docs/manual.html

#### Instructions for installation:
Follow the steps below to download quast in ASC: 
a. wget https://downloads.sourceforge.net/project/quast/quast-5.0.2.tar.gz 
b. tar -xzf quast-5.0.2.tar.gz 
c. cd quast-5.0.2 

#### Instructions for usage:
Make sure all the genome sequence (extension w/ .fna) files in current directory.
run following commands to output result as Quast_Output:
python quast.py *.fna -o Quast_Output

### Step 4: Genome Annotation using Prokka
Prokka is a software tool to annotate bacterial, archaeal and viral genomes quickly and produce standards-compliant output files.
For detail about installation and use of this tool, move into "Prokka" sub-directory.

### Step 5: Biosynthetic Gene Cluster Identification.
Using antiSMASH to identify biosynthetic gene clusters(BGCs) in all genomes.
Link for more information: https://docs.antismash.secondarymetabolites.org/

#### Instructions for installation:
We want to create our own conda environment to avoid any conflicts with other versions of dependencies. To install antiSMASH in Alabama supercomputer (ASC) run the follwoing commands:

a. first, load anaconda module: 
module load anaconda/2-4.2.0_cent

b. then, create conda environment: 
conda create -n antismash antismash

c. then activate just created antismasn environment: 
source activate antismash

d. then, download antismash database: 
download-antismash-databases

#### Note: This program requires using PFam database, if previous commands (step d) fail to download database,
Pfam database can be downloaded from the link below: wget ftp://ftp.ebi.ac.uk/pub/databases/Pfam/releases/Pfam30.0/Pfam-A.full.gz

#### Instructions for usage:
1. Make sure all the sequence files ( extentison w/ .fna in curent directory).
run run_antiSMASH.sh to identify BGCs

2. Make sure you are in the directory where all genome sequence (extension w/ .fna) files and antismash output folders (output from antiSMASH) located.
run analyze_extract_bgc.sh to extract identified name of BGC clusters.

### Step 6: Identify extent of Horizontal Gene Transfer (HGT).

### Instructions for installation:
This step is optional to the analysis of horizontally transferred regions:
In order to identify the horiontally transferred regions we will be using alien hunter with the raw sequences. 
Link to alien_hunter: ```wget ftp://ftp.sanger.ac.uk/pub/resources/software/alien_hunter/alien_hunter.tar.gz```

The download is described in "install_alien_hunter.sh" script

### Instructions for usage:
Before running the alien_hunter make sure to move into the Alien_hunter-1.7 folder along with the data files. The process is described in the "horizontal_gene_transfer.sh" script.
Output will generate a histogram in the text format giving the proportions of the horizontally tranferred regions. 



### References:
1. https://github.com/tseemann/barrnap
2. http://webhome.auburn.edu/~santosr/scripts/blast2table.prl
3. Altschul, S. F.; Gish, W.; Miller, W.; Myers, E. W.; Lipman, D. J.; J. Mol. Biol. 1990, 215 (3), 403–410
4. Gurevich, A.; Saveliev, V.; Vyahhi, N.; Tesler, G.; Bioinformatics 2013, 29 (8), 1072–1075
5. Seemann, T.; Bioinformatics 2014, 30 (14), 2068–2069
6. Blin, K.; Wolf, T.; Chevrette, M. G.; Lu, X.; Schwalen, C. J.; Kautsar, S. A.; Suarez Duran, H. G.; de los Santos, E. L. C.; Kim, H. U.; Nave, M.; Dickschat, J. S.; Mitchell, D. A.; Shelest, E.; Breitling, R.; Takano, E.; Lee, S. Y.; Weber, T.; Medema, M. H.; Nucleic Acids Res 2017, 45 (W1), W36–W41
7. Vernikos, G. S.; Parkhill, J.; Bioinformatics 2006, 22 (18), 2196–2203

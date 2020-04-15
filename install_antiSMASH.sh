
#!/bin/bash
# AntiSMASH is used to predict and identify biosynthetic gene clusters in bacterial and fungal genomes.
# Detailed instructions/information can be foudn here: https://docs.antismash.secondarymetabolites.org/
# This script is used to install antiSMASH in ASC: It is best practice to run each step individually if the scripts doesn't work
# This is because it requres user permission duing installation: 

# Load module anaconda:
module load anaconda/2-4.2.0_cent

# Create an unique environment to avoid any conflit with dependent versions.
conda create -n antismash antismash
#activate antismash environment.
source activate antismash
#download antismash database.
download-antismash-databases

#This program requires using PFam database, if previous commands fail to download database, Pfam database can be downloaded from the link below:
# wget ftp://ftp.ebi.ac.uk/pub/databases/Pfam/releases/Pfam30.0/Pfam-A.full.gz

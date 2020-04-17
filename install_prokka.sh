#!/bin/bash


#Load module anaconda:
module load anaconda

#Create environment for prokka
conda create -n prokka -c conda-forge -c bioconda prokka

#activate prokka environment
source  activate prokka

# install prokka
conda install -c bioconda/label/cf201901 prokka

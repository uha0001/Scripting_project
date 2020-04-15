
# Install Barrnap (https://github.com/tseemann/barrnap) in ASC:
# Activate anaconda module in ASC to create an unique environment:
module load anaconda/2-4.2.0_cent
# Create a conda environment:
conda create -n barrnap_ENV
# Activate newly created barrnap environment:
source activate barrnap_ENV
# Install Barrnap into activated barrnap environment
conda install -c bioconda -c conda-forge barrnap

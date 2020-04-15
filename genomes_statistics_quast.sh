
#Installation guidelines: http://quast.sourceforge.net/install.html
# This program can be used in Mac/Virtualbox/Linux server (ASC):
#To install in ASC:
wget https://downloads.sourceforge.net/project/quast/quast-5.0.2.tar.gz
tar -xzf quast-5.0.2.tar.gz
cd quast-5.0.2
# Copy all the genomes fna files into quast-5.0.2 directory to run quast
# To run quast and save outputs in output_dir:
quast.py *.fna -o output_dir

#!/bin/bash
# Provided blast+ suite at ASC will be used, the 16SMicrobial database has been downloaded from NCBI.

#Load blast+ suite on ASC:
source /opt/asn/etc/asn-bash-profiles-special/modules.sh
module load blast+/2.6.0

#BLASTn command: precompiled database from NCBI used 16SMicrobial, output will be saved as 16SrRNA_barrnap_output_BLAST_OUT
blastn -db 16SMicrobial -query 16SrRNA_barrnap_output.fasta  -out 16SrRNA_barrnap_output_BLAST_OUT -num_descriptions 10 -num_alignments 5

# Finally, the best hit will be extracted using blast2table.pl script (usage/installtion instructions followed as Dr. Santos directed)
# Link for blast2table: http://webhome.auburn.edu/~santosr/scripts/blast2table.prl

# blast2table command:
./blast2table.pl -format 10 -header -top -verbose -long  16SrRNA_barrnap_output_BLAST_OUT >16SrRNA_barrnap_output_BLAST_OUT_parsed.txt 

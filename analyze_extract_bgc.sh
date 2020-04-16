#!/bin/bash

mkdir antiSMASH_GBK_Folder

cp GCF*/*gbk antiSMASH_GBK_Folder
cd antiSMASH_GBK_Folder && rm *final.gbk

# Extract metabolites produced known BGCs from each gbk files.
grep "Detection rule(s) for this cluster type" *|awk '{print $1 "\t" $8}'|awk '$2!=""'|sed 's/.gbk//g'|sed 's/://g'|sort -u -k1> bgc_metabolites_type.txt

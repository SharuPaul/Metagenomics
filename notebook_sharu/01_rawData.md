# Raw Data Download

* 02/14/2023
* Nova: /work/gif3/sharu/Metagenomics/

Qiime2 tutorial that I am working through located here: https://bioinformaticsworkbook.org/dataAnalysis/Metagenomics/Qiime2.html#gsc.tab=0

```bash
Novadtn:
Copied the mapping file: got from Andrew
Downloaded reads data in /work/gif3/sharu/Metagenomics/data/ 
from https://www.ebi.ac.uk/ena/browser/view/PRJEB15671?dataType=PROJECT&show=reads

#make a list of names:
for n in {1678134..1678325} ; do echo ERR$n >> list ; done     
for n in {1676942..1677397} ; do echo ERR$n >> list ; done
#download data using the list:
while read line; do wget ftp://ftp.sra.ebi.ac.uk/vol1/run/ERR167/${line}/* ; done <list

```

 

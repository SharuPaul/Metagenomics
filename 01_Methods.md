
On Nova:
Downloaded data in Metagenome/data/ from https://www.ebi.ac.uk/ena/browser/view/PRJEB15671?dataType=PROJECT&show=reads

```
###Import data
Created a manifest.csv file 
Copied the mapping file 

Loaded module: qiime/2-2021.4 

problem: sample replicates 
Created manifest.csv file with unique identifiers 

time qiime tools import --type 'SampleData[PairedEndSequencesWithQuality]' --input-path /work/gif3/sharu/Metagenomics/data/manifest.csv --output-path demux.qza --input-format PairedEndFastqManifestPhred33
Imported /work/gif3/sharu/Metagenomics/data/manifest.csv as PairedEndFastqManifestPhred33 to demux.qza

real    4m31.490s
user    4m2.445s
sys     0m22.773s

####Examine data quality
time qiime demux summarize --i-data demux.qza --o-visualization demux.qzv
Saved Visualization to: demux.qzv

real    8m35.619s
user    8m7.360s
sys     0m22.476s

view data on server: https://view.qiime2.org/


####Selecting Sequence Variants
##Dada2
slurm job submitted

time qiime dada2 denoise-paired \
  --i-demultiplexed-seqs demux.qza \
  --o-table table-dada2 \
  --o-representative-sequences rep-seqs-dada2 \
  --p-trim-left-f 9 \
  --p-trim-left-r 9 \
  --p-trunc-len-f 220 \
  --p-trunc-len-r 200 \
  --p-n-threads 40 \
  --p-n-reads-learn 200000

```



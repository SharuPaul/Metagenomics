
On Nova:
Downloaded data in Metagenome/data/ from https://www.ebi.ac.uk/ena/browser/view/PRJEB15671?dataType=PROJECT&show=reads

Created a manifest.csv file
Copied the mapping file

Loaded module: qiime/2-2021.4
time qiime tools import --type 'SampleData[PairedEndSequencesWithQuality]' --input-path /work/gif3/sharu/Metagenomics/data/manifest.csv --output-path demux.qza --input-format PairedEndFastqManifestPhred33

problem: sample replicates?


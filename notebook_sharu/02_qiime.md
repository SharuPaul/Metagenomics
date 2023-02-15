# Qiime2

## Import the data as qiime object

* 02/14/2023
* Nova: /work/gif3/sharu/Metagenomics/

## Created a manifest.csv file 
##manifest.csv
##contains: sample-id,absolute-filepath,direction

```bash
#####list first part of filename in data/
find data -type f | cut -d'/' -f2 | cut -d'.' -f1

#####list absolute paths to files
for n in $(find data -type f) ; do echo $(pwd)/$n ; done

#####output forward or reverse based on R1 or R2 in filename
for n in $(find data -type f) ;do if echo "$n" | grep -q "_R1" ;then echo "forward"; elif echo "$n" | grep -q "_R2"; then echo "reverse" ; fi ;  done

####make single loop for all 3 steps above to make manifest.csv file
#####first attempt: (didn't work because of replicates)
find $(pwd)/data -type f -print0 | while read -d '' file; do filename=$(basename "$file"); path=$(dirname "$file"); fullpath="$path/$filename"; firstpart=$(echo "$filename" | cut -d'_' -f1); if echo "$filename" | grep -q "_R1"; then direction="forward"; elif echo "$filename" | grep -q "_R2"; then direction="reverse"; fi; echo "$firstpart,$fullpath,$direction" >> manifest.csv; done

##manifest file looks like this:
head manifest.csv
sample-id,absolute-filepath,direction
syncomP89,/work/gif3/sharu/Metagenomics/data/syncomP89_160125_R2.fastq.gz,reverse
syncomP89,/work/gif3/sharu/Metagenomics/data/syncomP89_160126_R1.fastq.gz,forward
GC92GC2,/work/gif3/sharu/Metagenomics/data/GC92GC2_806rcbc360_R2.fastq.gz,reverse
GC20GC1,/work/gif3/sharu/Metagenomics/data/GC20GC1_806rcbc131_R2.fastq.gz,reverse
```

using the manifest, load the fastq files into a Qiime object 

```bash
copy manifest.csv into data directory

module load qiime/2-2021.4 

time qiime tools import --type 'SampleData[PairedEndSequencesWithQuality]' --input-path /work/gif3/sharu/Metagenomics/data/manifest.csv --output-path demux.qza --input-format PairedEndFastqManifestPhred33

```

Problem: Sample replicates. Identifiers in manifest file are not unique.

## Recreate manifest.csv  

* 02/15/2023
* /work/gif3/sharu/Metagenomics

Created manifest.csv file with unique identifiers

```bash
#####need unique identifiers, created manifest using:
for n in $(find data -type f); do filename=$(echo "$n" | cut -d'/' -f2 | cut -d'.' -f1 | cut -d'_' -f1,2); abspath=$(echo "$(pwd)"/"$n") ; if echo "$n" | grep -q "_R1" ;then direction="forward"; elif echo "$n" | grep -q "_R2"; then direction="reverse" ; fi ;echo "$filename,$abspath,$direction" >> manifest.csv; done

##manifest file looks like this:
head manifest.csv
sample-id,absolute-filepath,direction
syncomP89_160125,/work/gif3/sharu/Metagenomics/data/syncomP89_160125_R2.fastq.gz,reverse
syncomP89_160126,/work/gif3/sharu/Metagenomics/data/syncomP89_160126_R1.fastq.gz,forward
GC92GC2_806rcbc360,/work/gif3/sharu/Metagenomics/data/GC92GC2_806rcbc360_R2.fastq.gz,reverse
GC20GC1_806rcbc131,/work/gif3/sharu/Metagenomics/data/GC20GC1_806rcbc131_R2.fastq.gz,reverse

```

## Import data

```bash
time qiime tools import --type 'SampleData[PairedEndSequencesWithQuality]' --input-path /work/gif3/sharu/Metagenomics/data/manifest.csv --output-path demux.qza --input-format PairedEndFastqManifestPhred33

Imported /work/gif3/sharu/Metagenomics/data/manifest.csv as PairedEndFastqManifestPhred33 to demux.qza
real    4m31.490s
user    4m2.445s
sys     0m22.773s
```

Qiime object was successfully created (data loaded into demux.qza)

## Examine data quality

```bash
time qiime demux summarize --i-data demux.qza --o-visualization demux.qzv
Saved Visualization to: demux.qzv

real    8m35.619s
user    8m7.360s
sys     0m22.476s
```

Copy to local machine and view data on server: https://view.qiime2.org/


## Selecting Sequence Variants

```bash
##dada2.sh
slurm job submitted

time qiime dada2 denoise-paired \
  --i-demultiplexed-seqs demux.qza \
  --o-table table-dada2 \
  --o-representative-sequences rep-seqs-dada2 \
  --p-trim-left-f 9 \
  --p-trim-left-r 9 \
  --p-trunc-len-f 220 \
  --p-trunc-len-r 200 \
  --p-n-threads 0 \
  --p-n-reads-learn 200000 \
  --output-dir out

```
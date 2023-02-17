# Phylogenetics
* 02/15/2023
* /work/gif3/sharu/Metagenomics
module load qiime/2-2021.4

## Multiple Sequence Alignment

```bash
Use Mafft to align sequences:
time qiime alignment mafft --i-sequences out/rep-seqs-dada2.qza --o-alignment out/aligned-rep-seqs.qza

Plugin error from alignment:

  Command '['mafft', '--preservecase', '--inputorder', '--thread', '1', '/mnt/bgfs/sharu/4356438/qiime2-archive-m60mee9y/c6bfb03b-1a16-42be-8e5b-0cf0ea3fd804/data/dna-sequences.fasta']' returned non-zero exit status 1.

Debug info has been saved to /mnt/bgfs/sharu/4356438/qiime2-q2cli-err-gnsrpah5.log

real    3m11.716s
user    2m33.493s
sys     0m22.151s

```
Search on the internet concluded it might be out of memory error. Try SLURM Sbatch.

```
mafft.sh
time qiime alignment mafft --i-sequences out/rep-seqs-dada2.qza --o-alignment out/aligned-rep-seqs.qza --verbose
```
mafft finished successfully.

## Masking sites

```bash
#Using SLURM Sbatch for all jobs now
time qiime alignment mask --i-alignment out/aligned-rep-seqs.qza --o-masked-alignment out/masked-aligned-rep-seqs.qza --verbose

```

## Creating a tree

```bash
time qiime phylogeny fasttree --i-alignment out/masked-aligned-rep-seqs.qza --o-tree out/unrooted-tree.qza --verbose

Saved Phylogeny[Unrooted] to: out/unrooted-tree.qza

real    131m20.313s
user    131m2.400s
sys     0m11.446s
```

### Rooting tree

* 02/16/2023
* /work/gif3/sharu/Metagenomics
module load qiime/2-2021.4

```bash
time qiime phylogeny midpoint-root --i-tree out/unrooted-tree.qza --o-rooted-tree out/rooted-tree.qza --verbose

Saved Phylogeny[Rooted] to: out/rooted-tree.qza

real    0m16.202s
user    0m18.752s
sys     0m9.926s
```

## Taxonomic analysis

```bash
#Need classifier file. Using weighted classifier (trained model file).
wget https://data.qiime2.org/2022.11/common/gg-13-8-99-515-806-nb-weighted-classifier.qza
#more resources available at https://docs.qiime2.org/2022.11/data-resources/

#Classify
time qiime feature-classifier classify-sklearn --i-classifier out/gg-13-8-99-515-806-nb-weighted-classifier.qza --i-reads out/rep-seqs-dada2.qza --o-classification out/taxonomy.qza --verbose

time: 22 min
Succesful.

#Visualization file
qiime metadata tabulate --m-input-file out/taxonomy.qza --o-visualization out/taxonomy.qzv

Saved Visualization to: out/taxonomy.qzv
```


* 02/17/2023
* /work/gif3/sharu/Metagenomics
module load qiime/2-2021.4

### Create a bar plot visualization of the taxonomy data:
```
time qiime taxa barplot --i-table out/table-dada2.qza --i-taxonomy out/taxonomy.qza --m-metadata-file out/AllMetadata.tsv --o-visualization out/taxa-bar-plots.qzv
```

Check the taxa-bar-plots.qzv using https://view/qiime2.org at different taxonomic levels. At level 5 we see that the data contains a lot of mitochondrial (o__Rickettsiales;f__mitochondria) and chloroplast (c__Chloroplast;o__Streptophyta;f__) contamination.

### Filtering contaminants

### This part turned out to be incorrect as filtering can be done directly through qiime in newer versions
```bash
# Export taxonomy data to tabular format
time qiime tools export --output-path taxonomy-export --input-path out/taxonomy.qza
Exported out/taxonomy.qza as TSVTaxonomyDirectoryFormat to directory taxonomy-export
real    0m7.478s
user    0m6.104s
sys     0m0.974s
# search for matching lines with grep then select the id column
grep -v -i "mitochondia|chloroplast|Feature" taxonomy-export/taxonomy.tsv | cut  -f 1 > no-chloro-mito-ids.txt
# Convert Qiime data artifact to the underlying biom file
# Export data to biom format
qiime tools export --output-path dada2-table-export --input-path out/table-dada2.qza
Exported out/table-dada2.qza as BIOMV210DirFmt to directory dada2-table-export
# Convert the HDF5 biom file to a tsv biom file
biom-format or related modules no longer available on Nova, 
trying on laptop, biom-format not compatible with windows, using WSL (Ubuntu)
pip install biom-format
####transfer files between systems as needed. (Nova and WSL)
biom subset-table --input-hdf5-fp feature-table.biom --axis observation --ids no-chloro-mito-ids.txt --output-fp feature-table-subset.biom
ValueError: The following ids could not be found in the biom table: {'Feature ID'}
```
###Solution suggested: Use qiime feature-table filter-samples
```bash
qiime feature-table filter-samples --i-table out/table-dada2.qza --m-metadata-file no-chloro-mito-ids.txt --o-filtered-table filtered-table.qza
Saved FeatureTable[Frequency] to: filtered-table.qza
moved filtered-table.qza to out/
# Create a new QIIME2 data artifact with the filtered Biom file
qiime tools import --input-path out/filtered-table.qza --output-path out/table-dada2-filtered.qza --type FeatureTable[Frequency]
There was a problem importing out/filtered-table.qza:
  out/filtered-table.qza is not a(n) BIOMV210Format file

# Export data to biom format and then create QIIME2 data artifact 
qiime tools export --output-path dada2-table-export --input-path out/filtered-table.qza
Exported out/filtered-table.qza as BIOMV210DirFmt to directory dada2-table-export

qiime tools import --input-path dada2-table-export/feature-table.biom --output-path out/table-dada2-filtered.qza --type FeatureTable[Frequency]
Imported dada2-table-export/feature-table.biom as BIOMV210DirFmt to out/table-dada2-filtered.qza
# New bar plots
qiime taxa barplot --i-table out/table-dada2-filtered.qza --i-taxonomy out/taxonomy.qza --m-metadata-file out/AllMetadata.tsv --o-visualization taxa-bar-plots-filtered.qzv
```

The visulization shows no samples? \
The table-dada2-filtered.qza file is smaller than expected. The problem is I used the filter function wrong. 

### Correct way of filtering with newer version of qiime2

```bash
time qiime taxa filter-table --i-table out/table-dada2.qza --i-taxonomy out/taxonomy.qza --p-include p__ --p-exclude mitochondria,chloroplast --o-filtered-table table-with-phyla-no-mito-chloro.qza

Saved FeatureTable[Frequency] to: table-with-phyla-no-mito-chloro.qza

real    0m12.077s
user    0m9.789s
sys     0m1.561s

# Export data to biom format 
qiime tools export --output-path dada2-table-export --input-path table-with-phyla-no-mito-chloro.qza
# Create QIIME2 data artifact 
qiime tools import --input-path dada2-table-export/feature-table.biom --output-path out/table-dada2-filtered.qza --type FeatureTable[Frequency]
# New bar plots
qiime taxa barplot --i-table out/table-dada2-filtered.qza --i-taxonomy out/taxonomy.qza --m-metadata-file out/AllMetadata.tsv --o-visualization taxa-bar-plots-filtered.qzv

Saved Visualization to: taxa-bar-plots-filtered.qzv
```

Visualization Successful! Contamination removed!

## Alpha and Beta diversity analysis

```
time qiime diversity core-metrics --i-table out/table-dada2-filtered.qza --m-metadata-file out/AllMetadata.tsv --p-sampling-depth 4000 --output-dir core-diversity
```

## Ordination
QIIME emperor plugin calculates a Bray-Curtis dissimilarity matrix and uses principal coordinates analysis (PCoA).

```
qiime emperor plot --i-pcoa core-diversity/bray_curtis_pcoa_results.qza --m-metadata-file out/AllMetadata.tsv --o-visualization pcoa-visualization.qzv
```

Visualization Successful!

## Gneiss Analysis

```bash
QIIME 2 plugin 'gneiss' has no action 'add-pseudocount'. Version 2021.4 has --p-pseudocount parameter within correlation-clustering option.

#Ward’s agglomerative clustering
time qiime gneiss correlation-clustering --i-table out/table-dada2-filtered.qza --p-pseudocount 1 --o-clustering hierarchy.qza --output-dir Gneiss


```

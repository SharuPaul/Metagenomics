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

### Ordination
QIIME emperor plugin calculates a Bray-Curtis dissimilarity matrix and uses principal coordinates analysis (PCoA).

```
qiime emperor plot --i-pcoa core-diversity/bray_curtis_pcoa_results.qza --m-metadata-file out/AllMetadata.tsv --o-visualization pcoa-visualization.qzv
```

Visualization Successful!

## Gneiss Analysis

```bash
QIIME 2 plugin 'gneiss' has no action 'add-pseudocount'. Version 2021.4 has --p-pseudocount parameter within correlation-clustering option.

#Ward’s hierarchical clustering
time qiime gneiss correlation-clustering --i-table out/table-dada2-filtered.qza --p-pseudocount 1 --o-clustering hierarchy.qza --output-dir Gneiss

Saved Hierarchy to: hierarchy.qza
real    430m17.295s
user    429m9.564s
sys     0m22.776s
```

* 02/20/2023
* /work/gif3/sharu/Metagenomics
module load qiime/2-2021.4

```bash
#Calculate the isometric log transforms 
time qiime gneiss ilr-hierarchical --i-table out/table-dada2-filtered.qza --i-tree hierarchy.qza --o-balances balances.qza

Saved FeatureTable[Balance] to: balances.qza
real    14m33.400s
user    261m53.696s
sys     11m32.647s

The options in qiime gneiss such as ols-regression, lme-regression, and balance-taxonomy are no longer available in version 2021.4. Trying some new features:

#Visualization of hierarchical clustering

time qiime gneiss dendrogram-heatmap --i-table out/table-dada2-filtered.qza --i-tree hierarchy.qza --m-metadata-file out/AllMetadata.tsv --m-metadata-column Genotype --p-color-map seismic --o-visualization heatmap.qzv

Plugin warning from gneiss:
dendrogram-heatmap is deprecated and will be removed in a future version of this plugin.
Saved Visualization to: heatmap.qzv
```


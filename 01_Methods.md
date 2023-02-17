# Methods
This is a textual summary of the methods. The analysis was performed on HPC Nova cluster at Iowa State University.

Tutorial followed:
https://bioinformaticsworkbook.org/dataAnalysis/Metagenomics/Qiime2.html#gsc.tab=0

Dataset from this paper:
Castrillo, G., Teixeira, P.J.P.L., Paredes, S.H., Law, T.F., de Lorenzo, L., Feltcher, M.E., Finkel, O.M., Breakfield, N.W., Mieczkowski, P., Jones, C.D., Paz-Ares, J., Dangl, J.L., 2017. Root microbiota drive direct integration of phosphate stress and immunity. Nature 543, 513–518. doi:10.1038/nature21417

## Data import
Sequence dataset was downloaded from www.ebi.ac.uk project PRJEB15671. All the “submitted files” were downloaded. Samples were processed using Qiime (version 2-2021.4). Manifest file created using bash.

## Quality Control
38139905 forward and reverse sequence pairs (paired-end sequences) were analyzed for quality. The reads were denoised, dereplicated, chimeras filtered, and paired reads merged using Dada2. Python pandas library was used to create metadata file, using IDs from manifest file and metadata files from supplimentary info of the paper.

## Phylogenetics
Multiple sequence alignment was performed using Mafft. Unconserved and highly gapped columns were masked from alignment using qiime alignment mask plugin.FastTree was used to make a phylogenetic tree.

## Taxonomic analysis
A pre-trained model weighted classifier was used for taxonomic classification. qiime metadata tabulate plugin was used to generate visualization of the taxonomy and qiime taxa barplot to create the taxa barplots. The visualization revealed mitochondrial and chloroplast DNA contamination. The contamination was filtered out using Qiime taxa filter-table plugin. 

## Alpha and Beta diversity analysis
Alpha and Beta diversity metrics were calculated using the qiime diversity core-metrics plugin using sampling depth of 4000. A Bray-Curtis dissimilarity matrix was calculated using principal coordinates analysis (PCoA).

## Gneiss Analysis
Gneiss Analysis was done using qiime gneiss plugin.
# Methods
This is a textual summary of the methods. The analysis was performed on HPC Nova cluster at Iowa State University.

#### Tutorial followed:
https://bioinformaticsworkbook.org/dataAnalysis/Metagenomics/Qiime2.html

#### Dataset from this paper:
Castrillo, G., Teixeira, P.J.P.L., Paredes, S.H., Law, T.F., de Lorenzo, L., Feltcher, M.E., Finkel, O.M., Breakfield, N.W., Mieczkowski, P., Jones, C.D., Paz-Ares, J., Dangl, J.L., 2017. Root microbiota drive direct integration of phosphate stress and immunity. Nature 543, 513–518. doi:10.1038/nature21417

## Data import
Sequence dataset was downloaded from www.ebi.ac.uk project PRJEB15671. All the “submitted files” were downloaded. Samples were processed using Qiime (version 2-2021.4) (Bolyen et al., 2019). Manifest file created using bash.

## Quality Control
38139905 forward and reverse sequence pairs (paired-end sequences) were analyzed for quality. The reads were denoised, dereplicated, chimeras filtered, and paired reads merged using Dada2. Python pandas library was used to create metadata file, using IDs from manifest file and metadata files from supplimentary info of the paper.

## Phylogenetics
Multiple sequence alignment was performed using Mafft (Katoh et al., 2002). Unconserved and highly gapped columns were masked from alignment using qiime alignment mask plugin. FastTree (Price et al., 2009) was used to make a phylogenetic tree.

## Taxonomic analysis
A pre-trained model: Weighted Greengenes 13_8 99% OTUs from 515F/806R region of sequences was used for taxonomic classification with qiime feature-classifier classify-sklearn (Robeson MS II et al., 2021; Bokulich, N.A. et al., 2018; Kaehler, B.D. et al., 2019). The qiime metadata tabulate plugin was used to generate visualization of the taxonomy and qiime taxa barplot to create the taxa barplots. The visualization revealed mitochondrial and chloroplast DNA contamination. The contamination was filtered out using Qiime taxa filter-table. 

## Alpha and Beta diversity analysis
Alpha and Beta diversity metrics were calculated using the qiime diversity core-metrics plugin using sampling depth of 4000. A Bray-Curtis dissimilarity matrix was calculated using principal coordinates analysis (PCoA).

## Gneiss Analysis
Gneiss Analysis was done using qiime gneiss plugin (Morton, J.T. et al., 2017). Ward’s hierarchical clustering was performed and isometric log transforms were calculated on each internal node of the tree. Finally, dendrogram-heatmap was generated to visualize the hierarchical clustering.


## References
Bolyen, Evan, et al. "Reproducible, interactive, scalable and extensible microbiome data science using QIIME 2." Nature biotechnology 37.8 (2019): 852-857; https://doi.org/10.1038/s41587-019-0209-9

Katoh, Kazutaka et al. "MAFFT: a novel method for rapid multiple sequence alignment based on fast Fourier transform." Nucleic acids research 30.14 (2002): 3059-3066.

Price, Morgan N., Paramvir S. Dehal, and Adam P. Arkin. "FastTree: computing large minimum evolution trees with profiles instead of a distance matrix." Molecular biology and evolution 26.7 (2009): 1641-1650.

Michael S Robeson II et al. (2021) "RESCRIPt: Reproducible sequence taxonomy reference database management." PLOS Computational Biology 17(11): e1009581. https://doi.org/10.1371/journal.pcbi.1009581

Bokulich, N.A., Kaehler, B.D., Rideout, J.R. et al. Optimizing taxonomic classification of marker-gene amplicon sequences with QIIME 2’s q2-feature-classifier plugin. Microbiome 6, 90 (2018). https://doi.org/10.1186/s40168-018-0470-z

Kaehler, B.D., Bokulich, N.A., McDonald, D. et al. Species abundance information improves sequence taxonomy classification accuracy. Nature Communications 10, 4643 (2019). https://doi.org/10.1038/s41467-019-12669-6

James T. Morton et al. (2017) "Balance Trees Reveal Microbial Niche Differentiation." MSystems, 2(1), e00162-16. DOI: https://doi.org/10.1128/mSystems.00162-16
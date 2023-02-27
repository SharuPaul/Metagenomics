Tutorial followed:
https://bioinformaticsworkbook.org/dataAnalysis/Metagenomics/Qiime2.html

Dataset from this paper:
Castrillo, G., Teixeira, P.J.P.L., Paredes, S.H., Law, T.F., de Lorenzo, L., Feltcher, M.E., Finkel, O.M., Breakfield, N.W., Mieczkowski, P., Jones, C.D., Paz-Ares, J., Dangl, J.L., 2017. Root microbiota drive direct integration of phosphate stress and immunity. Nature 543, 513–518. doi:10.1038/nature21417


# Input data 
Input folder contains input files
list # list used to download reads data
manifest.csv  # manifest file 
AllMetadata.tsv  # File containing all metadata

# Output data
Visualizations folder contains all visualization files:
* **Summary Statistics/Taxa bar plot**
    * demux.qzv 
    * table-dada2.qzv 
    * table-with-metadata-dada2.qzv 
    * taxonomy.qzv 
    * taxa-bar-plots.qzv 
    * taxa-bar-plots-filtered.qzv 

* **PCA type plots**
    * bray_curtis_emperor.qzv  
    * jaccard_emperor.qzv 
    * pcoa-visualization.qzv 
    * heatmap.qzv 

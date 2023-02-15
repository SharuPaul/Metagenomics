# Methods
This is a textual summary of the methods

## Data import
Data was downloaded from www.ebi.ac.uk project PRJEB15671. All the “submitted files” were downloaded.
Samples were processed using Qiime (version 2-2021.4). Manifest file created using bash. First attempt at making qiime object unsuccessful due to repeated IDs in the manifest file. Recreated the manifest file with unique identifiers. Data import successful, time taken: 4.5 min.

## Quality Control
38139905 forward and reverse sequence pairs (paired-end sequences) were analyzed for quality.
Sequence variants were selected using Dada2. Time to run: 2 hrs.
Since I am using all files and not a small subset like the tutorial, the time taken is higher.

Adding metadata step did not work on interactive node. Submitted job using Sbatch.

## Phylogenetics
Multiple sequence alignment ussing Mafft ended up in errors. It was due to memory limits. Using Sbatch for all jobs.
MSA successful.
Masking sites
Creating Tree
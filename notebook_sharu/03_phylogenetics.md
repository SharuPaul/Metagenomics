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

```
```

### Rooting tree

```
```

## Taxonomic analysis

```
```

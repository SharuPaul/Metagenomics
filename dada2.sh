#!/bin/bash

# Copy/paste this job script into a text file and submit with the command:
#    sbatch thefilename
# job standard output will go to the file slurm-%j.out (where %j is the job ID)

#SBATCH --time=96:00:00   # walltime limit (HH:MM:SS)
#SBATCH --nodes=2   # number of nodes
#SBATCH --ntasks-per-node=36   # 36 processor core(s) per node 
#SBATCH --mail-user=sharu@iastate.edu   # email address
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL

# LOAD MODULES, INSERT CODE, AND RUN YOUR PROGRAMS HERE

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




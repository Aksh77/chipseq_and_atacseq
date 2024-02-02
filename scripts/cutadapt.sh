#!/bin/bash
#SBATCH --account=sam77_h
#SBATCH --time=30:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=4
#SBATCH --mem=40GB
#SBATCH --partition=sla-prio
#SBATCH --job-name=cutadapt
#SBATCH --output=/storage/group/sam77/default/lab/akshatha/logs/cutadapt.out
umask 007

source /storage/work/abn5461/miniforge3/bin/activate /storage/work/abn5461/miniforge3/envs/gene-env

cd /storage/group/sam77/default/lab/akshatha
mkdir -p data/oct4_trimmed

cutadapt -a file:files/adapters.fa -o data/oct4_trimmed/Oct4_EB_rep2_sv118_trimmed.fastq.gz data/oct4/Oct4_EB_rep2_sv118.fastq.gz --cores=8 -m 20
cutadapt -a file:files/adapters.fa -o data/oct4_trimmed/Oct4_EB_rep1_sv112_trimmed.fastq.gz data/oct4/Oct4_EB_rep1_sv112.fastq.gz --cores=8 -m 20
cutadapt -a file:files/adapters.fa -o data/oct4_trimmed/Oct4_EB+12h-iNIL_rep2_sv119_trimmed.fastq.gz data/oct4/Oct4_EB+12h-iNIL_rep2_sv119.fastq.gz --cores=8 -m 20
cutadapt -a file:files/adapters.fa -o data/oct4_trimmed/Oct4_EB+12h-iNIL_rep1_sv113_trimmed.fastq.gz data/oct4/Oct4_EB+12h-iNIL_rep1_sv113.fastq.gz --cores=8 -m 20
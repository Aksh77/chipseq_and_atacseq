#!/bin/bash
#SBATCH --account=sam77_h
#SBATCH --time=30:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=4
#SBATCH --mem=40GB
#SBATCH --partition=sla-prio
#SBATCH --job-name=trim
#SBATCH --output=/storage/group/sam77/default/lab/akshatha/logs/trimmomatic.out
umask 007

source /storage/work/abn5461/miniforge3/bin/activate /storage/work/abn5461/miniforge3/envs/gene-env

cd /storage/group/sam77/default/lab/akshatha/data
ADAPTER=/storage/work/abn5461/miniforge3/envs/gene-env/share/trimmomatic/adapters/NexteraPE-PE.fa

SEQ1=ATAC_EB_rep1
mkdir -p oct4_trimmed/${SEQ1}
trimmomatic PE oct4/${SEQ1}_{R1,R2}.fastq.gz oct4_trimmed/${SEQ1}/${SEQ1}_{R1,R2}_trimmed_{paired,unpaired}.fastq.gz ILLUMINACLIP:${ADAPTER}:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36

SEQ2=ATAC_EB_rep2
mkdir -p oct4_trimmed/${SEQ2}
trimmomatic PE oct4/${SEQ2}_{R1,R2}.fastq.gz oct4_trimmed/${SEQ2}/${SEQ2}_{R1,R2}_trimmed_{paired,unpaired}.fastq.gz ILLUMINACLIP:${ADAPTER}:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36

SEQ3=ATAC_EB+12h-iNIL_rep1
mkdir -p oct4_trimmed/${SEQ3}
trimmomatic PE oct4/${SEQ3}_{R1,R2}.fastq.gz oct4_trimmed/${SEQ3}/${SEQ3}_{R1,R2}_trimmed_{paired,unpaired}.fastq.gz ILLUMINACLIP:${ADAPTER}:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36

SEQ4=ATAC_EB+12h-iNIL_rep2
mkdir -p oct4_trimmed/${SEQ4}
trimmomatic PE oct4/${SEQ4}_{R1,R2}.fastq.gz oct4_trimmed/${SEQ4}/${SEQ4}_{R1,R2}_trimmed_{paired,unpaired}.fastq.gz ILLUMINACLIP:${ADAPTER}:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36

#!/bin/bash
#SBATCH --account=sam77_h
#SBATCH --time=30:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=4
#SBATCH --mem=40GB
#SBATCH --partition=sla-prio
#SBATCH --job-name=trim
#SBATCH --output=/storage/group/sam77/default/lab/akshatha/predict_tf_binding/logs/trim.out
umask 007

source /storage/work/abn5461/miniforge3/bin/activate /storage/work/abn5461/miniforge3/envs/gene-env

cd /storage/group/sam77/default/lab/akshatha/predict_tf_binding/data
OUT_DIR=/storage/group/sam77/default/lab/akshatha/predict_tf_binding/data/oct4_trimmed
mkdir -p $OUT_DIR

# Trim adapters in chip-seq data
CHIP_SEQS=(Oct4_EB_rep1_sv112 Oct4_EB_rep2_sv118 Oct4_EB+12h-iNIL_rep1_sv113 Oct4_EB+12h-iNIL_rep2_sv119)
for SEQ in ${CHIP_SEQS[@]}
do
    cutadapt -a file:files/adapters.fa -o ${OUT_DIR}/${SEQ}_trimmed.fastq.gz oct4/${SEQ}.fastq.gz --cores=8 -m 20
done

# Trim adapters in atac-seq data
ADAPTER=/storage/work/abn5461/miniforge3/envs/gene-env/share/trimmomatic/adapters/NexteraPE-PE.fa
ATAC_SEQS=(ATAC_EB_rep1 ATAC_EB_rep2 ATAC_EB+12h-iNIL_rep1 ATAC_EB+12h-iNIL_rep2)
for SEQ in ${ATAC_SEQS[@]}
do
    trimmomatic PE oct4/${SEQ1}_{R1,R2}.fastq.gz ${OUT_DIR}/${SEQ1}/${SEQ1}_{R1,R2}_trimmed_{paired,unpaired}.fastq.gz ILLUMINACLIP:${ADAPTER}:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36
done

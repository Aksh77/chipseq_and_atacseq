#!/bin/bash
#SBATCH --account=sam77_h
#SBATCH --time=30:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=4
#SBATCH --mem=80GB
#SBATCH --partition=sla-prio
#SBATCH --job-name=align
#SBATCH --output=/storage/group/sam77/default/lab/akshatha/predict_tf_binding/logs/align.out
umask 007

# Activate conda environment
source /storage/work/abn5461/miniforge3/bin/activate /storage/work/abn5461/miniforge3/envs/allo

cd /storage/group/sam77/default/lab/akshatha/predict_tf_binding/data

# Sequences
SEQS=(ATAC_EB_rep1 ATAC_EB_rep2 ATAC_EB+12h-iNIL_rep1 ATAC_EB+12h-iNIL_rep2)

# Align with bowtie
OUT_DIR=/storage/group/sam77/default/lab/akshatha/predict_tf_binding/data/oct4_alignments
mkdir -p $OUT_DIR
for SEQ in ${SEQS[@]}
do
    bowtie -q ~/group/genomes/mm10/mm10 -1 oct4_trimmed/${SEQ}/${SEQ}_R1_trimmed_paired.fastq.gz -2 oct4_trimmed/${SEQ}/${SEQ}_R2_trimmed_paired.fastq.gz -S ${OUT_DIR}/${SEQ}_MMR.sam --best --strata -m 100 -k 100 -p 8 --chunkmbs 200
done
bowtie -q ~/group/genomes/mm10/mm10 control.fastq.gz -S ${OUT_DIR}/control_MMR.sam --best --strata -m 100 -k 100 -p 8 --chunkmbs 200

# Sort files
cd $OUT_DIR
mkdir -p sorted
for SEQ in ${SEQS[@]}
do
    samtools collate -o sorted/${SEQ}_MMR_sort.sam ${SEQ}_MMR.sam
done
samtools collate -o sorted/control_MMR_sort.sam control_MMR.sam

# Allocate multi-mapped reads
cd ${OUT_DIR}/sorted
for SEQ in ${SEQS[@]}
do
    echo "allo ${SEQ}_MMR_sort.sam -seq se -p 8"
    allo ${SEQ}_MMR_sort.sam -seq se -p 8
done
allo control_MMR_sort.sam -seq se -p 8 --random

# Organize files
cd $OUT_DIR
mkdir -p ${OUT_DIR}/allo
mv sorted/*allo* allo/

# Convert sam to bam
cd ${OUT_DIR}/allo
ls *sam | xargs -I {} -n 1 samtools view -h -Sb {} -o {}.bam
mkdir -p bam
mv *bam bam/

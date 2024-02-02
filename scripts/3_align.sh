#!/bin/bash
#SBATCH --account=sam77_h
#SBATCH --time=30:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=4
#SBATCH --mem=80GB
#SBATCH --partition=sla-prio
#SBATCH --job-name=bowtie
#SBATCH --output=/storage/group/sam77/default/lab/akshatha/predict_tf_binding/logs/bowtie.out
umask 007

# Activate conda environment
source /storage/work/abn5461/miniforge3/bin/activate /storage/work/abn5461/miniforge3/envs/allo

OUT_DIR=/storage/group/sam77/default/lab/akshatha/predict_tf_binding/data/oct4_alignments
mkdir -p $OUT_DIR
cd /storage/group/sam77/default/lab/akshatha/predict_tf_binding/data

# Align with bowtie
SEQS=(ATAC_EB_rep1 ATAC_EB_rep2 ATAC_EB+12h-iNIL_rep1 ATAC_EB+12h-iNIL_rep2)
for SEQ in ${SEQS[@]}
do
    bowtie -q ~/group/genomes/mm10/mm10 -1 oct4_trimmed/${SEQ}/${SEQ}_R1_trimmed_paired.fastq.gz -2 oct4_trimmed/${SEQ}/${SEQ}_R2_trimmed_paired.fastq.gz -S ${OUT_DIR}/${SEQ}_MMR.sam --best --strata -m 100 -k 100 -p 8 --chunkmbs 200
done

# Convert sam to bam
cd $OUT_DIR
ls *sam | xargs -I {} -n 1 samtools view -h -Sb {} -o {}.bam

# Organize files
mkdir -p sam bam
mv *sam sam/
mv *bam bam/

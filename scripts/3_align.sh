#!/bin/bash
#SBATCH --account=sam77_h
#SBATCH --time=30:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=80GB
#SBATCH --partition=sla-prio
#SBATCH --job-name=align
#SBATCH --output=/storage/group/sam77/default/lab/akshatha/predict_tf_binding/logs/align.out
#SBATCH --error=/storage/group/sam77/default/lab/akshatha/predict_tf_binding/logs/align.err
umask 007

# Activate conda environment
source /storage/work/abn5461/miniforge3/bin/activate /storage/work/abn5461/miniforge3/envs/allo

cd /storage/group/sam77/default/lab/akshatha/predict_tf_binding/data

# Sequences
CHIP_AND_CONTROL_SEQS=(Oct4_EB_rep1_sv112 Oct4_EB_rep2_sv118 Oct4_EB+12h-iNIL_rep1_sv113 Oct4_EB+12h-iNIL_rep2_sv119 \
    input_EB_1_SV101 input_EB+12hr-iNIL_1_SV73)
ATAC_SEQS=(ATAC_EB_rep1 ATAC_EB_rep2 ATAC_EB+12h-iNIL_rep1 ATAC_EB+12h-iNIL_rep2)

OUT_DIR=/storage/group/sam77/default/lab/akshatha/predict_tf_binding/data/alignments

# Align with bowtie
mkdir -p $OUT_DIR
# align chipseq and control data in single end mode
for SEQ in ${CHIP_AND_CONTROL_SEQS[@]}
do
    bowtie -q ~/group/genomes/mm10/mm10 trimmed_sequences/${SEQ}_trimmed.fastq.gz -S ${OUT_DIR}/${SEQ}_MMR.sam --best --strata -m 100 -k 100 -p 8 --chunkmbs 200
done
# align atacseq data in paired end mode
for SEQ in ${ATAC_SEQS[@]}
do
    bowtie -q ~/group/genomes/mm10/mm10 -1 trimmed_sequences/${SEQ}/${SEQ}_R1_trimmed_paired.fastq.gz -2 oct4_trimmed/${SEQ}/${SEQ}_R2_trimmed_paired.fastq.gz -S ${OUT_DIR}/${SEQ}_MMR.sam --best --strata -m 100 -k 100 -p 8 --chunkmbs 200
done

# Sort all files
cd $OUT_DIR
mkdir -p sorted
SEQS=(${CHIP_AND_CONTROL_SEQS[@]} ${CONTROL_SEQS[@]})
for SEQ in ${SEQS[@]}
do
    samtools collate -o sorted/${SEQ}_MMR_sort.sam ${SEQ}_MMR.sam
done

# Allocate multi-mapped reads
cd ${OUT_DIR}/sorted
for SEQ in ${SEQS[@]}
do
    echo "allo ${SEQ}_MMR_sort.sam -seq se -p 8"
    allo ${SEQ}_MMR_sort.sam -seq se -p 8
done

# Organize files
cd $OUT_DIR
mkdir -p ${OUT_DIR}/allo
mv sorted/*allo* allo/

# Convert sam to bam
cd ${OUT_DIR}/allo
ls *sam | xargs -I {} -n 1 samtools view -h -Sb {} -o {}.bam
mkdir -p bam
mv *bam bam/

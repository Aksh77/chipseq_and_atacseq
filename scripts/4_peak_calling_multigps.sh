#!/bin/bash
#SBATCH --account=sam77_h
#SBATCH --time=48:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=80GB
#SBATCH --partition=sla-prio
#SBATCH --job-name=peakcalling_multigps
#SBATCH --output=/storage/group/sam77/default/lab/akshatha/predict_tf_binding/logs/peak_multigps.out
#SBATCH --error=/storage/group/sam77/default/lab/akshatha/predict_tf_binding/logs/peak_multigps.err
umask 007

source /storage/work/abn5461/miniforge3/bin/activate /storage/work/abn5461/miniforge3/envs/gene-env
cd ~/group/lab/akshatha/predict_tf_binding/data/alignments/allo/bam

# peak calling using multigps
MULTIGPS=~/group/code/jars/multigps.v0.75.mahonylab.jar
GENOME_DIR=~/group/genomes/mm10

MULTIGPS_OUT_CHIP=~/group/lab/akshatha/predict_tf_binding/data/peaks_multigps_chip
DESIGN_FILE_CHIP=~/group/lab/akshatha/predict_tf_binding/files/oct4_chip.design

MULTIGPS_OUT_ATAC=~/group/lab/akshatha/predict_tf_binding/data/peaks_multigps_atac
DESIGN_FILE_ATAC=~/group/lab/akshatha/predict_tf_binding/files/oct4_atac.design

# chipseq data
mkdir -p $MULTIGPS_OUT_CHIP
java -Xmx64G -jar $MULTIGPS --geninfo ${GENOME_DIR}/mm10.info --seq ${GENOME_DIR}/mm10.fa \
    --design $DESIGN_FILE_CHIP --threads 10 --out $MULTIGPS_OUT_CHIP --exclude ${GENOME_DIR}/annotation/mm10-blacklist_ENCODE.regions

# atacseq data
mkdir -p $MULTIGPS_OUT_ATAC
java -Xmx64G -jar $MULTIGPS --geninfo ${GENOME_DIR}/mm10.info --seq ${GENOME_DIR}/mm10.fa \
    --design $DESIGN_FILE_ATAC --threads 10 --out $MULTIGPS_OUT_ATAC --exclude ${GENOME_DIR}/annotation/mm10-blacklist_ENCODE.regions

#!/bin/bash
#SBATCH --account=sam77_h
#SBATCH --time=12:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=40GB
#SBATCH --partition=sla-prio
#SBATCH --job-name=fastqc
#SBATCH --output=/storage/group/sam77/default/lab/akshatha/predict_tf_binding/logs/fastqc.out
#SBATCH --error=/storage/group/sam77/default/lab/akshatha/predict_tf_binding/logs/fastqc.err
umask 007

source /storage/work/abn5461/miniforge3/bin/activate /storage/work/abn5461/miniforge3/envs/gene-env
OUT_DIR=/storage/group/sam77/default/lab/akshatha/predict_tf_binding/results/fastqc_reports

# QC for oct4 data
cd /storage/group/sam77/default/lab/akshatha/predict_tf_binding/data/oct4
fastqc *fastq.gz -o $OUT_DIR

# QC for control data
cd /storage/group/sam77/default/lab/akshatha/predict_tf_binding/data/control
fastqc *fastq.gz -o $OUT_DIR

mv ${OUT_DIR}/*.html ${OUT_DIR}/html/
mv ${OUT_DIR}/*.zip ${OUT_DIR}/zip/

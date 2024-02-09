#!/bin/bash
#SBATCH --account=sam77_h
#SBATCH --time=30:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=60GB
#SBATCH --partition=sla-prio
#SBATCH --job-name=macs2
#SBATCH --output=/storage/group/sam77/default/lab/akshatha/predict_tf_binding/logs/peak_macs.out
#SBATCH --error=/storage/group/sam77/default/lab/akshatha/predict_tf_binding/logs/peak_macs.err
umask 007

source /storage/work/abn5461/miniforge3/bin/activate /storage/work/abn5461/miniforge3/envs/gene-env
cd ~/group/lab/akshatha/predict_tf_binding/data/alignments/allo/bam

MACS2_OUT_DIR=~/group/lab/akshatha/predict_tf_binding/data/peaks_macs2
mkdir -p $MACS2_OUT_DIR

CONTROL1=input_EB_1_SV101_MMR_sort.allo.sam.bam
CONTROL2=input_EB+12hr-iNIL_1_SV73_MMR_sort.allo.sam.bam

# chipseq data
SEQ1=Oct4_EB
SEQ1_REP1=Oct4_EB_rep1_sv112_MMR_sort.allo.sam.bam
SEQ1_REP2=Oct4_EB_rep2_sv118_MMR_sort.allo.sam.bam

SEQ2=Oct4_EB+12h-iNIL
SEQ2_REP1=Oct4_EB+12h-iNIL_rep1_sv113_MMR_sort.allo.sam.bam
SEQ2_REP2=Oct4_EB+12h-iNIL_rep2_sv119_MMR_sort.allo.sam.bam

macs2 callpeak -t ${SEQ1_REP1} ${SEQ1_REP2} -c ${CONTROL1} -f BAM -g mm -n ${SEQ1} --outdir $MACS2_OUT_DIR
macs2 callpeak -t ${SEQ2_REP1} ${SEQ2_REP2} -c ${CONTROL2} -f BAM -g mm -n ${SEQ2} --outdir $MACS2_OUT_DIR

# atacseq data
SEQ1=ATAC_EB
SEQ1_REP1=ATAC_EB_rep1_MMR_sort.allo.sam.bam
SEQ1_REP2=ATAC_EB_rep2_MMR_sort.allo.sam.bam

SEQ2=ATAC_EB+12h-iNIL
SEQ2_REP1=ATAC_EB+12h-iNIL_rep1_MMR_sort.allo.sam.bam
SEQ2_REP2=ATAC_EB+12h-iNIL_rep2_MMR_sort.allo.sam.bam

macs2 callpeak -t ${SEQ1_REP1} ${SEQ1_REP2} -c ${CONTROL1} -f BAM -g mm -n ${SEQ1} --outdir $MACS2_OUT_DIR
macs2 callpeak -t ${SEQ2_REP1} ${SEQ2_REP2} -c ${CONTROL2} -f BAM -g mm -n ${SEQ2} --outdir $MACS2_OUT_DIR

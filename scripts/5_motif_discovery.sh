#!/bin/bash
#SBATCH --account=sam77_h
#SBATCH --time=48:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=60GB
#SBATCH --partition=sla-prio
#SBATCH --job-name=motif
#SBATCH --output=/storage/group/sam77/default/lab/akshatha/predict_tf_binding/logs/motif.out
#SBATCH --error=/storage/group/sam77/default/lab/akshatha/predict_tf_binding/logs/motif.err
umask 007

source /storage/work/abn5461/miniforge3/bin/activate /storage/work/abn5461/miniforge3/envs/gene-env
cd ~/group/lab/akshatha/predict_tf_binding/data/peaks_macs2

MEMECHIP=/storage/group/sam77/default/software/meme-5.5.1/bin/meme-chip
OUT_DIR=/storage/group/sam77/default/lab/akshatha/predict_tf_binding/data/motifs_macs2
SEQS=(Oct4_EB Oct4_EB+12h-iNIL ATAC_EB ATAC_EB+12h-iNIL)

mkdir -p $OUT_DIR

for SEQ in ${SEQS[@]}
do
    # Get 100bp sequences centred around peaks from the summit file
    awk -v OFS='\t' '{print $1,$2-50,$2+50}' ${SEQ}_summits.bed > ${SEQ}_peaks_100.bed

    # Converting bed files to fasta files
    bedtools getfasta -fi ~/group/genomes/mm10/mm10.fa -bed ${SEQ}_peaks_100.bed > ${SEQ}_peaks_100.fasta
    
    # skip repeatmasker step because we are interested in motifs in repetitive regions
    # Find motifs using meme-chip
    echo "$MEMECHIP -oc ${OUT_DIR}/${SEQ} -meme-nmotifs 5 -meme-mod anr -minw 6 -maxw 20 ${SEQ}_peaks.fasta"
    $MEMECHIP -oc ${OUT_DIR}/${SEQ} -meme-nmotifs 5 -meme-mod anr -minw 6 -maxw 20 ${SEQ}_peaks.fasta
done

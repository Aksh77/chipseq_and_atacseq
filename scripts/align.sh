#!/bin/bash
#SBATCH --account=sam77_h
#SBATCH --time=30:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=4
#SBATCH --mem=80GB
#SBATCH --partition=sla-prio
#SBATCH --job-name=allo
#SBATCH --output=/storage/group/sam77/default/lab/akshatha/logs/allo.out
umask 007

source /storage/work/abn5461/miniforge3/bin/activate /storage/work/abn5461/miniforge3/envs/allo

OUT_DIR=/storage/group/sam77/default/lab/akshatha/data/oct4_alignments
mkdir -p $OUT_DIR

cd /storage/group/sam77/default/lab/akshatha/data

SEQ1=ATAC_EB_rep1
bowtie -q ~/group/genomes/mm10/mm10 oct4_trimmed/${SEQ1}/${SEQ1}_R1_trimmed_paired.fastq.gz -S ${OUT_DIR}/${SEQ1}_R1_paired_MMR.sam --best --strata -m 100 -k 100 -p 8 --chunkmbs 200
bowtie -q ~/group/genomes/mm10/mm10 oct4_trimmed/${SEQ1}/${SEQ1}_R1_trimmed_unpaired.fastq.gz -S ${OUT_DIR}/${SEQ1}_R1_unpaired_MMR.sam --best --strata -m 100 -k 100 -p 8 --chunkmbs 200
bowtie -q ~/group/genomes/mm10/mm10 oct4_trimmed/${SEQ1}/${SEQ1}_R2_trimmed_paired.fastq.gz -S ${OUT_DIR}/${SEQ1}_R2_paired_MMR.sam --best --strata -m 100 -k 100 -p 8 --chunkmbs 200
bowtie -q ~/group/genomes/mm10/mm10 oct4_trimmed/${SEQ1}/${SEQ1}_R2_trimmed_unpaired.fastq.gz -S ${OUT_DIR}/${SEQ1}_R2_unpaired_MMR.sam --best --strata -m 100 -k 100 -p 8 --chunkmbs 200

SEQ2=ATAC_EB_rep2
bowtie -q ~/group/genomes/mm10/mm10 oct4_trimmed/${SEQ2}/${SEQ2}_R1_trimmed_paired.fastq.gz -S ${OUT_DIR}/${SEQ2}_R1_paired_MMR.sam --best --strata -m 100 -k 100 -p 8 --chunkmbs 200
bowtie -q ~/group/genomes/mm10/mm10 oct4_trimmed/${SEQ2}/${SEQ2}_R1_trimmed_unpaired.fastq.gz -S ${OUT_DIR}/${SEQ2}_R1_unpaired_MMR.sam --best --strata -m 100 -k 100 -p 8 --chunkmbs 200
bowtie -q ~/group/genomes/mm10/mm10 oct4_trimmed/${SEQ2}/${SEQ2}_R2_trimmed_paired.fastq.gz -S ${OUT_DIR}/${SEQ2}_R2_paired_MMR.sam --best --strata -m 100 -k 100 -p 8 --chunkmbs 200
bowtie -q ~/group/genomes/mm10/mm10 oct4_trimmed/${SEQ2}/${SEQ2}_R2_trimmed_unpaired.fastq.gz -S ${OUT_DIR}/${SEQ2}_R2_unpaired_MMR.sam --best --strata -m 100 -k 100 -p 8 --chunkmbs 200

SEQ3=ATAC_EB+12h-iNIL_rep1
bowtie -q ~/group/genomes/mm10/mm10 oct4_trimmed/${SEQ3}/${SEQ3}_R1_trimmed_paired.fastq.gz -S ${OUT_DIR}/${SEQ3}_R1_paired_MMR.sam --best --strata -m 100 -k 100 -p 8 --chunkmbs 200
bowtie -q ~/group/genomes/mm10/mm10 oct4_trimmed/${SEQ3}/${SEQ3}_R1_trimmed_unpaired.fastq.gz -S ${OUT_DIR}/${SEQ3}_R1_unpaired_MMR.sam --best --strata -m 100 -k 100 -p 8 --chunkmbs 200
bowtie -q ~/group/genomes/mm10/mm10 oct4_trimmed/${SEQ3}/${SEQ3}_R2_trimmed_paired.fastq.gz -S ${OUT_DIR}/${SEQ3}_R2_paired_MMR.sam --best --strata -m 100 -k 100 -p 8 --chunkmbs 200
bowtie -q ~/group/genomes/mm10/mm10 oct4_trimmed/${SEQ3}/${SEQ3}_R2_trimmed_unpaired.fastq.gz -S ${OUT_DIR}/${SEQ3}_R2_unpaired_MMR.sam --best --strata -m 100 -k 100 -p 8 --chunkmbs 200

SEQ4=ATAC_EB+12h-iNIL_rep2
bowtie -q ~/group/genomes/mm10/mm10 oct4_trimmed/${SEQ4}/${SEQ4}_R1_trimmed_paired.fastq.gz -S ${OUT_DIR}/${SEQ4}_R1_paired_MMR.sam --best --strata -m 100 -k 100 -p 8 --chunkmbs 200
bowtie -q ~/group/genomes/mm10/mm10 oct4_trimmed/${SEQ4}/${SEQ4}_R1_trimmed_unpaired.fastq.gz -S ${OUT_DIR}/${SEQ4}_R1_unpaired_MMR.sam --best --strata -m 100 -k 100 -p 8 --chunkmbs 200
bowtie -q ~/group/genomes/mm10/mm10 oct4_trimmed/${SEQ4}/${SEQ4}_R2_trimmed_paired.fastq.gz -S ${OUT_DIR}/${SEQ4}_R2_paired_MMR.sam --best --strata -m 100 -k 100 -p 8 --chunkmbs 200
bowtie -q ~/group/genomes/mm10/mm10 oct4_trimmed/${SEQ4}/${SEQ4}_R2_trimmed_unpaired.fastq.gz -S ${OUT_DIR}/${SEQ4}_R2_unpaired_MMR.sam --best --strata -m 100 -k 100 -p 8 --chunkmbs 200

cd $OUT_DIR
mkdir -p sam bam

ls *sam | xargs -I {} -n 1 samtools view -h -Sb {} -o {}.bam

mv *sam sam/
mv *bam bam/

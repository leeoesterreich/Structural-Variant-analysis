#!/bin/bash

# This script is used to Call structural variants from GRIDSS (the Genomic Rearrangement IDentification Software Suite).

# Author=Rahul_kumar/LeeOestereich lab

#SBATCH --job-name=GRIDSS_SV
#SBATCH -N 1
#SBATCH --cpus-per-task=64
#SBATCH -t 1-00:00
#SBATCH --output=/bgfs/alee/LO_LAB/Personal/Rahul/Test_sample/Structural_variant/Gridss/Gridss.out

# Modules required
module purge
module load gcc/8.2.0
module load gridss/2.13.2

# Reference genome fasta file
reference="/bgfs/alee/LO_LAB/Personal/Rahul/Reference_genome/Human/Human_ref_hg38_p7/Human_genome_hg38_p7_chr_only.fna"

# Exclude_list bed file 
# We can find ENCODE exclude list files at "https://www.encodeproject.org/files/ENCFF356LFX/"
exclude_list="/bgfs/alee/LO_LAB/Personal/Rahul/Test_sample/Structural_variant/Gridss/GRCh38_unified_blacklist.bed"

# Gridss jar
gridss_jar="/ihome/crc/install/gridss/2.13.2/python3.11/share/gridss-2.13.2-3/gridss.jar"

# Input directory
input_dir="/bgfs/alee/LO_LAB/Personal/Rahul/Test_sample/5_mkdup"

# Output directory
output_dir="/bgfs/alee/LO_LAB/Personal/Rahul/Test_sample/Structural_variant/Gridss"

echo "Generating vcf file for each recal_bam files.."

# Iterate over each recal_bam file in the input directory
for recal_bam in "$input_dir"/*.recal.bam; do
    # Extract sample name from the recal_bam file name
    sample=$(basename "$recal_bam" .recal.bam)

    # Output vcf file for the sample
    output="${output_dir}/${sample}.vcf"

    # Run GRIDSS to detect structural variants
    gridss \
      -r "$reference" \
      -j "$gridss_jar" \
      -o "$output" \
      -b "$exclude_list" \
      "$recal_bam"

    echo "VCF file created for $sample"
done

echo "VCF file generated for all sample"


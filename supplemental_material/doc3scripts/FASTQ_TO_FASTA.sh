#PBS -N FASTQ_TO_FASTA
#PBS -m ae
#PBS -M playera1@jhuapl.edu
#PBS -l nodes=1:ppn=16
#PBS -l walltime=24:00:00
#PBS -j oe
#PBS -o /home/playera1/sandbox/classifier_comparison/metagenomic_input/classifier_input/FASTQ_TO_FASTA.log



d="/home/playera1/sandbox/classifier_comparison/metagenomic_input/classifier_input"

fastq_to_fasta -i "$d/MiSeq_meta_sim.fq" -o "$d/MiSeq_meta_sim.fa"

fastq_to_fasta -i "$d/PacBio_CLR_meta_sim.fq" -o "$d/PacBio_CLR_meta_sim.fa"

fastq_to_fasta -i "$d/PacBio_CCS_meta_sim.fq" -o "$d/PacBio_CCS_meta_sim.fa"

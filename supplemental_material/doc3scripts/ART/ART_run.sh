#PBS -N simulating_data_ART
#PBS -m ae
#PBS -M playera1@jhuapl.edu
#PBS -l nodes=1:ppn=16
#PBS -l walltime=24:00:00
#PBS -j oe
#PBS -o /home/playera1/sandbox/classifier_comparison/metagenomic_input/ART_run.log

refseqs='/home/playera1/sandbox/classifier_comparison/metagenomic_input/refseqs'
out_path='/home/playera1/sandbox/classifier_comparison/metagenomic_input/illumina_reads/sim_raw_reads'

mkdir -p $out_path


#BACTERIA --------single-end, 250bp, 10 DoC
find "$refseqs/Bacteria" -name "*.f*" -print0 | while read -d $'\0' refseq; do
	base=$(basename "${refseq}")
#	echo 'ART generation using '$base
	art_illumina -i $refseq -l 250 -f 10 -o $out_path/$base.ART_l250f10
done


#VIRUSES --------single-end, 250bp, 100 DoC
find "$refseqs/Viruses" -name "*.f*" -print0 | while read -d $'\0' refseq; do
	base=$(basename "${refseq}")
#	echo 'ART generation using '$base
	art_illumina -i $refseq -l 250 -f 100 -o $out_path/$base.ART_l250f100
done



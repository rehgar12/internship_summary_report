#PBS -N simulating_data_PBSIM
#PBS -m ae
#PBS -M playera1@jhuapl.edu
#PBS -l nodes=1:ppn=16
#PBS -l walltime=24:00:00
#PBS -j oe
#PBS -o /home/playera1/sandbox/classifier_comparison/metagenomic_input/PBsim_run.log

refseqs='/home/playera1/sandbox/classifier_comparison/metagenomic_input/refseqs'
out_path='/home/playera1/sandbox/classifier_comparison/metagenomic_input/pacbio/sim_raw_reads'

mkdir -p $out_path

model_path='/home/playera1/bin/pbsim-1.0.3-Linux-amd64/data'


#PacBio BACTERIA-------------- DoC 5
find "$refseqs/Bacteria" -name "*.f*" -print0 | while read -d $'\0' fasta; do
	base=$(basename "${fasta}")
#	echo $base
	pbsim --data-type CLR --depth 40 --model_qc "$model_path/model_qc_clr" "$fasta" --prefix "clr_model_d5.$base"

	pbsim --data-type CCS --depth 5 --model_qc "$model_path/model_qc_ccs" "$fasta" --prefix "ccs_model_d5.$base"

done


#PacBio VIRUSES-------------- DoC 5
find "$refseqs/Viruses" -name "*.f*" -print0 | while read -d $'\0' fasta; do
	base=$(basename "${fasta}")
#	echo $base
	pbsim --data-type CLR --depth 1000 --model_qc "$model_path/model_qc_clr" "$fasta" --prefix "clr_model_d100.$base"

	pbsim --data-type CCS --depth 400 --model_qc "$model_path/model_qc_ccs" "$fasta" --prefix "ccs_model_d100.$base"

done


pbsim --data-type CLR --depth 100 --model_qc /home/playera1/bin/pbsim-1.0.3-Linux-amd64/data/model_qc_clr ../refseqs/Viruses/NC_001486.fna --prefix 'clr_model_d100'

#PBS -N kraken_comp_run
#PBS -m ae
#PBS -M playera1@jhuapl.edu
#PBS -l nodes=1:ppn=32
#PBS -l walltime=24:00:00
#PBS -j oe
#PBS -o /home/playera1/sandbox/classifier_comparison/kraken/results_run3_kraken_comp.log

export PATH=/data/apps/bin/surpi/:/data/apps/bin/:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

comp_dir="/home/playera1/sandbox/classifier_comparison"
kraken_dir="/home/playera1/sandbox/classifier_comparison/kraken"


mkdir -p "$kraken_dir/results_run3_kraken_comp"

metagenomic_input="/home/playera1/sandbox/classifier_comparison/metagenomic_input/classifier_input"
find "$metagenomic_input" -name "*meta_sim.fa" -print0 | while read -d $'\0' meta_fa;do
	base=$(basename "$meta_fa")

	qstat -u playera1 -n
	/usr/bin/time -f "%M max RSS, %E walltime, %S cpu sec (kernel mode), %U cpu sec (user mode), %P cpu (S+U)/E, %t RSS in Kb" \
	kraken \
		--db "$kraken_dir/kraken_db-for_comp" \
		--threads 64 \
		--fasta-input "$meta_fa" > "$kraken_dir/results_run3_kraken_comp/$base.kraken"

done

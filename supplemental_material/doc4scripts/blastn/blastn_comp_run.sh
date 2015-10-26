#PBS -N blastn_comp_run
#PBS -m ae
#PBS -M playera1@jhuapl.edu
#PBS -l nodes=1:ppn=32
#PBS -l walltime=24:00:00
#PBS -j oe
#PBS -o /home/playera1/sandbox/classifier_comparison/blastn/blastn_comp_run4.log
export PATH=/data/apps/bin/surpi/:/data/apps/bin/:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin


blastnpath="/home/playera1/sandbox/classifier_comparison/blastn"

outpath="/home/playera1/sandbox/classifier_comparison/blastn/blastn_comp_run4"
mkdir -p "$outpath"

metagenomic_input="/home/playera1/sandbox/classifier_comparison/metagenomic_input/classifier_input"
find "$metagenomic_input" -name "*meta_sim.fa" -print0 | while read -d $'\0' meta_fa;do
	base=$(basename "$meta_fa")

	qstat -u playera1 -n
	/usr/bin/time -f "%M max RSS, %E walltime, %S cpu sec (kernel mode), %U cpu sec (user mode), %P cpu (S+U)/E, %t RSS in Kb" \
	blastn -db "$blastnpath/database/BV_db" \
		-query "$meta_fa" \
		-out "$outpath/$base.b6" \
		-outfmt 6 \
		-max_target_seqs 1 \
		-num_threads 64
done

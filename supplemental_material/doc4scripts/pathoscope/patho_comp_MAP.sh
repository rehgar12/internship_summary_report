#PBS -N patho_comp_MAP
#PBS -m ae
#PBS -M playera1@jhuapl.edu
#PBS -l nodes=1:ppn=32
#PBS -l walltime=240:00:00
#PBS -j oe
#PBS -o /home/playera1/sandbox/classifier_comparison/pathoscope/results_run_patho.log
export PATH=/data/apps/bin/surpi/:/data/apps/bin/:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin


comp_dir="/home/playera1/sandbox/classifier_comparison"
target_lib="/home/playera1/sandbox/classifier_comparison/pathoscope/libraries/patho_comp_target-lib_ti.fa"
filter_lib="/home/playera1/sandbox/classifier_comparison/pathoscope/libraries/patho_comp_filter-lib_ti.fa"

outpath="/home/playera1/sandbox/classifier_comparison/pathoscope/results_run_patho"
mkdir -p "$outpath"

metagenomic_input="/home/playera1/sandbox/classifier_comparison/metagenomic_input/classifier_input"
find "$metagenomic_input" -name "*meta_sim.fq" -print0 | while read -d $'\0' meta_fq;do
	base=$(basename "$meta_fq"

	qstat -u playera1 -n
	/usr/bin/time -f "%M max RSS, %E walltime, %S cpu sec (kernel mode), %U cpu sec (user mode), %P cpu (S+U)/E, %t RSS in Kb" \
	pathoscope MAP -U $meta_fq -targetRefFiles $target_lib -filterRefFiles $filter_lib -outDir $outpath -outAlign "$base.sam" -expTag $base

done

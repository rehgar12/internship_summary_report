#PBS -N patho_single_MAP_CLR
#PBS -m ae
#PBS -M playera1@jhuapl.edu
#PBS -l nodes=1:ppn=32
#PBS -l walltime=240:00:00
#PBS -j oe
#PBS -o /home/playera1/sandbox/classifier_comparison2/pathoscope_singles/patho_single_MAP_CLR.log
export PATH=/data/apps/bin/surpi/:/data/apps/bin/:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin


comp_dir="/home/playera1/sandbox/classifier_comparison2"
target_lib="/home/playera1/sandbox/classifier_comparison/pathoscope/libraries/patho_comp_target-lib_ti.fa"
filter_lib="/home/playera1/sandbox/classifier_comparison/pathoscope/libraries/patho_comp_filter-lib_ti.fa"

outpath="/home/playera1/sandbox/classifier_comparison2/pathoscope_singles/results_patho_singles_CLR"
mkdir -p "$outpath"

metagenomic_input="/home/playera1/sandbox/classifier_comparison2/metagenomic_input/PATHOSCOPE_input/CLR_meta_sim_1k"


patho_MAP_one() {
	input="$1"
	base=$(basename "$input" | sed 's/.fq//')

	pathoscope MAP -U $input \
		-targetRefFiles $target_lib -filterRefFiles $filter_lib -outDir $outpath -outAlign "$base.IDinput" -expTag $base
}
export target_lib
export filter_lib
export outpath
export -f patho_MAP_one

find "$metagenomic_input" -name "*.fq" -print0 | parallel -0 -n 1 -P 8 -I '{}' patho_MAP_one '{}'




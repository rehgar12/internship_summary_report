#PBS -N patho_single_ID_CCS
#PBS -m ae
#PBS -M playera1@jhuapl.edu
#PBS -l nodes=1:ppn=32
#PBS -l walltime=240:00:00
#PBS -j oe
#PBS -o /home/playera1/sandbox/classifier_comparison2/pathoscope_singles/patho_single_ID_CCS.log
export PATH=/data/apps/bin/surpi/:/data/apps/bin/:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin


comp_dir="/home/playera1/sandbox/classifier_comparison2"
patho_path="/home/playera1/sandbox/classifier_comparison2/pathoscope_singles"

outpath="$patho_path/REPORTS_and_STATS/patho_singles_ID_CCS_results"
mkdir -p "$outpath"

input="$patho_path/results_patho_singles_CCS"


patho_ID_one() {
	input="$1"
	echo $input
	base=$(basename "$input" | sed s'/.IDinput//')
	echo $base
	pathoscope ID -alignFile "$input" -fileType sam -outDir "$outpath" -expTag "$base.ID"
}
export outpath
export -f patho_ID_one

find "$input" -name "*.IDinput" -print0 | parallel -0 -n 1 -P 64 -I '{}' patho_ID_one '{}'


#PBS -N krakenReports_CLR
#PBS -m ae
#PBS -M playera1@jhuapl.edu
#PBS -l nodes=1:ppn=16
#PBS -l walltime=240:00:00
#PBS -j oe
#PBS -o /home/playera1/sandbox/classifier_comparison2/kraken_singles/krakenReport_CLR.log
export PATH=/data/apps/bin/surpi/:/data/apps/bin/:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

db_path="/home/playera1/sandbox/classifier_comparison/kraken/kraken_db-for_comp"
input_dir="/home/playera1/sandbox/classifier_comparison2/kraken_singles/kraken_breakout/kraken_output_1k_CLR"
outpath="/home/playera1/sandbox/classifier_comparison2/kraken_singles/REPORT_and_STATS/reports_CLR"
mkdir -p "$outpath"

kraken_report_one() {
	input="$1"
	base=$(basename "$input")

    kraken-report \
        --db "$db_path" "$input" > "$outpath/$base.report"
}
export db_path
export outpath
export -f kraken_report_one

find "$input_dir" -name "*_kraken*" -print0 | parallel -0 -n 1 -P 32 -I '{}' kraken_report_one '{}'
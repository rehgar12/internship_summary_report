#PBS -N taxid2taxstring_CLR
#PBS -m ae
#PBS -M playera1@jhuapl.edu
#PBS -l nodes=1:ppn=4
#PBS -l walltime=240:00:00
#PBS -j oe
#PBS -o /home/playera1/sandbox/classifier_comparison2/higher_tax_STATS/BLASTN/qsub_taxid2taxstring_CLR.log
export PATH=/data/apps/bin/surpi/:/data/apps/bin/:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

path="/home/playera1/sandbox/classifier_comparison2/higher_tax_STATS/BLASTN"
STEP2="/home/playera1/sandbox/classifier_comparison2/higher_tax_STATS/BLASTN/STEP2"

names_nodes="/data/indices/ftp.ncbi.nlm.nih.gov/pub/taxonomy"

outpath="$path/STEP3/leaftoRoot_CLR"
mkdir -p "$outpath"

find "$STEP2/gi_pair_count_CLR.breakout/pred_ti_lists" -name "*.pti_list" | while read pti_filepath;do
	true_gi=$(basename "$pti_filepath" | sed 's/.pti_list//')
#	echo $true_gi

	taxid2taxstring.sh -i "$pti_filepath" -t "$names_nodes" -o "$outpath/$true_gi.pti-ltr"

done
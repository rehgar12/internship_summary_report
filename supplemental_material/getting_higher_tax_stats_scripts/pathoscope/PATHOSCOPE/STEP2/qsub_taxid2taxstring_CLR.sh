#PBS -N taxid2taxstring_CLR
#PBS -m ae
#PBS -M playera1@jhuapl.edu
#PBS -l nodes=1:ppn=4
#PBS -l walltime=240:00:00
#PBS -j oe
#PBS -o /home/playera1/sandbox/classifier_comparison2/higher_tax_STATS/PATHOSCOPE/qsub_taxid2taxstring_CLR.log
export PATH=/data/apps/bin/surpi/:/data/apps/bin/:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

path="/home/playera1/sandbox/classifier_comparison2/higher_tax_STATS/PATHOSCOPE"

names_nodes="/data/indices/ftp.ncbi.nlm.nih.gov/pub/taxonomy"

outpath="$path/STEP2/leaftoRoot_CLR"
mkdir -p "$outpath"

find "$path/STEP1/ID_breakout_taxid_ONLY_CLR" -name "*.pathoID.taxids" | while read filepath;do
	processing_gi=$(basename "$filepath" | sed 's/.pathoID.taxids//')
	taxid2taxstring.sh -i "$filepath" -t "$names_nodes" -o "$outpath/$processing_gi.pti-ltr"
done
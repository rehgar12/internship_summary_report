#PBS -N parallel_gi2taxid
#PBS -m ae
#PBS -M playera1@jhuapl.edu
#PBS -l nodes=1:ppn=16
#PBS -l walltime=240:00:00
#PBS -j oe
#PBS -o /home/playera1/sandbox/classifier_comparison2/blastn_singles/higher_tax_STATS/qsub_parallel_gi2taxid.log
export PATH=/data/apps/bin/surpi/:/data/apps/bin/:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

path="/home/playera1/sandbox/classifier_comparison2/blastn_singles/higher_tax_STATS"
outpath="$path/gi2taxid_parallel_output"
mkdir -p "$outpath"

parallel_gi2taxid() {
	input="$1"
	base=$(basename "$input")
	while read gi;do
	grep -P "^$gi\t" "/data/indices/ftp.ncbi.nih.gov/pub/taxonomy/gi_taxid_nucl.dmp" >> "$outpath/$base.taxid"
	done < $input

}
export outpath
export file_basename
export -f parallel_gi2taxid


find "$path" -name "*.gi2taxidInput" | while read filename;do
	fn=$(basename $filename)
	echo $fn
	mkdir -p "$path/$fn.broken"
	while read line;
		do echo $line > "$path/$fn.broken/gi_taxid_pair_$line-tmp.txt"
	done < "$filename"
	find "$path" -name "gi_taxid_pair_*-tmp.txt" -print0 | parallel -0 -n 1 -P 32 -I '{}' parallel_gi2taxid '{}'
done



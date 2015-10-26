#PBS -N slow_gi2taxid_CLR
#PBS -m ae
#PBS -M playera1@jhuapl.edu
#PBS -l nodes=1:ppn=4
#PBS -l walltime=240:00:00
#PBS -j oe
#PBS -o /home/playera1/sandbox/classifier_comparison2/higher_tax_STATS/BLASTN/qsub_slow_gi2taxid_CLR.log
export PATH=/data/apps/bin/surpi/:/data/apps/bin/:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

#!/bin/bash


path="/home/playera1/sandbox/classifier_comparison2/higher_tax_STATS/BLASTN"
nucldmp="/data/indices/ftp.ncbi.nlm.nih.gov/pub/taxonomy/gi_taxid_nucl.dmp"


#cutting out gi \t predicted gi pairs
cut -f2,3 "$path/gi_pair_count_CLR.tsv" | sort | uniq > "$path/gi_pair_count_CLR_tmp.gi2taxidInput"


#break out each true gi into a file of its predicted gis
while read pairs;do
echo ----------------------------1st
echo $pairs > "$path/cut_pairs_tmp.txt"
true_gi=$(cut -f1 -d$' ' "$path/cut_pairs_tmp.txt")
true_ti=$(cut -f2 -d$' ' "$path/cut_pairs_tmp.txt")
	find "$path" -name "gi_pair_count_CLR_tmp.gi2taxidInput" | while read filename;do
	echo ----------------------------2nd
	fn=$(basename $filename | sed 's/_tmp.gi2taxidInput//')
	#echo $fn
	mkdir -p "$path/$fn.breakout"
		while read line;do
#		echo ----------------------------3rd
		echo $line > "$path/pred_lines_tmp.txt"
		true_gi_inb6=$(cut -f1 -d$' ' "$path/pred_lines_tmp.txt")
		pred_gi_inb6=$(cut -f2 -d$' ' "$path/pred_lines_tmp.txt")
			if [ "$true_gi_inb6" = "$true_gi" ]
			then
			pred_ti_inb6=$(grep -P "^$pred_gi_inb6\t" "$nucldmp")

			echo "$true_gi	$pred_ti_inb6" >> "$path/$fn.breakout/$true_gi_inb6.tgi-pgi-pti.tsv"
			echo "$true_gi	$pred_ti_inb6"
			fi
		done < "$filename"
	done

done < "$path/gi_taxid_pairs.tsv"


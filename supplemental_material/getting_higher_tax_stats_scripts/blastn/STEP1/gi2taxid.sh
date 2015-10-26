#!/bin/bash


path="/home/playera1/sandbox/classifier_comparison2/blastn_singles/higher_tax_STATS"
nucldmp="/data/indices/ftp.ncbi.nlm.nih.gov/pub/taxonomy/gi_taxid_nucl.dmp"



#TESTING
#cut -f2,3 test_gi2taxid.tsv | sort | uniq > pred_gi_test_tmp.gi2taxidInput

#cutting out gi \t predicted gi pairs
cut -f2,3 gi_pair_count_MiSeq.tsv | sort | uniq > pred_gi_MiSeq_tmp.gi2taxidInput
cut -f2,3 gi_pair_count_CLR.tsv | sort | uniq > pred_gi_CLR_tmp.gi2taxidInput
cut -f2,3 gi_pair_count_CCS.tsv | sort | uniq > pred_gi_CCS_tmp.gi2taxidInput

#break out each true gi into a file of its predicted gis
while read pairs;do
echo ----------------------------1st
echo $pairs > cut_pairs_tmp.txt
true_gi=$(cut -f1 -d$' ' cut_pairs_tmp.txt)
true_ti=$(cut -f2 -d$' ' cut_pairs_tmp.txt)
	find "$path" -name "*_tmp.gi2taxidInput" | while read filename;do
	echo ----------------------------2nd
	fn=$(basename $filename | sed 's/_tmp.gi2taxidInput//')
	#echo $fn
	mkdir -p "$path/$fn.breakout"
		while read line;do
#		echo ----------------------------3rd
		echo $line > pred_lines_tmp.txt
		true_gi_inb6=$(cut -f1 -d$' ' pred_lines_tmp.txt)
		pred_gi_inb6=$(cut -f2 -d$' ' pred_lines_tmp.txt)
			if [ "$true_gi_inb6" = "$true_gi" ]
			then
			pred_ti_inb6=$(grep -P "^$pred_gi_inb6\t" "$nucldmp")


			echo "$true_gi	$pred_ti_inb6" >> "$path/$fn.breakout/$true_gi_inb6.tgi-pgi-pti.tsv"
			echo "$true_gi	$pred_ti_inb6"
			fi
		done < "$filename"
	done

done < gi_taxid_pairs.tsv










rm *_tmp*

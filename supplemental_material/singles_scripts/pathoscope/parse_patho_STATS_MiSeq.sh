#!/bin/bash

#usage
#
#	bash parse_patho_STATS.sh true_gi_taxid_list.tsv
report_path="/home/playera1/sandbox/classifier_comparison2/pathoscope_singles/REPORTS_and_STATS"


while read gi_and_taxid;do
echo $gi_and_taxid > gi_taxid_tmp.txt
true_gi_list=$(cut -f1 -d$' ' gi_taxid_tmp.txt)
true_ti_list=$(cut -f2 -d$' ' gi_taxid_tmp.txt)

	find "$report_path/patho_singles_ID_MiSeq_results" -name "*report.tsv" | while read tsv;do
	true_gi=$(basename "$tsv" | sed -e 's/patho_input_//' -e 's/.ID-sam-report.tsv//')
		if [ $true_gi == $true_gi_list ]
		then
		pred_taxid_count=0
		#echo $true_gi
		pred_taxid=$(tail -1 $tsv | cut -f1 | sed 's/ti|//')
			if [ $pred_taxid == $true_ti_list ]
			then
			pred_taxid_count=$(tail -1 $tsv | cut -f4 | sed 's/\.0//')
			FN_count=$(bc -l <<< "1000-$pred_taxid_count")
			echo $true_gi,$true_ti_list,$pred_taxid,$pred_taxid_count,$FN_count
			else
			FN_count=$(bc -l <<< "1000-$pred_taxid_count")
			echo $true_gi,$true_ti_list,$pred_taxid,$pred_taxid_count,$FN_count
			fi
		fi
	done
done < $1




rm *_tmp.txt

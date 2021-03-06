#!/bin/bash

#	bash breakout_taxids_count.sh <read_type>


path="/home/playera1/sandbox/classifier_comparison2/higher_tax_STATS/PATHOSCOPE"
patho_reports="/home/playera1/sandbox/classifier_comparison2/pathoscope_singles/REPORTS_and_STATS"


mkdir -p "$path/STEP1/ID_breakout_taxid_ONLY_"$1""
find "$patho_reports/patho_singles_ID_"$1"_results" -name "patho_input_*.ID-sam-report.tsv" | while read filepath; do
	processing_gi=$(basename $filepath | sed -e 's/patho_input_//' -e 's/.ID-sam-report.tsv//')
	echo ----------------------------$processing_gi
	while read ID_report_line;do 
	#	echo ----------------------------
		taxid=$(echo $ID_report_line | sed 's/ti|//' | cut -f1 -d$' ')
		if [ "$taxid" != "Total" ]
			then
			if [ "$taxid" != "Genome" ]
				then
				hit_count=$(echo $ID_report_line | sed 's/ti|//' | cut -f4 -d$' ')
				echo "$taxid" >> "$path/STEP1/ID_breakout_taxid_ONLY_"$1"/$processing_gi.pathoID.taxids"
			fi
		fi
	done < $filepath
done

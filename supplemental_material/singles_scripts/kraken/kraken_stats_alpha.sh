#!/bin/bash

#usage
#
#		bash kraken_stats_alpha.sh true_gi_taxid_list_<F|G|S|NORANK>.tsv <report_readType-directoryname>

report_path="/home/playera1/sandbox/classifier_comparison2/kraken_singles/REPORT_and_STATS/$2"



while read true_gi_taxid;do
echo $true_gi_taxid > gi_taxid_tmp.txt
true_gi_list=$(cut -f1 -d$' ' gi_taxid_tmp.txt)
true_ti_list=$(cut -f2 -d$' ' gi_taxid_tmp.txt)

	find "$report_path" -name "*kraken.report" | while read report;do
#	echo $report
	cat $report > report_tmp.txt
#	cat report_tmp.txt
	true_gi=$(basename "$report" | sed -e 's/.*_kraken_//' -e 's/.kraken.report//')
#	echo $true_gi
		if [ $true_gi == $true_gi_list ]
		then
		TP_count=0
		FN_count=0
		FP_count=0
#		echo $true_gi---------------------------------------------
			while read report_line;do
			echo $report_line > report_line_tmp.txt
#			cat report_line_tmp.txt
			report_taxid=$(cut -f5 -d$' ' report_line_tmp.txt)
#			echo $report_taxid
				if [ $report_taxid == $true_ti_list ]
				then
				TP=$(cut -f2 -d$' ' report_line_tmp.txt)
				TP_count=$TP
#				echo FIRST IF LOOP ------------------
				fi
			done < report_tmp.txt

			while read report_line;do
			echo $report_line > report_line_tmp.txt
#			cat report_line_tmp.txt
			report_taxid=$(cut -f5 -d$' ' report_line_tmp.txt)
#			echo $report_taxid
				if [ $report_taxid == 0 ]
				then
				unclassified=$(cut -f2 -d$' ' report_line_tmp.txt)
				FN_count=$unclassified
				P=$(bc -l <<< "1000-$unclassified")
				FP_count=$(bc -l <<< "$P-$TP_count")
#				echo SECOND IF LOOP ^^^^^^^^^^^^^^^^^^
				fi
			done < report_tmp.txt
		echo $true_gi,$true_ti_list,$TP_count,$FP_count,$FN_count
		fi

	done
done < $1







rm *_tmp.txt

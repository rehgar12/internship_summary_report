#!/bin/bash

#usage
#
#	bash gi_pair_stats.sh gi_pair_count_<type of read>.tsv true_gi_list.tsv


while read gi_from_list;do
	count_tp=0		#initialize TP count
	count_fp=0		#initialize FP count
#	echo gi from list is $gi_from_list
	while read line;do
		echo $line > line_tmp.txt
		true_gi=$(cut -f2 -d' ' line_tmp.txt)
#		echo $true_gi
		if [ "$gi_from_list" = "$true_gi" ]
			then
#			echo '---------true gi = gi from list'
			pred_gi=$(cut -f3 -d' ' line_tmp.txt)
			if [ "$true_gi" = "$pred_gi" ]
				then
				count=$(cut -f1 -d' ' line_tmp.txt)
				count_tp=$(bc -l <<< "$count_tp+$count")
				else
				count=$(cut -f1 -d' ' line_tmp.txt)
				count_fp=$(bc -l <<< "$count_fp+$count")
			fi
		fi
	done < $1
	total_classified=$(bc -l <<< "$count_tp+$count_fp")
	unclassified_reads=$(bc -l <<< "1000-$total_classified")

	echo $gi_from_list,$count_tp,$count_fp,$unclassified_reads
done < $2


rm *_tmp.txt
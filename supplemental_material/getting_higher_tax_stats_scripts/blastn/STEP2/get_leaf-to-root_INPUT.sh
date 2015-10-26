#!/bin/bash

outpath="gi_pair_count_CCS.breakout/pred_ti_lists"
mkdir -p "$outpath"
 
#count=0
find "gi_pair_count_CCS.breakout/" -name "*pti.tsv" | while read file_path;do
	true_gi=$(basename "$file_path" | sed 's/.tgi-pgi-pti.tsv//')
#	count=$(bc -l <<< "$count+1")
#	echo $true_gi-----------------
#	echo $count
	cut -f3 $file_path > "$outpath/$true_gi.pti_list"
done
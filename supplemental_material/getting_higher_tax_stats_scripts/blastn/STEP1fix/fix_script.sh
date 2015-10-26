#!/bin/bash

path="/home/playera1/sandbox/classifier_comparison2/higher_tax_STATS/BLASTN"
outpath="$path/STEP1fix/triplet_MiSeq"
mkdir -p "$outpath"

find "$path/STEP1/gi_pair_count_MiSeq.breakout" -name "*.tgi-pgi-pti.tsv" | while read x;do
#	echo -----------------$x
	while read line;do 
		gi=$(echo $line | cut -f1 -d$' ')
		if [ "$line" != "$gi" ]
			then 
			tgi=$(echo $line | cut -f1 -d$' ')
			pgi=$(echo $line | cut -f2 -d$' ')
			pti=$(echo $line | cut -f3 -d$' ')
			echo "$tgi	$pgi	$pti" >> "$outpath/$tgi.triplet.tsv"
		fi
	done < $x
done


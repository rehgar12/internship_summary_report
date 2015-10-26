#!/bin/bash


#	bash refseq_bp_counter.sh


while read ordered_accession;do
	find "/home/playera1/sandbox/classifier_comparison/metagenomic_input/generation_sandbox/refseqs" -name "*C_*" | while read filepath;do
		refseq_accession=$(basename $filepath | sed 's/\.f.*//')
		if [ "$ordered_accession" = "$refseq_accession" ]
			then
			bp_count=0
			while read refseq;do
			header=$(echo $refseq | sed 's/|.*//')
			#echo $header
			if [ "$header" != ">gi" ]
				then
			#	echo ------------------
				line_count=$(echo $header | wc -c)
				bp_count=$(bc -l <<< "$bp_count+$line_count")
			#	echo $bp_count
			fi

			done < $filepath
			echo $refseq_accession,$bp_count
		fi
	done
done < accession_list_ordered.txt

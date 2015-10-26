#!/bin/bash

#usage	tax_level_counter.sh <family|genus|species|lowest> <read_type>


path="/home/playera1/sandbox/classifier_comparison2/higher_tax_STATS/BLASTN/"

while read gi_taxid_ordered;do
	processing_gi=$(echo $gi_taxid_ordered | cut -f1 -d$' ')
	processing_ti=$(echo $gi_taxid_ordered | cut -f2 -d$' ')
	#parse taxid2taxstring output for the 26 true organism taxids (and order them)
	while read ltr_of26;do
#		echo --1st
		taxid_of26=$(echo $ltr_of26 | cut -f1 -d$' ')
		if [ "$processing_ti" = "$taxid_of26" ]
			then
			#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#
			#FAMILY LEVEL
			if [ "$1" = "family" ]
				then
#				echo ----2nd
				family=$(echo ${ltr_of26%|*(no rank)} | sed -e 's/^.*(order)|//' -e 's/^.*(no rank)|//' -e 's/|.*//')

				#open leaf-to-root files from STEP3, for each get predicted_taxid, and the level specified by $1
				# ONLY read the STEP3 leaf-to-root file of the gi being processed!!!!!!!!!!!!!!!!!!!
				tax_level_count=0
				FP_count=0
				while read pti_ltr;do
#					echo ------3rd
					pti_ltr_taxid=$(echo $pti_ltr | cut -f1 -d$' ')
					pti_ltr_family=$(echo ${ltr_of26%|*(no rank)} | sed -e 's/^.*(order)|//' -e 's/^.*(no rank)|//' -e 's/|.*//')
					if [ "$family" = "$pti_ltr_family" ]
						then
#						echo '--------4th: '$pti_ltr_lowest
						#open counts files from STEP4; for each true_gi, assign counts for each pred_ti
						#of the gi being processed!!!!!!!!)
						while read counts_line;do
							counts_pgi=$(echo $counts_line | cut -f2 -d$',')
							counts_taxid=$(echo $counts_line | cut -f3 -d$',')
							counts_count=$(echo $counts_line | cut -f4 -d$',')
							if [ "$counts_taxid" = "$pti_ltr_taxid" ]
								then
								tax_level_count=$(bc -l <<< "$tax_level_count+$counts_count")
#								echo '----------5th:'
#								echo "$processing_gi	$counts_pgi	$counts_count	$counts_taxid	$pti_ltr_species"
							fi
						done < "$path/STEP4/tgi_counts_"$2"/$processing_gi.counts.csv"
					else
						while read counts_line;do
							counts_pgi=$(echo $counts_line | cut -f2 -d$',')
							counts_taxid=$(echo $counts_line | cut -f3 -d$',')
							counts_count=$(echo $counts_line | cut -f4 -d$',')
							if [ "$counts_taxid" = "$pti_ltr_taxid" ]
								then
								FP_count=$(bc -l <<< "$FP_count+$counts_count")
#								echo '----------5th:'
							fi
						done < "$path/STEP4/tgi_counts_"$2"/$processing_gi.counts.csv"
					fi
				done < "$path/STEP3/uniq_leaftoRoot_"$2"/$processing_gi.uniq.pti-ltr"
			P=$(bc -l <<< "$tax_level_count+$FP_count")
			FN_count=$(bc -l <<< "1000-$P")
			echo "$processing_gi,$processing_ti,$tax_level_count,$FP_count,$FN_count"
			#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#
			#GENUS LEVEL
			elif [ "$1" = "genus" ]
				then
#				echo ----2nd
				genus=$(echo $ltr_of26 | sed -e 's/^.*(family)|//' -e 's/^.*(subfamily)|//' -e 's/|.*//')

				#open leaf-to-root files from STEP3, for each get predicted_taxid, and the level specified by $1
				# ONLY read the STEP3 leaf-to-root file of the gi being processed!!!!!!!!!!!!!!!!!!!
				tax_level_count=0
				FP_count=0
				while read pti_ltr;do
#					echo ------3rd
					pti_ltr_taxid=$(echo $pti_ltr | cut -f1 -d$' ')
					pti_ltr_genus=$(echo $ltr_of26 | sed -e 's/^.*(family)|//' -e 's/^.*(subfamily)|//' -e 's/|.*//')
					if [ "$genus" = "$pti_ltr_genus" ]
						then
#						echo '--------4th: '$pti_ltr_lowest
						#open counts files from STEP4; for each true_gi, assign counts for each pred_ti
						#of the gi being processed!!!!!!!!)
						while read counts_line;do
							counts_pgi=$(echo $counts_line | cut -f2 -d$',')
							counts_taxid=$(echo $counts_line | cut -f3 -d$',')
							counts_count=$(echo $counts_line | cut -f4 -d$',')
							if [ "$counts_taxid" = "$pti_ltr_taxid" ]
								then
								tax_level_count=$(bc -l <<< "$tax_level_count+$counts_count")
#								echo '----------5th:'
#								echo "$processing_gi	$counts_pgi	$counts_count	$counts_taxid	$pti_ltr_species"
							fi
						done < "$path/STEP4/tgi_counts_"$2"/$processing_gi.counts.csv"
					else
						while read counts_line;do
							counts_pgi=$(echo $counts_line | cut -f2 -d$',')
							counts_taxid=$(echo $counts_line | cut -f3 -d$',')
							counts_count=$(echo $counts_line | cut -f4 -d$',')
							if [ "$counts_taxid" = "$pti_ltr_taxid" ]
								then
								FP_count=$(bc -l <<< "$FP_count+$counts_count")
#								echo '----------5th:'
							fi
						done < "$path/STEP4/tgi_counts_"$2"/$processing_gi.counts.csv"
					fi
				done < "$path/STEP3/uniq_leaftoRoot_"$2"/$processing_gi.uniq.pti-ltr"
			P=$(bc -l <<< "$tax_level_count+$FP_count")
			FN_count=$(bc -l <<< "1000-$P")
			echo "$processing_gi,$processing_ti,$tax_level_count,$FP_count,$FN_count"
			#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#
			#SPECIES LEVEL
			elif [ "$1" = "species" ]
				then
#				echo ----2nd
				species=$(echo $ltr_of26 | sed -e 's/^.*(genus)|//' -e 's/^.*(species group)*|//' -e 's/|.*//')

				#open leaf-to-root files from STEP3, for each get predicted_taxid, and the level specified by $1
				# ONLY read the STEP3 leaf-to-root file of the gi being processed!!!!!!!!!!!!!!!!!!!
				tax_level_count=0
				FP_count=0
				while read pti_ltr;do
#					echo ------3rd
					pti_ltr_taxid=$(echo $pti_ltr | cut -f1 -d$' ')
					pti_ltr_species=$(echo $pti_ltr | sed -e 's/^.*(genus)|//' -e 's/^.*(species group)*|//' -e 's/|.*//')
					if [ "$species" = "$pti_ltr_species" ]
						then
#						echo '--------4th: '$pti_ltr_lowest
						#open counts files from STEP4; for each true_gi, assign counts for each pred_ti
						#of the gi being processed!!!!!!!!)
						while read counts_line;do
							counts_pgi=$(echo $counts_line | cut -f2 -d$',')
							counts_taxid=$(echo $counts_line | cut -f3 -d$',')
							counts_count=$(echo $counts_line | cut -f4 -d$',')
							if [ "$counts_taxid" = "$pti_ltr_taxid" ]
								then
								tax_level_count=$(bc -l <<< "$tax_level_count+$counts_count")
#								echo '----------5th:'
#								echo "$processing_gi	$counts_pgi	$counts_count	$counts_taxid	$pti_ltr_species"
							fi
						done < "$path/STEP4/tgi_counts_"$2"/$processing_gi.counts.csv"
					else
						while read counts_line;do
							counts_pgi=$(echo $counts_line | cut -f2 -d$',')
							counts_taxid=$(echo $counts_line | cut -f3 -d$',')
							counts_count=$(echo $counts_line | cut -f4 -d$',')
							if [ "$counts_taxid" = "$pti_ltr_taxid" ]
								then
								FP_count=$(bc -l <<< "$FP_count+$counts_count")
#								echo '----------5th:'
							fi
						done < "$path/STEP4/tgi_counts_"$2"/$processing_gi.counts.csv"
					fi
				done < "$path/STEP3/uniq_leaftoRoot_"$2"/$processing_gi.uniq.pti-ltr"
			P=$(bc -l <<< "$tax_level_count+$FP_count")
			FN_count=$(bc -l <<< "1000-$P")
			echo "$processing_gi,$processing_ti,$tax_level_count,$FP_count,$FN_count"
			#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#
			#LOWEST LEVEL
			elif [ "$1" = "lowest" ]
				then
#				echo ----2nd
				lowest=$(echo ${ltr_of26##*|})

				#open leaf-to-root files from STEP3, for each get predicted_taxid, and the level specified by $1
				# ONLY read the STEP3 leaf-to-root file of the gi being processed!!!!!!!!!!!!!!!!!!!
				tax_level_count=0
				FP_count=0
				while read pti_ltr;do
#					echo ------3rd
					pti_ltr_taxid=$(echo $pti_ltr | cut -f1 -d$' ')
					pti_ltr_lowest=$(echo ${pti_ltr##*|})
					if [ "$lowest" = "$pti_ltr_lowest" ]
						then
#						echo '--------4th: '$pti_ltr_lowest
						#open counts files from STEP4; for each true_gi, assign counts for each pred_ti
						#of the gi being processed!!!!!!!!)
						while read counts_line;do
							counts_pgi=$(echo $counts_line | cut -f2 -d$',')
							counts_taxid=$(echo $counts_line | cut -f3 -d$',')
							counts_count=$(echo $counts_line | cut -f4 -d$',')
							if [ "$counts_taxid" = "$pti_ltr_taxid" ]
								then
								tax_level_count=$(bc -l <<< "$tax_level_count+$counts_count")
#								echo '----------5th:'
							fi
						done < "$path/STEP4/tgi_counts_"$2"/$processing_gi.counts.csv"
					else
						while read counts_line;do
							counts_pgi=$(echo $counts_line | cut -f2 -d$',')
							counts_taxid=$(echo $counts_line | cut -f3 -d$',')
							counts_count=$(echo $counts_line | cut -f4 -d$',')
							if [ "$counts_taxid" = "$pti_ltr_taxid" ]
								then
								FP_count=$(bc -l <<< "$FP_count+$counts_count")
#								echo '----------5th:'
							fi
						done < "$path/STEP4/tgi_counts_"$2"/$processing_gi.counts.csv"
					fi
				done < "$path/STEP3/uniq_leaftoRoot_"$2"/$processing_gi.uniq.pti-ltr"
			P=$(bc -l <<< "$tax_level_count+$FP_count")
			FN_count=$(bc -l <<< "1000-$P")
			echo "$processing_gi,$processing_ti,$tax_level_count,$FP_count,$FN_count"
			#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#
			fi
		fi
	done < "$path/STEP5/taxID_26.ltr"
done < "$path/STEP1/gi_taxid_pairs.tsv"




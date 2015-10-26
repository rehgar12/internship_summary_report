#PBS -N countstoTaxIDs_MiSeq
#PBS -m ae
#PBS -M playera1@jhuapl.edu
#PBS -l nodes=1:ppn=4
#PBS -l walltime=240:00:00
#PBS -j oe
#PBS -o /home/playera1/sandbox/classifier_comparison2/higher_tax_STATS/BLASTN/STEP4/qsub_countstoTaxIDs_MiSeq.log
export PATH=/data/apps/bin/surpi/:/data/apps/bin/:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

path="/home/playera1/sandbox/classifier_comparison2/higher_tax_STATS/BLASTN"



#counter=0
while read tsv_lines;do
#	counter=$(bc -l <<< "$counter+1")
#	echo -------------------------------1st - $counter
	count=$(echo $tsv_lines | cut -f1 -d$' ')
	true_gi=$(echo $tsv_lines | cut -f2 -d$' ')
	pred_gi=$(echo $tsv_lines | cut -f3 -d$' ')
	#use gi_pair_count_*_.breakout/files* from STEP1 to get tgi, pgi, pti triplets to match with counts
	find "$path/STEP1fix/triplet_MiSeq" -name "*triplet.tsv" | while read pti_filepath;do
#		echo -------------------------------2nd
#		echo $pti_filepath
		#read each of the triplet containing files and assign each column of each line to appropriate variable
		while read pti_lines;do
#			echo -------------------------------3rd
			tgi=$(echo $pti_lines | cut -f1 -d$' ')
			pgi=$(echo $pti_lines | cut -f2 -d$' ')
			pti=$(echo $pti_lines | cut -f3 -d$' ')
#			echo $true_gi, $tgi, $pred_gi, $pgi, $pti
			#if the true_GI matches tgi AND the predicted_gi matches tgi, report the count of that condition
			if [ "$true_gi" = "$tgi" ] && [ "$pred_gi" = "$pgi" ] 
				then
#				echo -------------------------------4th
				mkdir -p "$path/STEP4/tgi_counts_MiSeq"
				echo $tgi,$pgi,$pti,$count >> "$path/STEP4/tgi_counts_MiSeq/$tgi.counts.csv"
			fi
		done < $pti_filepath
	done
done < "$path/STEP1/gi_pair_count_MiSeq.tsv"



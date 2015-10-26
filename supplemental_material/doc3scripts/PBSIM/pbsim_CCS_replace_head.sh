#!/bin/bash
#	replace headers generated by PBsim to corresponding GI number for each
#	Circular Concensus Read/Sequence (CCS) simulated fastq
#USAGE
#bash pbsim_replace_head.sh <NC_gi_list.tsv>
#
#	input file <NC_gi_list.tsv> is a tab separated list, each line containing
#	the NC_accession_number and associated gi (of reference genome used to 
#	generate the simulated reads.


out_dir="CCS/processed_headers"
mkdir -p $out_dir

for fastq in CCS/*;do


echo $fastq > readfile_tmp.txt
base=$(basename "$fastq")
echo $base > base_tmp.txt
cut -d'.' -f2 base_tmp.txt > access_tmp.txt

while read accession;do
while read gi;do

echo $gi > NC_gi_tmp.txt
a1=$(cut -d$' ' -f1 NC_gi_tmp.txt)
g1=$(cut -d$' ' -f2 NC_gi_tmp.txt)
#echo $a1,$g1
if [ $accession == $a1 ]
then
echo $g1
echo $accession
sed -e "s/^@S1_/@gi|$g1|ref|$a1|/g" $fastq|sed -e "s/^\+S1_.\+/+/g" > "$out_dir/$base.replaced"


fi

done < $1
done < access_tmp.txt




#cat $fastq | sed -e "s/^@/$gi/g" | sed -e "s/^+/$gi/g"

done











rm *_tmp.txt
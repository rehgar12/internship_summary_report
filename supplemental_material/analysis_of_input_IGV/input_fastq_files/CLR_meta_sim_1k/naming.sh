#!/bin/bash


find "./" -name "patho_input*" | while read fname;do

gi=$(head -1 $fname | sed -e 's/@gi|//' -e 's/|ref|.*//')
echo $gi
gi_count=$(grep -P "$gi" $fname | wc -l)


if [ $gi_count = 1000 ]
then
#echo $gi_count
mv $fname "patho_input_$gi.fq"
fi

#mv $fname patho_input

done

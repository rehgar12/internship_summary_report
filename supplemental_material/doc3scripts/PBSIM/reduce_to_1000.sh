#!/bin/bash



for file in 0001/*;do

base=$(basename "$file")
head -4000 $file > "head0001/$base.head"

#echo "head0001/$base"

done

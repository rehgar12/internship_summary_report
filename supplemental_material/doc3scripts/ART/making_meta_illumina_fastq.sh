#!/bin/bash


for f in sim_raw_reads/*.fq;do
echo 'processing '$f


#base=$(basename "${f}")
#echo $base


head -4000 $f >> MiSeq_meta_sim.fq

echo --------



done

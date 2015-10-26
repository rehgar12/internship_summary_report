#!/bin/bash


for f in CLR/processed_headers/*.replaced;do
echo 'processing '$f

cat $f >> PacBio_CLR_meta_sim.fq

echo --------
done


for f in CCS/processed_headers/*.replaced;do
echo 'processing '$f

cat $f >> PacBio_CCS_meta_sim.fq

echo --------
done

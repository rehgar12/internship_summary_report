#PBS -N kraken_comp_db-build_addinglibraries
#PBS -m ae
#PBS -M playera1@jhuapl.edu
#PBS -l nodes=1:ppn=16
#PBS -l walltime=24:00:00
#PBS -j oe
#PBS -o /home/playera1/sandbox/classifier_comparison/kraken/kraken_comp_db-build_addinglibraries.log

export PATH=/data/apps/bin/surpi/:/data/apps/bin/:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

comp_dir="/home/playera1/sandbox/classifier_comparison"
kraken_dir="/home/playera1/sandbox/classifier_comparison/kraken"


find "$comp_dir/database_build_ref_files/" -name "*.fna" -print0 | while read -d $'\0' fna; do

	echo $fna
#	base=$(basename "${fna%.fna}")
#	echo $base

	kraken-build --add-to-library $fna --db "$kraken_dir/kraken_db-for_comp"


done

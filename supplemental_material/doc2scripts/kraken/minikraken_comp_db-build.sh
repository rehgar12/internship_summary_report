#PBS -N minikraken_comp_db-build
#PBS -m ae
#PBS -M playera1@jhuapl.edu
#PBS -l nodes=1:ppn=16
#PBS -l walltime=24:00:00
#PBS -j oe
#PBS -o /home/playera1/sandbox/classifier_comparison/kraken/minikraken_comp_db-build.log
export PATH=/data/apps/bin/surpi/:/data/apps/bin/:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin


comp_dir="/home/playera1/sandbox/classifier_comparison/kraken"


qstat -u playera1 -n
/usr/bin/time -f "%M max RSS, %E walltime, %S cpu sec (kernel mode), %U cpu sec (user mode), %P cpu (S+U)/E, %t RSS in Kb" \
kraken-build \
	--shrink 10000 \
	--shrink-block-offset 1 \
	--db "$comp_dir/kraken_db-for_comp" \
	--new-db "$comp_dir/minikraken_db-for_comp" \
	--threads 32

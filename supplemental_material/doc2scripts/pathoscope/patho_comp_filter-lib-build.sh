#PBS -N patho_comp_filter-lib-build
#PBS -m ae
#PBS -M playera1@jhuapl.edu
#PBS -l nodes=1:ppn=16
#PBS -l walltime=240:00:00
#PBS -j oe
#PBS -o /home/playera1/sandbox/classifier_comparison/pathoscope/patho_comp_filter-lib-build.log
export PATH=/data/apps/bin/surpi/:/data/apps/bin/:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin


comp_dir="/home/playera1/sandbox/classifier_comparison"
target_fil_data="/home/playera1/sandbox/classifier_comparison/pathoscope/GRCh38.fa"

outpath="/home/playera1/sandbox/classifier_comparison/pathoscope/libraries"
mkdir -p "$outpath"

qstat -u playera1 -n
/usr/bin/time -f "%M max RSS, %E walltime, %S cpu sec (kernel mode), %U cpu sec (user mode), %P cpu (S+U)/E, %t RSS in Kb" \
pathoscope LIB -genomeFile $target_fil_data -outPrefix patho_comp_filter-lib-build


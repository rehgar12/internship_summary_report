#PBS -N fasta_cat_makeblastdb
#PBS -m ae
#PBS -M playera1@jhuapl.edu
#PBS -l nodes=1:ppn=16
#PBS -l walltime=24:00:00
#PBS -j oe
#PBS -o /home/playera1/sandbox/classifier_comparison/blastn/cat_fasta_file_for_db/fasta_cat_makeblastdb.log
export PATH=/data/apps/bin/surpi/:/data/apps/bin/:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

comp_dir="/home/playera1/sandbox/classifier_comparison"
findpath="/home/playera1/sandbox/classifier_comparison/database_build_ref_files"
outpath="/home/playera1/sandbox/classifier_comparison/blastn/cat_fasta_files_for_db"

db_outpath="/home/playera1/sandbox/classifier_comparison/blastn/database"
mkdir -p "$db_outpath"


find "$findpath/comp_Bacteria" -name "*.fna" -exec cat {} + >> "$outpath/all_Bacteria.fna"
find "$findpath/comp_Viruses" -name "*.fna" -exec cat {} + >> "$outpath/all_Viruses.fna"


cat $outpath/all_Bacteria.fna $outpath/all_Viruses.fna > $outpath/all_BV.fna


makeblastdb -in $outpath/all_BV.fna -dbtype 'nucl' -out "$db_outpath/BV_db"

#!/bin/bash

# This script takes a list of taxids, and a taxonomy path with names.dmp and nodes.dmp
# and creates a two-column file with taxid, and full taxonomic string
#      by: Thomas Mehoke
# written: July 14, 2015

export PATH=/data/apps/bin/surpi/:/data/apps/bin/:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

runtime=$(date +"%Y%m%d%H%M%S%N")

usage()
{
cat << EOF
usage: $0 -i <input> -t <taxonomy path> -o <output>


OPTIONS:
   -h      show this message
   -i      path to file containing a list of taxids, one per line
   -t      path to taxonomy folder containing names.dmp and nodes.dmp
   -o      file to place text output file (default: STDOUT)
   -d      threads to use for parallel processing
            The default is one less than the available processors.
            On this computer ($(hostname)) there are $(nproc) threads,
             so the default is $(($(nproc) - 1)).
   -w      working directory (default: /tmp)
EOF
}

# set default values
workdir="/tmp"
THREADS=$(($(nproc) - 1))
outputfile=""

# parse input arguments
while getopts "hi:t:o:d:w:" OPTION
do
	case $OPTION in
		h) usage; exit 1 ;;
		i) input=$OPTARG ;;
		t) taxpath=$OPTARG ;;
		o) outputfile=$OPTARG ;;
		d) THREADS=$OPTARG ;;
		w) workdir=$OPTARG ;;
		?) usage; exit ;;
	esac
done

# if necessary arguments are not present, display usage info and exit
if [[ -z "$input" ]]; then
	echo "Specify a taxid list with -i" >&2
	usage
	exit 2
fi
if [[ -z "$taxpath" ]]; then
	echo "Select a path to the taxonomy folder with -t" >&2
	usage
	exit 2
elif ! [[ -d "$taxpath" ]]; then
	echo "Error: taxonomy path \"$taxpath\" does not exist." >&2
	usage
	exit 2
elif ! [[ -s "$taxpath/names.dmp" ]]; then
	echo "Error: names file \"$taxpath/names.dmp\" does not." >&2
	usage
	exit 2
elif ! [[ -s "$taxpath/nodes.dmp" ]]; then
	echo "Error: nodes file \"$taxpath/nodes.dmp\" does not exist." >&2
	usage
	exit 2
fi

#===================================================================================================
# function declarations

make_tax_string() {

	# parse input arguments
	tax="$1"

	# pull time so temp files don't overwrite each other
	runtime_sub=$(date +"%Y%m%d%H%M%S%N")
	tempfile="$workdir/tax_string_temp-$runtime_sub"

	# pull out name and parent taxid for this taxon
	name=$(egrep "^$tax"$'\t' "$taxpath/names.dmp" | grep "scientific name" | cut -f3)
	level=$(egrep "^$tax"$'\t' "$taxpath/nodes.dmp" | cut -f5)
	parent=$(egrep "^$tax"$'\t' "$taxpath/nodes.dmp" | cut -f3)

	name="$name($level)"

	# deal with taxa near the root
	if [[ "$tax" -eq 0 ]]; then
		echo -e "$tax\tUnclassified"
	elif [[ "$parent" -eq 1 ]]; then
		if [[ "$ignore" == "true" ]]; then
			echo -e "$tax\t$name"
		elif [[ "$name" != "root(no rank)" ]]; then
			echo -e "$tax\troot(no rank)|$name"
		else
			echo -e "$tax\troot(no rank)"
		fi
	# for all others, create full taxonomic string
	else
		while [[ "$parent" -gt 1 ]]; do
			parentname=$(egrep "^$parent"$'\t' "$taxpath/names.dmp" | grep "scientific name" | cut -f3)
			parentlevel=$(egrep "^$parent"$'\t' "$taxpath/nodes.dmp" | cut -f5)
			name="$parentname($parentlevel)|$name"
			echo -e "$name" > "$tempfile"
			parent=$(egrep "^$parent"$'\t' "$taxpath/nodes.dmp" | cut -f3)
		done
		if [[ "$ignore" == "true" ]]; then
			echo -e "$tax\t$(cat "$tempfile")" && rm "$tempfile"
		else
			echo -e "$tax\troot(no rank)|$(cat "$tempfile")" && rm "$tempfile"
		fi
	fi
}

#===================================================================================================

OUTPUT="$workdir/output-$runtime"

# loop through all taxonomic levels
export taxpath
export workdir
export -f make_tax_string
parallel -a "$input" -d $'\n' -n 1 -P "$THREADS" -I '{}' make_tax_string '{}' >> "$OUTPUT"

# output to STDOUT
if [[ -z "$outputfile" ]]; then
	cat "$OUTPUT" && rm "$OUTPUT"
# or output to output file specified by -o argument
else
	mv "$OUTPUT" "$outputfile"
fi
#~~eof~~#

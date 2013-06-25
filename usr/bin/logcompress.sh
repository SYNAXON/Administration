#!/bin/bash
# Scriptname: logcompress.sh
# This script enables you to compress logfiles rotated with cronolog

# Sucht leere Verzeichnisse und loescht diese rekursiv
# find . -mindepth 1 -type d -empty -depth -print | xargs rmdir

# Variables ###################################################### #
CTIME=""
DTIME=""
DIR=""

# Functions ###################################################### #
usage()
{
cat << EOF
    usage: $0 options

    This script compress and delete logfiles rotated with cronolog.
    You could specyfiy which logs zu compress and which to keep.

    The following variables have to be specified.
    You can specify them by editing the script or use the following options.

    OPTIONS:
        -h Show this message
        -c ctime Time the file should be compressed.
		-d dtime Time the file should be deleted.
		-D Specify parentdir of the logfiles.
EOF
}

# Program ######################################################## #
while getopts .hc:d:D. OPTION
do
	case $OPTION in
		h)
			usage
			exit 1
			;;
		c)
			CTIME=$OPTARG
			;;
		d)
			DTIME=$OPTARG
			;;
		D)
			DIR=$OPTARG
			;;
		?)
			usage
			exit
			;;
	esac
done

if [[ -z $CTIME]] [[ -z $DTIME]] [[ -z $DIR]]; then
	usage
	exit 1
fi

# Check that the file isn't still open and work with it
for file in $(find $DIR -ctime +$DTIME -name '*.log')
do
	lsof | grep $file
	if [$? -eq 1 ]
	then
		rm $file
	fi
done

for file in $(find $DIR -ctime +$CTIME -name '*.log')
do
	lsof | grep $file
	if [$? -eq 1 ]
	then
		gzip $file
	fi
done

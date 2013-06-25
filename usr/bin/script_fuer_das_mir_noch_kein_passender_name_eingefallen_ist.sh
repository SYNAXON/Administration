#!/bin/bash
# Scriptname:
# Dieses Script dient zum Suchen und Loeschen alter Dateien und zum
# loeschen leerer Verzeichnishierarchien.

# Sucht leere Verzeichnisse und loescht diese rekursiv
# find . -mindepth 1 -type d -empty -depth -print | xargs rmdir

# Variables ###################################################### #
FTYPE=""
CTIME=""
DIR=""

# Functions ###################################################### #
usage()
{
cat << EOF
    usage: $0 options

    OPTIONS:
		-h Show this message
		-t <type> Specifies the filetype to search for.
		-c n File's  status  was  last changed n*24 hours ago.
		-d <path> Path to search for the specified file types.
EOF
}

# Program ######################################################## #
while getopts .ht:c:d:. OPTION
do
	case $OPTION in
		h)
			usage
			exit 1
			;;
		t)
			FTYPE=$OPTARG
			;;
		c)
			CTIME=$OPTARG
			;;
		d)
			DIR="${OPTARG}"
			;;
		?)
			usage
			exit
			;;
	esac
done

if [[ -z $CTIME ]] || [[ -z $FTYPE ]] || [[ -z $DIR ]]; then
	usage
	exit 1
fi

# Check that the file isn't still open and work with it
for file in $(find $DIR -ctime +$CTIME -name '*.$FTYPE')
do
	lsof | grep $file
	if [$? -eq 1 ]
	then
		rm $file
	fi
done

find $DIR -mindepth 1 -depth -type d -empty -print | xargs rmdir

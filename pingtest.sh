#!/bin/bash
# Version 1.0
# Mit diesem Script kann die Erreichbarkeit mehrerer HOSTs via ICMP geprueft werden.
# Die zu pruefenden Hostnamen werden zeilenweise aus einer Textdatei namens hosts.txt
# ausgelesen. Diese Textdatei sollte moeglichst die FQDNs der zu pruefenden HOSTs enthalten.

if [ -f "hosts.txt" ]
  then
    while read hosts
    do
	echo "==================================" >>log.txt
	date >>log.txt
#	echo $hosts >>log.txt
	ping -q -c 100 $hosts >>log.txt
	date >>log.txt
	echo "==================================" >>log.txt
    done < "hosts.txt"
  else
    echo "Datei hosts.txt wurde nicht gefunden."
fi

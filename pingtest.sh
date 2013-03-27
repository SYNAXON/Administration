#!/bin/bash
# Version 0.1
# Mit diesem Script kann die Erreichbarkeit mehrerer HOSTs via ICMP geprueft werden.
# Die zu pruefenden Hostnamen werden zeilenweise aus einer Textdatei namens hosts.txt
# ausgelesen. Diese Textdatei sollte moeglichst die FQDNs der zu pruefenden HOSTs enthalten.

if [ $1 == "hosts.txt" ]
  then
    while read hosts
    do
	echo $hosts
    done < $1
  else
    echo "Datei hosts.txt wurde nicht gefunden."
fi

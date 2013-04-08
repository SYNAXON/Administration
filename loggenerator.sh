#!/bin/bash
# This is a script to generate a lot of Logentries
# WARNING THIS SCRIPT DOES NOT STOP
# You have to kill it with kill -9 PID
Hostname="logstash.zentrale.de"
counter=1
while [ $counter != 0 ]
do
  logger "Eintrag Nr. $counter"
  counter=`expr $counter + 1`
done
exit 0

#!/bin/bash
# TARGET: Backup-Ziel
# IGNORE: Liste zu ignorierender Datenbanken (durch | getrennt)
# CONF: MySQL Config-Datei, welche die Zugangsdaten enthaelt
TARGET=/var/backups/mysql
IGNORE="mysql|information_schema|performance_schema|test"
CONF=/etc/mysql/debian.cnf
if [ ! -r $CONF ]; then /usr/bin/logger "$0 - auf $CONF konnte nicht zugegriffen werden"; exit 1; fi
if [ ! -d $TARGET ] || [ ! -w $TARGET ]; then /usr/bin/logger "$0 - Backup-Verzeichnis nicht beschreibbar"; exit 1; fi

DBS="$(/usr/bin/mysql --defaults-extra-file=$CONF -Bse 'show databases' | /bin/grep -Ev $IGNORE)"
NOW=$(date +"%Y-%m-%d")

for DB in $DBS; do
    /usr/bin/mysqldump --defaults-extra-file=$CONF --skip-extended-insert --skip-comments $DB > $TARGET/$DB.sql
done

for DB in $DBS; do
   /bin/gzip -f $TARGET/$DB.sql
done

/usr/bin/logger "$0 - Backup von $NOW erfolgreich durchgefuehrt"
exit 0

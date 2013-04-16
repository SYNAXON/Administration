#!/bin/bash
# Script to run DocusnapScript on a DMZ Host
# This script run the following tasks.
# 1. Conntect to FTP-Server
# 2. Get DSLinux_x*-File from FTP-Server
# 3. Run DSLinux_x* on current Host
# 4. Put XML File on FTP-Server
# 5. Local cleanup

# Variablen ############################################################### #
FTP_HOST=""
FTP_USER=""
FTP_PASS=""
DS_FILE="DSLinux_x64"
LOCAL_DIR="/tmp/docusnap"	# Example: /tmp/docusnap

# Programmstart
mkdir -p $LOCAL_DIR
chmod -R 777 $LOCAL_DIR
cd $LOCAL_DIR

ftp -n $FTP_HOST > /tmp/docusnap/ftp.worked 2> /tmp/docusnap/ftp.failed <<END_SCRIPT
quote USER $FTP_USER
quote PASS $FTP_PASS
binary
get $DS_FILE
bye
END_SCRIPT

chmod 555 $DS_FILE
touch $LOCAL_DIR/$HOSTNAME.xml
chmod 766 $HOSTNAME.xml
sudo $LOCAL_DIR/$DS_FILE >$LOCAL_DIR/$HOSTNAME.xml

ftp -n $FTP_HOST > /tmp/docusnap/ftp.worked 2> /tmp/docusnap/ftp.failed <<END_SCRIPT
quote USER $FTP_USER
quote PASS $FTP_PASS
binary
put $HOSTNAME.xml
bye
END_SCRIPT

rm -rf $LOCAL_DIR
exit 0

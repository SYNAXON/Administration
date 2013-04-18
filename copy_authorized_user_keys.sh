#!/bin/bash
# Scriptname: copy_authorized_keys
# This script download the authorized_keys with SSH-Public-Keys
# from a FTP-Server and copies the file to ~/.ssh of the current user

# Variablen ############################################################### #
FTP_HOST=""
FTP_USER=""
FTP_PASS=""
DS_FILE="authorized_user_keys"
LOCAL_DIR="/home/$USER/.ssh"

# Programmstart
mkdir -p $LOCAL_DIR
cd $LOCAL_DIR

ftp -n $FTP_HOST <<END_SCRIPT
quote USER $FTP_USER
quote PASS $FTP_PASS
binary
get $DS_FILE
bye
END_SCRIPT
exit 0

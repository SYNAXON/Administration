#!/bin/bash
# Scriptname: copy_authorized_keys
# This script download the authorized_keys with SSH-Public-Keys
# from a FTP-Server and copies the file to ~/.ssh of the current user

# Variablen ############################################################### #
FTP_HOST=""
FTP_USER=""
FTP_PASS=""
DS_FILE="authorized_user_keys"
USER=`whoami`
LOCAL_DIR=$HOME/.ssh

# Functions ############################################################### #

usage()
{
cat << EOF
    usage: $0 options

    This script download the authorized_user_keys file from a FTP-Server and
    copies the file to ~/.ssh of the current user.

    The following variables have to be specified in the script.
        FTP_HOST
        FTP_USER
        FTP_PASS

    You can specify them by editing the script or use the following options.

    OPTIONS:
        -h Show this message
        -H ftp host name
        -u ftp user name
        -p password for the ftp user
EOF
}

# Programmstart
while getopts .hH:u:p:. OPTION
do
    case $OPTION in
         h)
             usage
             exit 1
             ;;
         H)
             FTP_HOST=$OPTARG
             ;;
         u)
             FTP_USER=$OPTARG
             ;;
         p)
             FTP_PASS=$OPTARG
             ;;
         ?)
             usage
             exit
             ;;
     esac
done

if [[ -z $FTP_HOST ]] || [[ -z $FTP_USER ]] || [[ -z $FTP_PASS ]]; then
    usage
    exit 1
fi

if [[ $USER == 'root' ]]; then
	LOCAL_DIR="/root/.ssh"
fi

START_DIR=`pwd`
mkdir -p $LOCAL_DIR
cd $LOCAL_DIR

ftp -n $FTP_HOST <<END_SCRIPT
quote USER $FTP_USER
quote PASS $FTP_PASS
binary
get $DS_FILE
bye
END_SCRIPT

cd $START_DIR
exit 0

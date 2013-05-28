#!/bin/bash
# Script to run DocusnapScript on a DMZ Host
# This script run the following tasks.
# 1. Conntect to FTP-Server
# 2. Get DSLinux_x*-File from FTP-Server
# 3. Run DSLinux_x* on current Host
# 4. Put XML File on FTP-Server
# 5. Local cleanup
# You have to run this script as root or with sudo

# Variablen ############################################################### #
FTP_HOST=""
FTP_USER=""
FTP_PASS=""
REMOTE_DIR="docusnap_xml_files"
DS_FILE="DSLinux_x64"
LOCAL_DIR="/tmp/docusnap"	# Example: /tmp/docusnap

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

while getopts .hH:u:p:. OPTION
do
    case $OPTION in
        h)
            usage
            exit;;
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
    exit
fi

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
$LOCAL_DIR/$DS_FILE >$LOCAL_DIR/$HOSTNAME.xml

ftp -n $FTP_HOST > /tmp/docusnap/ftp.worked 2> /tmp/docusnap/ftp.failed <<END_SCRIPT
quote USER $FTP_USER
quote PASS $FTP_PASS
binary
cd $REMOTE_DIR
put $HOSTNAME.xml
bye
END_SCRIPT

rm -rf $LOCAL_DIR
exit 0

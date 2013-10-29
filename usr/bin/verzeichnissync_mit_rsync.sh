#!/bin/bash
# Scriptname: copy_authorized_keys
# This script download the authorized_keys with SSH-Public-Keys
# from a FTP-Server and copies the file to ~/.ssh of the current user

# Variablen ############################################################### #
REMOTE_HOST=""
REMOTE_USER=""
REMOTE_DIR=""
LOCAL_DIR=""

# Functions ############################################################### #

usage()
{
cat << EOF
    usage: $0 options

    This script syncs two directories between
    a local host and a remote host.

    The following variables have to be specified in the script.
        REMOTE_HOST
        REMOTE_USER
	REMOTE_DIR
	LOCAL_DIR

    You can specify them by editing the script or use the following options.

    OPTIONS:
        -h Show this message
        -H remote host name
        -s path with the ssh private key file
        -u username for the remote user
	-l local directory
	-r remote directory
EOF
}

# Programmstart
while getopts .hl:u:H:r:. OPTION
do
    case $OPTION in
         h)
             usage
             exit 1
             ;;
         H)
             REMOTE_HOST="${OPTARG}"
             ;;
         s)
             SSH_KEY="${OPTARG}"
             ;;
         l)
             LOCAL_DIR="${OPTARG}"
             ;;
         u)
             REMOTE_USER="${OPTARG}"
             ;;
         r)
             REMOTE_DIR="${OPTARG}"
             ;;
         ?)
             usage
             exit
             ;;
     esac
done

if [[ -z $REMOTE_HOST ]] || [[ -z $LOCAL_DIR ]] || [[ -z $REMOTE_USER ]] || [[ -z $REMOTE_DIR ]]; then
    usage
    exit 1
fi

rsync -az $LOCAL_DIR $REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR
exit 0

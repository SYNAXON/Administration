#!/bin/bash

########## Variables

start=`pwd`
current="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
olddir=~/dotfiles_old             # old dotfiles backup directory
dirToLink="profile"
##########

if [ ! -d $olddir ]; then
	mkdir -p $olddir
fi

for dir in $dirToLink; do
	cd $current/$dir
	for file in *; do
    		echo "Moving .$file from ~ to $olddir"
    		mv ~/.$file $olddir 
    		echo "Creating symlink to .$file in home directory."
    		ln -s $current/$dir/$file ~/.$file
	done
done

cd $start

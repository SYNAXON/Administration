#!/bin/bash

########## Variables

start=`pwd`
current="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
olddir=~/dotfiles_old             # old dotfiles backup directory
dirToLink="profile"
##########

######### create backup dir        ########
if [ ! -d $olddir ]; then
	mkdir -p $olddir
fi

######## backup existing vim files ########
if [ -d ~/.vim ]; then
    echo "Backup old vim folders"
    mv ~/.vim $olddir
fi

######## install new vim files     ########
echo "Create vim config files"
ln -s $current/vim ~/.vim

######## backup old bin files      ########
if [ -d ~/usr ]; then
    echo "Backup old local usr folder"
    mv ~/usr $olddir
fi

######## create local usr/bin folder ######
echo "Create local bin directory"
ln -s $current/usr ~/usr

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

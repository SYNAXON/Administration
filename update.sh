#!/bin/bash

CURDIR="$(pwd)"
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd $DIR

git pull --all > /dev/null 2>&1
git checkout master > /dev/null 2>&1

cd $CURDIR

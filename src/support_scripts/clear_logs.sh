#!/bin/bash

# Truncate Log Files 
#
#		Author	: Viki (a) Vignesh Natarajan 
#		Contact	: vikilabs.org
#		Licence : MIT

if [ -z "$1" ]; then
    echo "error line (  ${LINENO} ) : destination folder name missing"
    exit 1
fi

#switch to destination directory
DST_DIR=$1
mkdir -p $DST_DIR 2> /dev/null 1> /dev/null
cd $DST_DIR
[[ $? -ne 0 ]]; echo "error line (  ${LINENO} )"; exit 1



#Truncate All Log Files 
find . -name "*.log"|while read fname; do
  echo "" > "$fname"
done

echo "( status ) all log files are truncated"

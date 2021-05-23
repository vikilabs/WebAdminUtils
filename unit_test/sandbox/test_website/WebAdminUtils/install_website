#!/bin/bash

# Install website from source
#
#		Author	: Viki (a) Vignesh Natarajan 
#		Contact	: vikilabs.org
#		Licence : MIT

CURRENT_DIR=`pwd`

######################### GET CURRENT TIME STAMP #############
DAY=$(date '+%d')
MONTH=$(date '+%m')
YEAR=$(date '+%Y')
HOUR=$(date '+%H')
MINUTE=$(date '+%M')
TIME_STAMP="D${DAY}${MONTH}${YEAR}_T${HOUR}${MINUTE}"

######################## IMPORT CONFIGURATION ################
source config.sh
[ $? -ne 0 ] && { echo "[ $TIME_STAMP ] [ ERROR ] [ ${LINENO} ] " >> $LOG_FILE; exit 1; }



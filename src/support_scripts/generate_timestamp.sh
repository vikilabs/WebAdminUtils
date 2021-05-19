#!/bin/bash

# Generate Current Timestamp
#
#		Author	: Viki (a) Vignesh Natarajan 
#		Contact	: vikilabs.org
#		Licence : MIT

DAY=$(date '+%d')
MONTH=$(date '+%m')
YEAR=$(date '+%Y')
HOUR=$(date '+%H')
MINUTE=$(date '+%M')
TIME_STAMP="D${DAY}${MONTH}${YEAR}_T${HOUR}${MINUTE}"

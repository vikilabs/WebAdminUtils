#!/bin/bash

# migrate a website from one domain to another domain from backup
#
#		Author	: Viki (a) Vignesh Natarajan 
#		Contact	: vikilabs.org
#		Licence : MIT



source config.sh
[ $? -ne 0 ] && { echo "[ ERROR ] [ ${LINENO} ]"; exit 1 }

./restore.sh
[ $? -ne 0 ] && { echo "[ ERROR ] [ ${LINENO} ]"; exit 1 }


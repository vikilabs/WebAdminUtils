#!/bin/bash

# Restore a website from backup
#
#		Author	: Viki (a) Vignesh Natarajan 
#		Contact	: vikilabs.org
#		Licence : MIT


if [ -z "$1" ]; then
    echo "[ ERROR ] backup file name missing "
    echo
    echo "[ EXAMPLE ] ./restore.sh backup.tar.gz"
    echo
    exit 1
fi

echo
INPUT=$1
BACKUP_FILE=`basename $INPUT`
BACKUP_DIR=`dirname $INPUT`

STRIP_EXTN1="${BACKUP_FILE%.*}"
EXTN1="${BACKUP_FILE##*.}"

STRIP_EXTN2="${STRIP_EXTN1%.*}"
EXTN2="${STRIP_EXTN1##*.}"

RESTORE_DIR=$STRIP_EXTN2

#echo " EXTENSION 1          : " $EXTN1
#echo " EXTENSION 2          : " $EXTN2
#echo " EXTENSION 1 STRIPPED : " $STRIP_EXTN1
#echo " EXTENSION 2 STRIPPED : " $STRIP_EXTN2
#echo " RESTORE DIR          : " $RESTORE_DIR


if [ "$EXTN1" != "gz" ]; then
    echo "[ ERROR ] invalid backup file name ( file name should end with .tar.gz ) "
    echo
    exit 1
fi

if [ "$EXTN2" != "tar" ]; then
    echo "[ ERROR ] invalid backup file name ( file name should end with .tar.gz ) "
    echo
    exit 1
fi

while true; do
read -p "  Do you wish to restore this website from backup ( YES / NO )?  " user_input
echo
case $user_input in
[YES]* ) echo "  YES : Restore Initiated"; break;;
* ) echo "  NO ( DEFAULT )  : Aborting Restore Operation";echo;exit;;
esac
done
echo

# Enter backup directory
cd $BACKUP_DIR

# Remove Old Restore Folder ( if any )
rm -rf $RESTORE_DIR

# Extract backup archive
tar -zxvf $BACKUP_FILE
[ $? -ne 0 ] && { echo "[ ERROR ] [ ${LINENO} ]"; exit 1; }

#import config
source ${RESTORE_DIR}/restore_config.sh
[ $? -ne 0 ] && { echo "[ ERROR ] [ ${LINENO} ]"; exit 1; }

########### Restore Config Details ##################

echo
echo "  Website Root      : $WEBSITE_ROOT_DIR"
echo "  DB NAME           : $DB_NAME"
echo "  DB USER           : $DB_USERNAME"
echo "  DB PASSWORD       : $DB_PASSWORD"
echo "  DB HOST       	  : $DB_HOST"
echo "  DB PORT       	  : $DB_PORT"
echo 


########### Check if database is empty ##############
table_count=$(mysql -u$NEW_DB_USERNAME -p$NEW_DB_PASSWORD -h $NEW_DB_HOST -P $NEW_DB_PORT $NEW_DB_NAME -e "SHOW TABLES;" | wc -l)


if [ $table_count -gt 0 ];then
        echo "[ ERROR ] [ ${LINENO} ] DB is not empty ( table_count : $table_count ), truncate database before restoring"
	exit 1
fi

# import database 
mysqldump -u$DB_USERNAME  -p$DB_PASSWORD $DB_NAME < "${RESTORE_DIR}/db/database.sql"
[ $? -ne 0 ] && { echo "[ ERROR ] [ ${LINENO} ] Database Import Failed"; exit 1; }

# mv backup code to website root 
mv "${RESTORE_DIR}/code/*" "${WEBSITE_ROOT_DIR}/"
[ $? -ne 0 ] && { echo "[ ERROR ] [ ${LINENO} ] Website copy failed"; exit 1; }

#
echo "[ SUCCESS ] website restored ( $DOMAIN )"

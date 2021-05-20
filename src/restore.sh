#!/bin/bash

# restore a website from from backup
#
#		Author	: Viki (a) Vignesh Natarajan 
#		Contact	: vikilabs.org
#		Licence : MIT


INPUT=$1

function get_current_dir()
{
    CURRENT_DIR=`pwd -P`
}

function arg_check()
{
    if [ -z "$INPUT" ]; then
        echo "[ ERROR ] backup file name missing "
        echo
        echo "[ EXAMPLE ] ./restore.sh backup.tar.gz"
        echo
        exit 1
    fi
}

function db_empty_check()
{
    table_count=$(mysql -u$DB_USERNAME -p$DB_PASSWORD -h $DB_HOST -P $DB_PORT $DB_NAME -e "SHOW TABLES;" | wc -l)

    if [ $table_count -gt 0 ];then
        echo "[ ERROR ] [ ${LINENO} ] DB is not empty ( table_count : $table_count ), truncate database before restore"
        exit 1
    fi
}

function dir_empty_check()
{
    file_count=`ls ${WEBSITE_ROOT_DIR}/ | wc -l`
    if [ $file_count -gt 0 ];then
        echo "[ ERROR ] [ ${LINENO} ] website root directory is not empty, clear all files before restoring"
        exit 1
    fi
}

function validate_input()
{

    echo
    SOURCE_FILE=`basename $INPUT`
    SOURCE_PATH=`dirname $INPUT`

    # GET ABSOLUTE PATH 
    cd $SOURCE_PATH
    [ $? -ne 0 ] && { echo "[ ERROR ] [ ${LINENO} ]"; exit 1; }
    SOURCE_PATH=`pwd -P`

    cd $SOURCE_PATH
    [ $? -ne 0 ] && { echo "[ ERROR ] [ ${LINENO} ]"; exit 1; }

    # EXTRACT FILENAME AND PATH FROM INPUT 

    STRIP_EXTN1="${SOURCE_FILE%.*}"
    EXTN1="${SOURCE_FILE##*.}"

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
}

function get_user_confirmation()
{

    while true; do
        read -p "  Do you wish to restore this website from backup ( YES / NO )?  " user_input
        echo
        case $user_input in
            [YES]* ) echo "  YES : Restore Initiated"; break;;
            * ) echo "  NO ( DEFAULT )  : Aborting Restore Operation";echo;exit;;
        esac
    done
    echo

}

function extract_backup_archive()
{
    # Enter backup directory
    cd $SOURCE_PATH
    [ $? -ne 0 ] && { echo "[ ERROR ] [ ${LINENO} ]"; exit 1; }

    # Remove Old Restore Folder ( if any )
    rm -rf $RESTORE_DIR

    # Extract backup archive
    tar -zxvf $SOURCE_FILE
    [ $? -ne 0 ] && { echo "[ ERROR ] [ ${LINENO} ]"; exit 1; }
}

#Old Configuration
function import_config()
{
    source $SOURCE_PATH/$RESTORE_DIR/restore_config.sh
    [ $? -ne 0 ] && { echo "[ ERROR ] [ ${LINENO} ]"; exit 1; }

}

function print_config()
{
    echo
    echo "PREVIOUS SERVER CONFIGURATION"
    echo
    echo "  DOMAIN      	  : $DOMAIN"
    echo "  Website Root      : $WEBSITE_ROOT_DIR"
    echo "  DB NAME           : $DB_NAME"
    echo "  DB USER           : $DB_USERNAME"
    echo "  DB PASSWORD       : $DB_PASSWORD"
    echo "  DB HOST       	  : $DB_HOST"
    echo "  DB PORT       	  : $DB_PORT"
    echo 
    echo
    echo " Note: Make sure your existing config is same as above. If not try ( ./migrate.sh $INPUT )"
    echo

}

function get_abs_path_website_root()
{
    cd $WEBSITE_ROOT_DIR
    [ $? -ne 0 ] && { echo "[ ERROR ] [ ${LINENO} ]"; exit 1; }
    WEBSITE_ROOT_DIR=`pwd -P`
}

function importe_database()
{
    cd $SOURCE_PATH
    mysql -u$DB_USERNAME  -p$DB_PASSWORD $DB_NAME < ${RESTORE_DIR}/db/database.sql
    [ $? -ne 0 ] && { echo "[ ERROR ] [ ${LINENO} ] Database Import Failed"; exit 1; }
}

function importe_code()
{
    cd $SOURCE_PATH
    mv ${RESTORE_DIR}/code/* ${WEBSITE_ROOT_DIR}/
    [ $? -ne 0 ] && { echo "[ ERROR ] [ ${LINENO} ] Website copy failed"; exit 1; }
}

function restore_success()
{
    echo "[ SUCCESS ] website restore successfully ( $DOMAIN )"
}


function main()
{
    get_current_dir
    arg_check
    validate_input
    get_user_confirmation
    extract_backup_archive
    import_config
    print_config
    get_abs_path_website_root
    db_empty_check
    dir_empty_check
    importe_database
    importe_code
    restore_success
}

# Call Main Function
main

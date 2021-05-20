#!/bin/bash

# migrate a website from one domain to another domain from backup
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
        echo "[ EXAMPLE ] ./migrate.sh backup.tar.gz"
        echo
        exit 1
    fi
}

function import_new_config()
{
    source $CURRENT_DIR/migrate_config.sh
    [ $? -ne 0 ] && { echo "[ ERROR ] [ ${LINENO} ]"; exit 1;}
}

function db_empty_check()
{
    table_count=$(mysql -u$NEW_DB_USERNAME -p$NEW_DB_PASSWORD -h $NEW_DB_HOST -P $NEW_DB_PORT $NEW_DB_NAME -e "SHOW TABLES;" | wc -l)

    if [ $table_count -gt 0 ];then
        echo "[ ERROR ] [ ${LINENO} ] DB is not empty ( table_count : $table_count ), truncate database before migrating"
        echo
        echo "      -> $NEW_DB_NAME"
        echo
        echo
        exit 1
    fi
}

function dir_empty_check()
{
    file_count=`ls ${NEW_WEBSITE_ROOT_DIR}/ | wc -l`
    if [ $file_count -gt 0 ];then
        echo "[ ERROR ] [ ${LINENO} ] website root directory is not empty, clear all files before migrating"
        echo
        echo "      -> $NEW_WEBSITE_ROOT_DIR"
        echo
        echo
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
        read -p "  Do you wish to migrate this website from backup ( YES / NO )?  " user_input
        echo
        case $user_input in
            [YES]* ) echo "  YES : Migrate Initiated"; break;;
            * ) echo "  NO ( DEFAULT )  : Aborting Migrate Operation";echo;exit;;
        esac
    done
    echo

}

function extract_backup_archive()
{
    echo "[ status ] extracting backup file : $SOURCE_FILE"
    # Enter backup directory
    cd $SOURCE_PATH
    [ $? -ne 0 ] && { echo "[ ERROR ] [ ${LINENO} ]"; exit 1; }

    # Remove Old Restore Folder ( if any )
    rm -rf $RESTORE_DIR

    # Extract backup archive
    tar -zxvf $SOURCE_FILE 1> /dev/null
    [ $? -ne 0 ] && { echo "[ ERROR ] [ ${LINENO} ]"; exit 1; }
}

#Old Configuration
function import_old_config()
{
    source $SOURCE_PATH/$RESTORE_DIR/restore_config.sh
    [ $? -ne 0 ] && { echo "[ ERROR ] [ ${LINENO} ]"; exit 1; }

}

function print_old_config()
{
    echo
    echo "OLD CONFIGURATION"
    echo
    echo "  DOMAIN      	  : $DOMAIN"
    echo "  Website Root      : $WEBSITE_ROOT_DIR"
    echo "  DB NAME           : $DB_NAME"
    echo "  DB USER           : $DB_USERNAME"
    echo "  DB PASSWORD       : $DB_PASSWORD"
    echo "  DB HOST       	  : $DB_HOST"
    echo "  DB PORT       	  : $DB_PORT"
    echo 
}

function print_new_config()
{
    echo 
    echo "NEW CONFIGURATION"
    echo 
    echo "  DOMAIN      	  : $NEW_DOMAIN"
    echo "  Website Root      : $NEW_WEBSITE_ROOT_DIR"
    echo "  DB NAME           : $NEW_DB_NAME"
    echo "  DB USER           : $NEW_DB_USERNAME"
    echo "  DB PASSWORD       : $NEW_DB_PASSWORD"
    echo "  DB HOST       	  : $NEW_DB_HOST"
    echo "  DB PORT       	  : $NEW_DB_PORT"
    echo 
}

function get_abs_path_new_website_root()
{
    cd $NEW_WEBSITE_ROOT_DIR
    [ $? -ne 0 ] && { echo "[ ERROR ] [ ${LINENO} ]"; exit 1; }
    NEW_WEBSITE_ROOT_DIR=`pwd -P`
}

#update new configuration in code and database 
function update_new_config()
{
    cd $SOURCE_PATH
    find $RESTORE_DIR -type f -exec sed -i -e "s/$DB_NAME/$NEW_DB_NAME/g" {} \;
    find $RESTORE_DIR -type f -exec sed -i -e "s/$DB_USERNAME/$NEW_DB_USERNAME/g" {} \;
    find $RESTORE_DIR -type f -exec sed -i -e "s/$DB_PASSWORD/$NEW_DB_PASSWORD/g" {} \;
    find $RESTORE_DIR -type f -exec sed -i -e "s/$DB_HOST/$NEW_DB_HOST/g" {} \;
    find $RESTORE_DIR -type f -exec sed -i -e "s/$DB_PORT/$NEW_DB_PORT/g" {} \;
    find $RESTORE_DIR -type f -exec sed -i -e "s/$DOMAIN/$NEW_DOMAIN/g" {} \;
}

function importe_database()
{
    cd $SOURCE_PATH
    mysql -u$NEW_DB_USERNAME  -p$NEW_DB_PASSWORD $NEW_DB_NAME < ${RESTORE_DIR}/db/database.sql
    [ $? -ne 0 ] && { echo "[ ERROR ] [ ${LINENO} ] Database Import Failed"; exit 1; }
}

function importe_code()
{
    cd $SOURCE_PATH
    mv ${RESTORE_DIR}/code/* ${NEW_WEBSITE_ROOT_DIR}/
    [ $? -ne 0 ] && { echo "[ ERROR ] [ ${LINENO} ] Website copy failed"; exit 1; }
}

function migration_success()
{
    echo "[ SUCCESS ] website migrated successfully ( $NEW_DOMAIN )"
}


function main()
{
    get_current_dir
    arg_check
    import_new_config
    db_empty_check
    dir_empty_check
    validate_input
    get_user_confirmation
    extract_backup_archive
    import_old_config
    print_old_config
    print_new_config
    get_abs_path_new_website_root
    update_new_config
    importe_database
    importe_code
    migration_success
}

# Call Main Function
main

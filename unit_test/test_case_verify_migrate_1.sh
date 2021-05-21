function import_config_new()
{
    echo "[ status ] importing config ( test_config/migrate_config.sh )"    
    source test_config/migrate_config.sh
    [ $? -ne 0 ] && { echo "  [ ERROR ] [ ${LINENO} ]"; exit 1; }
}

function import_config()
{
    echo "[ status ] importing config ( test_config/config.sh )"
    source test_config/config.sh
    [ $? -ne 0 ] && { echo "  [ ERROR ] [ ${LINENO} ]"; exit 1; }
}


function get_abs_path_backup_dir()
{
    #create backup directory
    mkdir -p $BACKUP_DIR 1> /dev/null 2>/dev/null

    cd $BACKUP_DIR
    [ $? -ne 0 ] && { echo "[ $TIME_STAMP ] [ ERROR ] [ ${LINENO} ] " >> $LOG_FILE; exit 1; }
    BACKUP_DIR=`pwd -P`
}

function extract_backup_website()
{
    echo "[ status ] extracting backup.tar.gz" 
    cd $BACKUP_DIR
    [ $? -ne 0 ] && { echo "  [ ERROR ] [ ${LINENO} ]"; exit 1; }
    rm -rf backup 1> /dev/null

    # Extract backup archive
    tar -zxvf backup.tar.gz 1> /dev/null
    [ $? -ne 0 ] && { echo "  [ ERROR ] [ ${LINENO} ]"; exit 1; }
    echo
}

function import_config_old()
{
    echo "[ status ] importing config ( $BACKUP_DIR/backup/restore_config.sh )"
    source $BACKUP_DIR/backup/restore_config.sh
    [ $? -ne 0 ] && { echo "  [ ERROR ] [ ${LINENO} ]"; exit 1; }
}

function validate_credentials()
{
    echo "[ status ] credentials validation"

    #New credentials should exist
    cd $NEW_WEBSITE_ROOT_DIR/code
	[ $? -ne 0 ] && { echo "[ UT_ERROR ] [ ${LINENO} ] "; exit 1; }		
    
    grep "$NEW_DOMAIN" -nr . 1> /dev/null 2> /dev/null
    [ $? -ne 0 ] && { echo "[ UT_ERROR ] [ ${LINENO} ] "; exit 1; }		

    grep "$NEW_DB_NAME" -nr . 1> /dev/null 2> /dev/null
	[ $? -ne 0 ] && { echo "[ UT_ERROR ] [ ${LINENO} ] "; exit 1; }		
    grep "$NEW_DB_USERNAME" -nr . 1> /dev/null 2> /dev/null
	[ $? -ne 0 ] && { echo "[ UT_ERROR ] [ ${LINENO} ] "; exit 1; }		
    grep "$NEW_DB_PASSWORD" -nr . 1> /dev/null 2> /dev/null
	[ $? -ne 0 ] && { echo "[ UT_ERROR ] [ ${LINENO} ] "; exit 1; }		

    #Old credentials should not exist [ no need to do this, most times old and new details are 90% same]

    echo "[ success ] credentials validation"
}

function validate_code()
{
	cd $NEW_WEBSITE_ROOT_DIR
	echo
	echo "[ STATUS ] code validation"
	echo
	ls .htaccess 1> /dev/null
		[ $? -ne 0 ] && { echo "[ UT_ERROR ] [ ${LINENO} ] "; exit 1; }		
	ls index.html 1> /dev/null
		[ $? -ne 0 ] && { echo "[ UT_ERROR ] [ ${LINENO} ] "; exit 1; }		
	ls code/a.php 1> /dev/null
		[ $? -ne 0 ] && { echo "[ UT_ERROR ] [ ${LINENO} ] "; exit 1; }		
	ls code/a.html 1> /dev/null
		[ $? -ne 0 ] && { echo "[ UT_ERROR ] [ ${LINENO} ] "; exit 1; }		
	ls code/a.css 1> /dev/null
		[ $? -ne 0 ] && { echo "[ UT_ERROR ] [ ${LINENO} ] "; exit 1; }		
	ls code/a.py 1> /dev/null
		[ $? -ne 0 ] && { echo "[ UT_ERROR ] [ ${LINENO} ] "; exit 1; }		
	ls code/.hidden 1> /dev/null
		[ $? -ne 0 ] && { echo "[ UT_ERROR ] [ ${LINENO} ] "; exit 1; }		

	echo "[ SUCCESS ] code validation"
}

function validate_data()
{
	cd $NEW_WEBSITE_ROOT_DIR
	echo
	echo "[ STATUS ] data validation"
	echo
	ls data/images/a.png 1> /dev/null
		[ $? -ne 0 ] && { echo "[ UT_ERROR ] [ ${LINENO} ] "; exit 1; }		
	ls data/test.dat 1> /dev/null
		[ $? -ne 0 ] && { echo "[ UT_ERROR ] [ ${LINENO} ] "; exit 1; }		
	ls data/video/a.mp4 1> /dev/null
		[ $? -ne 0 ] && { echo "[ UT_ERROR ] [ ${LINENO} ] "; exit 1; }		

	echo "[ SUCCESS ] data validation"
}

function db_record_validation(){
	echo "[ STATUS ] db record validation"
	TABLE_NAME="test_table"

	mysql -u$DB_USERNAME -p$DB_PASSWORD -h $DB_HOST -P $DB_PORT $DB_NAME -e "SHOW TABLES;" | grep $TABLE_NAME 1> /dev/null
		[ $? -ne 0 ] && { echo "[ UT_ERROR ] [ ${LINENO} ] "; exit 1; }
	mysql -u$DB_USERNAME -p$DB_PASSWORD -h $DB_HOST -P $DB_PORT $DB_NAME -e "SELECT * FROM $TABLE_NAME;" | grep "test_activity1" 1> /dev/null
		[ $? -ne 0 ] && { echo "[ UT_ERROR ] [ ${LINENO} ] "; exit 1; }
	mysql -u$DB_USERNAME -p$DB_PASSWORD -h $DB_HOST -P $DB_PORT $DB_NAME -e "SELECT * FROM $TABLE_NAME;" | grep "test_activity2" 1> /dev/null
		[ $? -ne 0 ] && { echo "[ UT_ERROR ] [ ${LINENO} ] "; exit 1; }
	mysql -u$DB_USERNAME -p$DB_PASSWORD -h $DB_HOST -P $DB_PORT $DB_NAME -e "SELECT * FROM $TABLE_NAME;" | grep "test_activity3" 1> /dev/null
		[ $? -ne 0 ] && { echo "[ UT_ERROR ] [ ${LINENO} ] "; exit 1; }
	mysql -u$DB_USERNAME -p$DB_PASSWORD -h $DB_HOST -P $DB_PORT $DB_NAME -e "SELECT * FROM $TABLE_NAME;" | grep "test_activity4" 1> /dev/null
		[ $? -ne 0 ] && { echo "[ UT_ERROR ] [ ${LINENO} ] "; exit 1; }
	mysql -u$DB_USERNAME -p$DB_PASSWORD -h $DB_HOST -P $DB_PORT $DB_NAME -e "SELECT * FROM $TABLE_NAME;" | grep "test_activity5" 1> /dev/null
		[ $? -ne 0 ] && { echo "[ UT_ERROR ] [ ${LINENO} ] "; exit 1; }
	
	echo "[ SUCCESS ] db record validation"
}

function main()
{
    import_config_new
    import_config
    get_abs_path_backup_dir
    extract_backup_website
    echo	
    import_config_old
    echo
    validate_credentials
    echo
    validate_code
    echo	
    validate_data
    echo	
    db_record_validation
    echo	
}

#main code
main

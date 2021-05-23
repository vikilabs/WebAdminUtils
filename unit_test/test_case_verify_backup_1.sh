function import_config()
{
    echo "[ status ] importing config ( sandbox/test_website/WebAdminUtils/.config_old.sh )"
    source sandbox/test_website/WebAdminUtils/.config_old.sh
 
    [ $? -ne 0 ] && { echo "  [ ERROR ] [ ${LINENO} ]"; exit 1; }
}

function get_abs_path_backup_dir()
{
    cd $BACKUP_DIR
    [ $? -ne 0 ] && { echo "[ $TIME_STAMP ] [ ERROR ] [ ${LINENO} ] " >> $LOG_FILE; exit 1; }
    BACKUP_DIR=`pwd -P`
}

function extract_backup()
{
    cd $BACKUP_DIR
    tar -zxvf backup.tar.gz
}

function validate_code()
{
    cd $BACKUP_DIR/backup
	echo
	echo "[ STATUS ] code validation"
	echo
	ls ./code/.htaccess 1> /dev/null
		[ $? -ne 0 ] && { echo "[ UT_ERROR ] [ ${LINENO} ] "; exit 1; }		
	ls ./code/index.html 1> /dev/null
		[ $? -ne 0 ] && { echo "[ UT_ERROR ] [ ${LINENO} ] "; exit 1; }		
	ls ./code/code/a.php 1> /dev/null
		[ $? -ne 0 ] && { echo "[ UT_ERROR ] [ ${LINENO} ] "; exit 1; }		
	ls ./code/code/a.html 1> /dev/null
		[ $? -ne 0 ] && { echo "[ UT_ERROR ] [ ${LINENO} ] "; exit 1; }		
	ls ./code/code/a.css 1> /dev/null
		[ $? -ne 0 ] && { echo "[ UT_ERROR ] [ ${LINENO} ] "; exit 1; }		
	ls ./code/code/a.py 1> /dev/null
		[ $? -ne 0 ] && { echo "[ UT_ERROR ] [ ${LINENO} ] "; exit 1; }		
	ls ./code/code/.hidden 1> /dev/null
		[ $? -ne 0 ] && { echo "[ UT_ERROR ] [ ${LINENO} ] "; exit 1; }		
	
	echo "[ SUCCESS ] code validation"
}

function validate_data()
{
    cd $BACKUP_DIR/backup
	echo
	echo "[ STATUS ] data validation"
	echo
	ls ./code/data/images/a.png 1> /dev/null
		[ $? -ne 0 ] && { echo "[ UT_ERROR ] [ ${LINENO} ] "; exit 1; }		
	ls ./code/data/test.dat 1> /dev/null
		[ $? -ne 0 ] && { echo "[ UT_ERROR ] [ ${LINENO} ] "; exit 1; }		
	ls ./code/data/video/a.mp4 1> /dev/null
		[ $? -ne 0 ] && { echo "[ UT_ERROR ] [ ${LINENO} ] "; exit 1; }		

	echo "[ SUCCESS ] data validation"
}

function validate_db_dump()
{
    cd $BACKUP_DIR/backup
	echo 
	echo "[ STATUS ] db validation"
	echo 
	grep test_table db/database.sql 1> /dev/null
	[ $? -ne 0 ] && { echo "[ UT_ERROR ] [ ${LINENO} ] "; exit 1; }		

	grep test_activity1 db/database.sql 1> /dev/null
	[ $? -ne 0 ] && { echo "[ UT_ERROR ] [ ${LINENO} ] "; exit 1; }		

	grep test_activity2 db/database.sql 1> /dev/null
	[ $? -ne 0 ] && { echo "[ UT_ERROR ] [ ${LINENO} ] "; exit 1; }		

	grep test_activity3 db/database.sql 1> /dev/null
	[ $? -ne 0 ] && { echo "[ UT_ERROR ] [ ${LINENO} ] "; exit 1; }		

	grep test_activity4 db/database.sql 1> /dev/null
	[ $? -ne 0 ] && { echo "[ UT_ERROR ] [ ${LINENO} ] "; exit 1; }		

	grep test_activity5 db/database.sql 1> /dev/null
	[ $? -ne 0 ] && { echo "[ UT_ERROR ] [ ${LINENO} ] "; exit 1; }		

	echo "[ SUCCESS ] db validation"
}

function main()
{
    import_config
    get_abs_path_backup_dir
    extract_backup
    validate_code
    echo	
    validate_data
    echo	
    validate_db_dump
    echo	
}

#main function
main

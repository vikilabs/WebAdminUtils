function import_config_old()
{
    echo "[ status ] importing config ( sandbox/test_website/WebAdminUtils/.config_old.sh )"
    source sandbox/test_website/WebAdminUtils/.config_old.sh
    [ $? -ne 0 ] && { echo "  [ ERROR ] [ ${LINENO} ]"; exit 1; }
}

function validate_code()
{
	cd $WEBSITE_ROOT_DIR
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
	cd $WEBSITE_ROOT_DIR
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
    import_config_old
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

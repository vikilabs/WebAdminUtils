function validate_code()
{
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

function validate_db()
{
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

validate_code
echo	
validate_data
echo	
validate_db
echo	

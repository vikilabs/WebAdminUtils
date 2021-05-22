
function get_current_dir()
{
    CURRENT_DIR=`pwd -P`
}

function init_sandbox()
{
    echo "[ STATUS  ] init_sandbox"

    cd $CURRENT_DIR

    mkdir -p sandbox 1> /dev/null 2> /dev/null
    rm -rf sandbox/* 1> /dev/null 2> /dev/null

    cp test_website.tar.gz sandbox/
    [ $? -ne 0 ] && { echo "[ UT_ERROR ] [ ${LINENO} ] "; exit 1; }		

    cd sandbox/
    tar -zxvf test_website.tar.gz 1> /dev/null
    cd ../

    echo "[ SUCCESS ] init_sandbox"
}

function copy_test_config()
{
    echo "[ STATUS  ] copy test config"

    cd $CURRENT_DIR

    cp test_config/config.sh sandbox/ 
    [ $? -ne 0 ] && { echo "[ UT_ERROR ] [ ${LINENO} ] "; exit 1; }

    echo "[ SUCCESS ] copy test config"
}

function import_config()
{
    source $CURRENT_DIR/sandbox/config.sh
    [ $? -ne 0 ] && { echo "[ ERROR ] [ ${LINENO} ] "; exit 1; }
}

function get_abs_path_backup_dir()
{
    #create backup directory
    mkdir -p $BACKUP_DIR 1> /dev/null 2>/dev/null

    cd $BACKUP_DIR
    [ $? -ne 0 ] && { echo "[ $TIME_STAMP ] [ ERROR ] [ ${LINENO} ] " >> $LOG_FILE; exit 1; }
    BACKUP_DIR=`pwd -P`
}


function restore_test_1()
{
    cd $CURRENT_DIR/sandbox
	[ $? -ne 0 ] && { echo "[ UT_ERROR ] [ ${LINENO} ] "; exit 1; }		
	echo "[ STATUS  ] restore_test_1"
    ./restore_website 1> /dev/null
	[ $? -ne 0 ] && { echo "[ UT_ERROR ] [ ${LINENO} ] "; exit 1; }		
	echo "[ SUCCESS ] restore_test_1"
	cd $CURRENT_DIR
	[ $? -ne 0 ] && { echo "[ UT_ERROR ] [ ${LINENO} ] "; exit 1; }		
}

function verify_restore_test_1()
{
    cd $CURRENT_DIR
    ./test_case_verify_restore_1.sh    
	[ $? -ne 0 ] && { echo "[ ERROR ] [ ${LINENO} ] verify_restore_test_1 failed"; exit 1; }		
    echo "[ SUCCESS ] verify_restore_test_1()"
}

function backup_test_1()
{
	echo "[ STATUS  ] backup_test_1"
	
    get_abs_path_backup_dir

    #Delete any stale contents in backup directory
    rm -rf $BACKUP_DIR/*  1> /dev/null 2>/dev/null

    cd $CURRENT_DIR/sandbox
	[ $? -ne 0 ] && { echo "[ UT_ERROR ] [ ${LINENO} ] "; exit 1; }		
	
	./backup_website 1> /dev/null
	[ $? -ne 0 ] && { echo "[ UT_ERROR ] [ ${LINENO} ] "; exit 1; }		

    
	#change backup_TIMESTAMP.tar.gz -> backup.tar.gz
    cd $BACKUP_DIR
    tar -zxvf *.tar.gz 1> /dev/null
	[ $? -ne 0 ] && { echo "[ UT_ERROR ] [ ${LINENO} ] "; exit 1; }		
    rm *.tar.gz
	[ $? -ne 0 ] && { echo "[ UT_ERROR ] [ ${LINENO} ] "; exit 1; }		
    
    #delete any log files
    rm *.log

    mv * backup
	[ $? -ne 0 ] && { echo "[ UT_ERROR ] [ ${LINENO} ] "; exit 1; }		
    tar -czvf backup.tar.gz backup 1> /dev/null
	[ $? -ne 0 ] && { echo "[ UT_ERROR ] [ ${LINENO} ] "; exit 1; }		
	
	echo "[ SUCCESS ] backup_test_1"
	cd $CURRENT_DIR
	[ $? -ne 0 ] && { echo "[ UT_ERROR ] [ ${LINENO} ] "; exit 1; }		
}

function verify_backup_test_1()
{
    cd $CURRENT_DIR
    ./test_case_verify_backup_1.sh    
	[ $? -ne 0 ] && { echo "[ ERROR ] [ ${LINENO} ] verify_backup_test_1 failed"; exit 1; }		
    echo "[ SUCCESS ] verify_backup_test_1()"
}

function restore_test_2()
{
    cd $CURRENT_DIR/sandbox
	[ $? -ne 0 ] && { echo "[ UT_ERROR ] [ ${LINENO} ] "; exit 1; }		
	echo "[ STATUS  ] restore_test_2"
    ./restore_website 1> /dev/null
	[ $? -ne 0 ] && { echo "[ UT_ERROR ] [ ${LINENO} ] "; exit 1; }		
	echo "[ SUCCESS ] restore_test_2"
	cd $CURRENT_DIR
	[ $? -ne 0 ] && { echo "[ UT_ERROR ] [ ${LINENO} ] "; exit 1; }		
}

function verify_restore_test_2()
{
    cd $CURRENT_DIR
    ./test_case_verify_restore_2.sh    
	[ $? -ne 0 ] && { echo "[ ERROR ] [ ${LINENO} ] verify_restore_test_2 failed"; exit 1; }		
    echo "[ SUCCESS ] verify_restore_test_2()"
}


function migrate_test_1()
{
    cd $CURRENT_DIR/sandbox
	[ $? -ne 0 ] && { echo "[ UT_ERROR ] [ ${LINENO} ] "; exit 1; }		
	echo "[ STATUS  ] migrate_test_1"
    ./migrate_website 1> /dev/null  
	[ $? -ne 0 ] && { echo "[ UT_ERROR ] [ ${LINENO} ] "; exit 1; }		
	echo "[ SUCCESS ] migrate_test_1"
	cd $CURRENT_DIR
	[ $? -ne 0 ] && { echo "[ UT_ERROR ] [ ${LINENO} ] "; exit 1; }		
}

function verify_migrate_test_1()
{
    cd $CURRENT_DIR
    ./test_case_verify_migrate_1.sh    
	[ $? -ne 0 ] && { echo "[ ERROR ] [ ${LINENO} ] verify_migrate_test_1 failed"; exit 1; }		
    echo "[ SUCCESS ] verify_migrate_test_1()"
}

function clear_website_and_db()
{
    #clean website content
    cd $WEBSITE_ROOT_DIR
	[ $? -ne 0 ] && { echo "[ UT_ERROR ] [ ${LINENO} ] "; exit 1; }		
    rm -rf *

    #clean DB
    mysql -u$DB_USERNAME -p$DB_PASSWORD -h $DB_HOST -P $DB_PORT $DB_NAME -e "DROP TABLE test_table;"
}

function cleanup()
{
	cd $CURRENT_DIR
    rm -rf sandbox
    rm -rf test_website
}

function extract_backup_base()
{

}

function main()
{
    echo
    get_current_dir
    init_sandbox
    copy_test_config
    import_config

    #Do not change the order of test case execution
    clear_website_and_db
    restore_test_1
    verify_restore_test_1

    backup_test_1
    verify_backup_test_1
    
    clear_website_and_db
    restore_test_2
    verify_restore_test_2
    
    clear_website_and_db
    migrate_test_1
    verify_migrate_test_1
    echo

    echo "[ ALL TEST CASES EXECUTED SUCCESSFULLY : APPROVED FOR RELEASE ]"

    echo
    cleanup
}

# main function
main

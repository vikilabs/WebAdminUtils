
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

    echo "[ SUCCESS ] init_sandbox"
}

function import_old_config()
{
    source $CURRENT_DIR/sandbox/test_website/WebAdminUtils/.config_old.sh 
    [ $? -ne 0 ] && { echo "[ ERROR ] [ ${LINENO} ] "; exit 1; }
}


function import_new_config()
{
    source $CURRENT_DIR/sandbox/test_website/WebAdminUtils/config.sh 
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
    cd $CURRENT_DIR/sandbox/test_website/WebAdminUtils/
	[ $? -ne 0 ] && { echo "[ UT_ERROR ] [ ${LINENO} ] "; exit 1; }		
	echo "[ STATUS  ] restore_test_1"
    ./restore_website
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

function post_backup_setup()
{
    cd $BACKUP_DIR
    rm *.log
    tar -zxvf *.tar.gz
    rm *.tar.gz
    mv * backup
    cd backup
    cd WebAdminUtils
    cp /tmp/config.sh config.sh
    cp /tmp/.config_old.sh .config_old.sh 
    cd ../..
    tar -czvf backup.tar.gz backup
    rm -rf backup
}

function backup_test_1()
{
	echo "[ STATUS  ] backup_test_1"
	
    get_abs_path_backup_dir

    #Delete any stale contents in backup directory
    rm -rf $BACKUP_DIR/*  1> /dev/null 2>/dev/null

    cd $CURRENT_DIR/sandbox/test_website/WebAdminUtils/
	[ $? -ne 0 ] && { echo "[ UT_ERROR ] [ ${LINENO} ] "; exit 1; }

    cp config.sh /tmp/config.sh
    cp .config_old.sh /tmp/.config_old.sh

	./backup_website
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
	echo "[ STATUS  ] restore_test_2"
    cd $BACKUP_DIR
	[ $? -ne 0 ] && { echo "[ UT_ERROR ] [ ${LINENO} ] "; exit 1; }		

    tar -zxvf backup.tar.gz 1> /dev/null
	[ $? -ne 0 ] && { echo "[ UT_ERROR ] [ ${LINENO} ] "; exit 1; }		

    cd backup/WebAdminUtils
	[ $? -ne 0 ] && { echo "[ UT_ERROR ] [ ${LINENO} ] "; exit 1; }		

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
	echo "[ STATUS  ] migrate_test_1"
    
    cd $BACKUP_DIR
	[ $? -ne 0 ] && { echo "[ UT_ERROR ] [ ${LINENO} ] "; exit 1; }		

    rm -rf backup 1> /dev/null 2> /dev/null

    tar -zxvf backup.tar.gz 1> /dev/null
	[ $? -ne 0 ] && { echo "[ UT_ERROR ] [ ${LINENO} ] "; exit 1; }		

    cd backup/WebAdminUtils
	[ $? -ne 0 ] && { echo "[ UT_ERROR ] [ ${LINENO} ] "; exit 1; }		

    ./migrate_website   
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
    rm -rf $BACKUP_DIR
}

function main()
{
    echo
    get_current_dir
    init_sandbox
    import_old_config
    
    #Do not change the order of test case execution
    clear_website_and_db
    restore_test_1
    verify_restore_test_1

    backup_test_1
    post_backup_setup
    verify_backup_test_1
    
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

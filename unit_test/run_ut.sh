
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

    cp ../src/backup_website sandbox/
    [ $? -ne 0 ] && { echo "[ UT_ERROR ] [ ${LINENO} ] "; exit 1; }		
    cp ../src/install_website sandbox/
    [ $? -ne 0 ] && { echo "[ UT_ERROR ] [ ${LINENO} ] "; exit 1; }		
    cp ../src/migrate_website sandbox/
    [ $? -ne 0 ] && { echo "[ UT_ERROR ] [ ${LINENO} ] "; exit 1; }		
    cp ../src/restore_website sandbox/
    [ $? -ne 0 ] && { echo "[ UT_ERROR ] [ ${LINENO} ] "; exit 1; }		
    echo "[ SUCCESS ] init_sandbox"
}

function copy_test_config()
{
    echo "[ STATUS  ] copy test config"

    cd $CURRENT_DIR

    cp test_config/* sandbox/ 
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
    cd $BACKUP_DIR
    [ $? -ne 0 ] && { echo "[ $TIME_STAMP ] [ ERROR ] [ ${LINENO} ] " >> $LOG_FILE; exit 1; }
    BACKUP_DIR=`pwd -P`
}


function restore_test_1()
{
    cd $CURRENT_DIR/sandbox
	[ $? -ne 0 ] && { echo "[ UT_ERROR ] [ ${LINENO} ] "; exit 1; }		
	echo "[ STATUS  ] restore_test_1"
	./restore_website "../test_website.tar.gz"
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
	
    cd $CURRENT_DIR/sandbox
	[ $? -ne 0 ] && { echo "[ UT_ERROR ] [ ${LINENO} ] "; exit 1; }		
	
	./backup_website 

	#copy backup_TIMESTAMP.tar.gz -> backup.tar.gz
	mv $BACKUP_DIR/* $BACKUP_DIR/backup.tar.gz
	[ $? -ne 0 ] && { echo "[ UT_ERROR ] [ ${LINENO} ] "; exit 1; }		
	
	echo "[ SUCCESS ] backup_test_1"
	cd $CURRENT_DIR
	[ $? -ne 0 ] && { echo "[ UT_ERROR ] [ ${LINENO} ] "; exit 1; }		
}

function restore_test_2()
{
	cd sandbox
	[ $? -ne 0 ] && { echo "[ UT_ERROR ] [ ${LINENO} ] "; exit 1; }		
	echo "[ STATUS  ] restore_test_2"
	./restore_website $BACKUP_DIR/backup.tar.gz


	echo "[ SUCCESS ] restore_test_2"
	cd $CURRENT_DIR
	[ $? -ne 0 ] && { echo "[ UT_ERROR ] [ ${LINENO} ] "; exit 1; }		
}

function migrate_test_1()
{
	cd sandbox
	[ $? -ne 0 ] && { echo "[ UT_ERROR ] [ ${LINENO} ] "; exit 1; }		
	echo "[ STATUS  ] backup_test_1"
	./migrate_website $BACKUP_DIR/backup.tar.gz

	echo "[ SUCCESS ] backup_test_1"
	cd $CURRENT_DIR
	[ $? -ne 0 ] && { echo "[ UT_ERROR ] [ ${LINENO} ] "; exit 1; }		
}

function cleanup()
{
	cd $CURRENT_DIR
    rm -rf sandbox
}

function main()
{
    echo
    get_current_dir
    init_sandbox
    copy_test_config
    import_config

    #Do not change the order of test case execution
    restore_test_1
    verify_restore_test_1
    #backup_test_1
    #restore_test_2
    #migrate_test_1
    echo

    cleanup
}

# main function
main

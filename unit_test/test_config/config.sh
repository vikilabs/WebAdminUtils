#!/bin/bash

# Keep all config values in single quotes unless specified otherwise

#enter the website address
DOMAIN='bugs.vikilabs.org'

DB_NAME='u730147653_db'
DB_USERNAME='u730147653_user'

#Keep the password inside single quotes ( Do not use double quotes )

DB_PASSWORD='Db1234$ab'
DB_HOST='localhost'
DB_PORT='3306'

#website root directory ( don't keep / at the end)
#Do not use quotes
WEBSITE_ROOT_DIR=~/public_html/

#website backup directory ( don't keep / at the end).
#Do not use quotes
BACKUP_DIR=~/test_backup

#Use this config in double quotes
LOG_FILE="${BACKUP_DIR}/${DOMAIN}_backup.log"

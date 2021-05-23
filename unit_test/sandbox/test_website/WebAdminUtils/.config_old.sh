#!/bin/bash

# Keep all config values in single quotes unless specified otherwise

#enter the website address
DOMAIN='testa.vikilabs.org'

DB_NAME='u218639858_testa_db'
DB_USERNAME='u218639858_testa_admin'

#Keep the password inside single quotes ( Do not use double quotes )

DB_PASSWORD='Test$DB123'
DB_HOST='localhost'
DB_PORT='3306'

#OPTIONAL CONFIG [ SPECIAL PREVILAGES ]

MYSQL_ADMIN_USERNAME=''
MYSQL_ADMIN_PASSWORD=''

#website root directory ( don't keep / at the end)
#Do not use quotes
WEBSITE_ROOT_DIR=~/public_html/

#website backup directory ( don't keep / at the end).
#Do not use quotes
BACKUP_DIR=~/test_backup

#Use this config in double quotes
LOG_FILE="/tmp/backup.testa.vikilabs.org.log"

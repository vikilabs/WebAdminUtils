#!/bin/bash

# Keep all config values in single quotes unless specified otherwise

#enter the website address
DOMAIN='test.com'

#Keep the password inside single quotes ( Do not use double quotes )

DB1_NAME=''
DB1_USERNAME=''
DB1_PASSWORD=''

DB2_NAME=''
DB2_USERNAME=''
DB2_PASSWORD=''

#################

DB_HOST='localhost'
DB_PORT='3306'

#OPTIONAL CONFIG [ SPECIAL PREVILAGES ]

MYSQL_ADMIN_USERNAME='root'
MYSQL_ADMIN_PASSWORD='root'

#website root directory ( don't keep / at the end)
#Do not use quotes
WEBSITE_ROOT_DIR=/var/www/html

#website backup directory ( don't keep / at the end).
#Do not use quotes
BACKUP_DIR=/var/www/html

#Use this config in double quotes
LOG_FILE="/tmp/test.log"

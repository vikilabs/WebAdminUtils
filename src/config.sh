#enter the website address
DOMAIN="example.com"

DB_NAME="test_db"
DB_USERNAME="test_user"

#Keep the password inside single quotes ( Do not use double quotes )

DB_PASSWORD='122333'
DB_HOST="localhost"
DB_PORT=3306

#website root directory ( don't keep / at the end)
#Do not use quotes
WEBSITE_ROOT_DIR=/var/www/example.com

#website backup directory ( don't keep / at the end).
#Do not use quotes
BACKUP_DIR=/var/www/backup

LOG_FILE="${BACKUP_DIR}/${DOMAIN}_backup.log"

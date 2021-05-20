# Change to read, execute only mode

chmod 555 ./src/migrate_website
chmod 555 ./src/restore_website
chmod 555 ./src/install_website
chmod 555 ./src/backup_website

cd tarball
#create tarball
./compress.sh

cd ..

# Change to read, write, execute mode
chmod 777 ./src/*


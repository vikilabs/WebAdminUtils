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

cd unit_test
tar -zxvf test_website.tar.gz 1> /dev/null
rm test_website.tar.gz
mkdir -p test_website/WebAdminUtils 1> /dev/null 2> /dev/null
cp ../src/* test_website/WebAdminUtils/
cp test_config/config.sh test_website/WebAdminUtils/.config_old.sh
cp test_config/migrate_config.sh test_website/WebAdminUtils/config.sh
tar -czvf test_website.tar.gz test_website 1> /dev/null

rm -rf test_website

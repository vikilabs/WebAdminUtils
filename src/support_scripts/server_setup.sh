sudo ls

apt-get purge -y 'php*'
sudo apt -y autoremove
#add-apt-repository ppa:ondrej/php
#[ $? -ne 0 ] && { echo "error line ( ${LINENO} )"; exit 1; }
apt -y update
[ $? -ne 0 ] && { echo "error line ( ${LINENO} )"; exit 1; }
apt install -y  software-properties-common
[ $? -ne 0 ] && { echo "error line ( ${LINENO} )"; exit 1; }
apt install -y ffmpeg
[ $? -ne 0 ] && { echo "error line ( ${LINENO} )"; exit 1; }
apt install -y libimage-exiftool-perl
[ $? -ne 0 ] && { echo "error line ( ${LINENO} )"; exit 1; }

apt install -y php7.3  php7.3-mysql php7.3-cli php7.3-common php7.3-json php7.3-opcache php7.3-readline php7.3-curl php7.3-gd php7.3-xml
[ $? -ne 0 ] && { echo "error line ( ${LINENO} )"; exit 1; }

apt install -y python3-pip
[ $? -ne 0 ] && { echo "error line ( ${LINENO} )"; exit 1; }
sudo apt install -y git
[ $? -ne 0 ] && { echo "error line ( ${LINENO} )"; exit 1; }
pip3 install youtube-dl
[ $? -ne 0 ] && { echo "error line ( ${LINENO} )"; exit 1; }

#Install Apache

apt-get -y update
apt-get install -y apache2
ufw allow 'Apache Full'
systemctl restart apache2
systemctl status apache2

#mysqladmin -u root password NEWPASSWORD

uninstall_mysql(){
	apt-get remove -y --purge mysql*
	apt-get purge -y mysql*
	apt-get -y autoremove.
	apt-get -y autoremove
	apt-get -y autoclean
	apt-get  remove -y dbconfig-mysql
	#apt-get -y dist-upgrade
	rm -r /var/lib/mysql
}

uninstall_mysql

apt install -y mysql-server
#service mysql stop
#service mysql start
#mysql_secure_installation

CONFIG_FILE="/etc/php/7.3/apache2/php.ini"
sed -i '/post_max_size/c\post_max_size = 1024M' 		$CONFIG_FILE
sed -i '/upload_max_filesize/c\upload_max_filesize = 1024M' 	$CONFIG_FILE
sed -i '/max_execution_time/c\max_execution_time = 7200' 	$CONFIG_FILE
sed -i '/memory_limit/c\memory_limit = 512M' 	$CONFIG_FILE


systemctl restart apache2
[ $? -ne 0 ] && { echo "error line ( ${LINENO} )"; exit 1; }


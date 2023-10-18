#bin/bash


##INSTALL ARCHIVES AND DEPENDENCIES
cd $HOME
wget https://repo.zabbix.com/zabbix/6.4/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.4-1+ubuntu22.04_all.deb
dpkg -i zabbix-release_6.4-1+ubuntu22.04_all.deb
apt update
apt install zabbix-server-mysql zabbix-frontend-php zabbix-apache-conf zabbix-sql-scripts zabbix-agent -y
apt install mysql-server -y

#CONFIGURATION FOR DB
sudo mysql -u root -e "create database zabbix character set utf8mb4 collate utf8mb4_bin;"
sudo mysql -u root -e "create user zabbix@localhost identified by 'password';"
sudo mysql -u root -e "grant all privileges on zabbix.* to zabbix@localhost;"
sudo mysql -u root -e "set global log_bin_trust_function_creators = 1;"
zcat /usr/share/zabbix-sql-scripts/mysql/server.sql.gz | mysql --default-character-set=utf8mb4 -uzabbix -pmysql -uzabbix -ppassword zabbix
sudo mysql -u root -e "set global log_bin_trust_function_creators = 0;"
sudo su -
sudo cat cat /configs/zabbix_server.config > /etc/zabbix/zabbix_server.conf
sudo systemctl restart zabbix-server zabbix-agent apache2
sudo systemctl enable zabbix-server zabbix-agent apache2








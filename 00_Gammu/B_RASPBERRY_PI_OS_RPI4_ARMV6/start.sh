#!/bin/bash

if [ `whoami` != 'root' ]
  then
    echo "You must be root to do this."
    exit
fi

echo "Quel est le numero de telephone Test ? :"
read phone

echo "Quel est le message a envoyer ? : "
read test_message

echo "Quel est le mot de passe de la base de donnee ? :"
read mysql_password


#Update and Install Software
echo "Installing Primary Software"
sudo apt-get update -y && sudo apt-get upgrade -y
sudo apt-get install -y vim curl git zsh
echo "Starting Oh My Zsh"
yes | sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

#Install Gammu and Mysql 
echo "Installing Gammu and Mysql"
sudo apt-get install -y mariadb-server gammu gammu-smsd

#Configuring Cammu Configuration File
echo "Configuring gammurc"

echo "[gammu]
device= /dev/ttyS0
connection = at115200" > /etc/gammurc

#Testing Gammu SMS
echo "Testing Gammu SMS"

gammu sendsms TEXT $phone -text "$test_message"

#Configuring Mariadb
echo "Configuring MariaDb"

mysql -e "CREATE USER IF NOT EXISTS 'smsd'@'localhsot' IDENTIFIED BY '$mysql_password'"
mysql -e "GRANT USAGE ON *.* TO 'smsd'@'localhost' IDENTIFIED BY '$mysql_password';"
mysql -e "GRANT SELECT, INSERT, UPDATE, DELETE ON \`smsd\`.* TO 'smsd'@'localhost';"
mysql -e "CREATE DATABASE IF NOT EXISTS smsd;"
mysql -e "FLUSH PRIVILEGES;"

#Configuring Gammu SMSD Configuration File
echo "Configuring Gammu-Smsd Configuration File"

echo "[gammu]
device= /dev/ttyS0
connection = at115200

[smsd]
service = sql
driver = native_mysql
host = localhost
user = smsd
password = $mysql_password
pc = localhost
database = smsd" > /etc/gammu-smsdrc

#Initialization of SMSD Database
echo "Initialization of SMSD Database"

mysql smsd < smsd.sql

#Restarting and Testing Gammu SMSD
echo "Restarting and Testing Gammu SMSD"

service gammu-smsd restart
echo "wait..."
sleep 4

gammu-smsd-inject TEXT $phone -len 1 -text "$test_message"


echo "It's Finished !"

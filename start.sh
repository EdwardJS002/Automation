#!/bin/bash

if [ `whoami` != 'root' ]
  then
    echo "Vous devez être utilisateur root pour executer ce script. Utilisez:"
    echo "sudo sh ./0_START.sh"
    exit
fi

##############################################################################################

#### Checking Version

osversion=$(grep '^ID=' /etc/os-release | cut -c4-);

if [ $osversion = 'ubuntu' ]
  then 
    echo "Vous avez choisi Ubuntu comme système d'exploitation."

    cp /boot/firmware/config.txt /boot/firmware/config-old.txt
    cp /boot/firmware/cmdline.txt /boot/firmware/cmdline-old.txt

    #cp ./UTILS/ubuntu/config.txt /boot/firmware/config.txt
    #cp ./UTILS/ubuntu/cmdline.txt /boot/firmware/cmdline.txt

    sed -i -e 's/console=serial0,115200//g' /boot/firmware/cmdline.txt

    echo "Changement des fichiers pour utiliser le module SMS OK !"

elif [ $osversion = 'raspbian' ]
  then
    echo "Vous avez choisi Raspberry Pi OS comme système d'exploitation."

    cp /boot/config.txt /boot/config-old.txt
    cp /boot/cmdline.txt /boot/cmdline-old.txt

    cp ./UTILS/raspberry/config.txt /boot/config.txt
    #cp ./UTILS/raspberry/cmdline.txt /boot/cmdline.txt

    sed -i -e 's/console=serial0,115200//g' /boot/cmdline.txt

    echo "Changement des fichiers pour utiliser le module SMS OK !"

else
  echo "Le Système d'exploitation n'a pas été reconnu... Aucune action n'a été effectuée..."
  exit
fi

##############################################################################################

GAMMU_TEST_MESSAGE="Tout fonctionne nickel depuis Gammu à $(date +%H%M)"
API_TEST_MESSAGE="API OK !"


echo "Quel est votre numero de telephone (Pour vérification) ? :"
read phone

GAMMU_PHONE=$phone


#echo "Quel est le mot de passe de la base de donnee ? :"
#read mysql_password
#GAMMU_MYSQL_PASSWORD=$mysql_password
GAMMU_MYSQL_PASSWORD="mypassword"

#echo "Quel est le chemin de l'appareil SMS ? :"
#read device_path
#GAMMU_DEVICE_PATH=$device_path
GAMMU_DEVICE_PATH="/dev/ttyS0"


#Update and Install Software
echo "Installing Primary Software"
#sudo apt-get update -y && sudo apt-get upgrade -y
sudo apt-get install -y vim curl git nodejs npm

#Install Gammu and Mysql 
echo "Installing Gammu and Mysql"
sudo apt-get install -y mariadb-server gammu gammu-smsd

#Configuring Cammu Configuration File
echo "Configuring gammurc"

echo "[gammu]
device= $GAMMU_DEVICE_PATH
connection = at115200" > /etc/gammurc

#Testing Gammu SMS
echo "Testing Gammu SMS"

gammu sendsms TEXT $GAMMU_PHONE -text "$GAMMU_TEST_MESSAGE"

#Configuring Mariadb
echo "Configuring MariaDb"

mysql -e "CREATE USER IF NOT EXISTS 'smsd'@'localhsot' IDENTIFIED BY '$GAMMU_MYSQL_PASSWORD'"
mysql -e "GRANT USAGE ON *.* TO 'smsd'@'localhost' IDENTIFIED BY '$GAMMU_MYSQL_PASSWORD';"
mysql -e "GRANT SELECT, INSERT, UPDATE, DELETE ON \`smsd\`.* TO 'smsd'@'localhost';"
mysql -e "CREATE DATABASE IF NOT EXISTS smsd;"
mysql -e "FLUSH PRIVILEGES;"

#Configuring Gammu SMSD Configuration File
echo "Configuring Gammu-Smsd Configuration File"

echo "[gammu]
device= $GAMMU_DEVICE_PATH
connection = at115200

[smsd]
service = sql
driver = native_mysql
host = localhost
user = smsd
password = $GAMMU_MYSQL_PASSWORD
pc = localhost
database = smsd
CommTimeout=5
" > /etc/gammu-smsdrc

#Initialization of SMSD Database
echo "Initialization of SMSD Database"

mysql smsd < ./UTILS/2_SMSD_DATABASE.sql

#Restarting and Testing Gammu SMSD
echo "Restarting and Testing Gammu SMSD"

service gammu-smsd restart

gammu-smsd-inject TEXT $GAMMU_PHONE -len 1 -text "$GAMMU_TEST_MESSAGE"

##############################################################################################

# Installation of pm2 and deamonizing api

npm install pm2 -g

cd ./api
npm install
pm2 start index.js --name=sms-api
pm2 startup
pm2 save


##############################################################################################

# Api testing

curl http://localhost:3000/sms?phone=${phone}&message=API_OK


##############################################################################################
# Finished

echo "It's Finished ! - Rebooting"
reboot


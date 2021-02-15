#!/bin/bash

if [ `whoami` = 'root' ]
  then
    echo "Vous ne devez pas être utilisateur root pour executer ce script. Utilisez:"
    echo "sh ./install.sh"
    exit
fi

##############################################################################################

#### Checking Version

osversion=$(grep '^ID=' /etc/os-release | cut -c4-);

if [ $osversion = 'ubuntu' ]
  then 
    echo "Vous avez choisi Ubuntu comme système d'exploitation."

    sudo cp /boot/firmware/config.txt /boot/firmware/config-old.txt
    sudo cp /boot/firmware/cmdline.txt /boot/firmware/cmdline-old.txt

    #cp ./UTILS/ubuntu/config.txt /boot/firmware/config.txt
    #cp ./UTILS/ubuntu/cmdline.txt /boot/firmware/cmdline.txt

    sudo sed -i -e 's/console=serial0,115200//g' /boot/firmware/cmdline.txt

    echo "Changement des fichiers pour utiliser le module SMS OK !"

elif [ $osversion = 'raspbian' ]
  then
    echo "Vous avez choisi Raspberry Pi OS comme système d'exploitation."

    sudo cp /boot/config.txt /boot/config-old.txt
    sudo cp /boot/cmdline.txt /boot/cmdline-old.txt

    sudo cp ./UTILS/raspberry/config.txt /boot/config.txt
    #cp ./UTILS/raspberry/cmdline.txt /boot/cmdline.txt

    sudo sed -i -e 's/console=serial0,115200//g' /boot/cmdline.txt

    echo "Changement des fichiers pour utiliser le module SMS OK !"

else
  echo "Le Système d'exploitation n'a pas été reconnu... Aucune action n'a été effectuée..."
  exit
fi

##############################################################################################

GAMMU_TEST_MESSAGE="Tout fonctionne nickel depuis Gammu à $(date +%H h +%M)"
API_TEST_MESSAGE="API OK !"


echo "Quel est votre numero de telephone (Pour vérification) ? :"
read phone

GAMMU_PHONE=$phone


#echo "Quel est le chemin de l'appareil SMS ? :"
#read device_path
#GAMMU_DEVICE_PATH=$device_path
GAMMU_DEVICE_PATH="/dev/ttyS0"


#Update and Install Software
echo "Installing Primary Software"
#sudo apt-get update -y && sudo apt-get upgrade -y
sudo apt-get install -y vim curl git nodejs npm

#Install Gammu and Mysql 
echo "Installing Gammu and Sqlite DBI Drivers"
sudo apt-get install -y gammu gammu-smsd libdbd-sqlite3

#Configuring Cammu Configuration File
echo "Configuring gammurc"

echo "[gammu]
device= $GAMMU_DEVICE_PATH
connection = at115200" | sudo tee /etc/gammurc


#Configuring Gammu SMSD Configuration File
echo "Configuring Gammu-Smsd Configuration File"

echo "[gammu]
device= $GAMMU_DEVICE_PATH
connection = at115200

[smsd]
service = sql
driver = sqlite3
DBdir = $PWD/database
database = smsd.db
CommTimeout=5
logfile = $PWD/logfile.log
debuglevel = 255
" | sudo tee /etc/gammu-smsdrc

#Initialization of SMSD Database
echo "Initialization of SMSD Database"

sudo mysql smsd < ./utils/2_SMSD_DATABASE.sql

#Restarting and Testing Gammu SMSD
echo "Restarting and Testing Gammu SMSD"

sudo service gammu-smsd restart

sudo gammu-smsd-inject TEXT $GAMMU_PHONE -len 1 -text "$GAMMU_TEST_MESSAGE"

##############################################################################################

# Installation of pm2 and deamonizing api

sudo npm install pm2 -g

cd ./api
npm install
pm2 start index.js --name=sms-api
pm2 startup |  sed -ne '/sudo/,$ p' | sh
pm2 save

##############################################################################################

# Api testing

curl http://localhost:3000/sms?phone=${GAMMU_PHONE}&message=API+OK+!


##############################################################################################
# Finished
echo "It's Finished ! - Rebooting"
sudo reboot


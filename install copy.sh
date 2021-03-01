

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


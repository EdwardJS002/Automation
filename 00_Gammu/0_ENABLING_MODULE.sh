#!/bin/bash

if [ `whoami` != 'root' ]
  then
    echo "You must be root to do this."
    exit
fi

echo "Quel système d'exploitation avez vous choisi ?

1 - Ubuntu: l'unique, le vrai
2 - Raspberry Pi OS: l'alternative"
while :
do
  read INPUT_STRING
  case $INPUT_STRING in
	1)
		echo "Vous avez choisi Ubuntu"

mv /boot/firmware/config.txt /boot/firmware/config_old.txt
mv /boot/firmware/cmdline.txt /boot/firmware/cmdline_old.txt

cp ./UTILS/ubuntu/config.txt /boot/firmware/config.txt
cp ./UTILS/ubuntu/cmdline.txt /boot/firmware/cmdline.txt

echo "CHANGING FILE OK - REBOOTING"
wait 3
reboot

    break
		;;
	2)
		echo "Vous avez choisi Raspberry Pi OS"

mv /boot/config.txt /boot/config_old.txt
mv /boot/cmdline.txt /boot/cmdline_old.txt

cp ./UTILS/raspberry/config.txt /boot/config.txt
cp ./UTILS/raspberry/cmdline.txt /boot/cmdline.txt

echo "CHANGING FILE OK - REBOOTING"
wait 3
reboot

		break
		;;
	*)
		echo "Désolé, je ne comprends pas..."
    break
		;;
  esac
done
echo 
echo "Veuillez relancer le script."
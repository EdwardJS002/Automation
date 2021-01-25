#!/bin/bash

if [ `whoami` != 'root' ]
  then
    echo "You must be root to do this."
    exit
fi


####

osversion=$(grep '^ID=' /etc/os-release | cut -c4-);

echo $osversion

if [ $osversion == 'ubuntu' ]
  then 
    echo "Vous avez choisi Ubuntu"

    mv /boot/firmware/config.txt /boot/firmware/config_old.txt
    mv /boot/firmware/cmdline.txt /boot/firmware/cmdline_old.txt

    cp ./UTILS/ubuntu/config.txt /boot/firmware/config.txt
    cp ./UTILS/ubuntu/cmdline.txt /boot/firmware/cmdline.txt

    echo "CHANGING FILE OK - REBOOTING"
    wait 3
    reboot
    exit

elif [ $osversion == 'raspbian' ]
  then
    echo "Vous avez choisi Raspberry Pi OS"

    mv /boot/config.txt /boot/config_old.txt
    mv /boot/cmdline.txt /boot/cmdline_old.txt

    cp ./UTILS/raspberry/config.txt /boot/config.txt
    cp ./UTILS/raspberry/cmdline.txt /boot/cmdline.txt

    echo "CHANGING FILE OK - REBOOTING"
    wait 3
    reboot
    exit

else
  echo "Le Système d'exploitation n'a pas été reconnu... Aucune action n'a été effectuée..."
fi
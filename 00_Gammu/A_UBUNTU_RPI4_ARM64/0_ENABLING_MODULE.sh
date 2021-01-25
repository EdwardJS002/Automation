#!/bin/bash

if [ `whoami` != 'root' ]
  then
    echo "You must be root to do this."
    exit
fi

mv /boot/firmware/config.txt config_old.txt
mv /boot/firmware/cmdline.txt cmdline_old.txt

cp ./UTILS/config.txt /boot/firmware/config.txt
cp ./UTILS/cmdline.txt /boot/firmware/cmdline.txt

echo "CHANGING FILE OK - REBOOTING"
wait 3

reboot
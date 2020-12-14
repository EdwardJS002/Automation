#!/bin/bash

if [ `whoami` != 'root' ]
  then
    echo "You must be root to do this."
    exit
fi

apt-get update && apt-get upgrade
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
usermod -aG docker pi
rm get-docker.sh

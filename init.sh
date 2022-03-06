#!/bin/bash

BASEDIR=$(dirname "$0")
cd $BASEDIR

export VPN_USER=$1
export VPN_CODE=$2
export VPN_TYPE=$3
export VPN_COUNTRY=$4
export VPN_REFRESH_INTERVAL=${5:-300}
export VPN_SERVER_HOSTNAMES=$6
export VPN_PROTOCOL=${7:-udp}
keyRepo=$8
if test "$keyRepo" 
then
    sudo -sE rm -rf ./vpnFiles
    echo "Downloading key files from $keyRepo"
    sudo -sE git clone $keyRepo ./vpnFiles
    sudo -sE cp -R "./vpnFiles/$VPN_TYPE/." ./gluetun
fi
declare -p VPN_USER VPN_CODE VPN_TYPE VPN_COUNTRY VPN_SERVER_HOSTNAMES VPN_PROTOCOL VPN_REFRESH_INTERVAL > /usr/settings.sh
sudo -sE docker-compose build refresher
. ./run.sh test_vpn
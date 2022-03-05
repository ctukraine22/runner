#!/bin/sh

BASEDIR=$(dirname "$0")
cd $BASEDIR

export VPN_USER=$1
export VPN_CODE=$2
export VPN_TYPE=$3
export VPN_COUNTRY=$4
export VPN_SERVER_HOSTNAMES=$5
export VPN_PROTOCOL=${6:-udp}
keyRepo=$7
if test "$keyRepo" 
then
    sudo -sE rm -rf ./vpnFiles
    echo "Downloading key files from $keyRepo"
    sudo -sE git clone $keyRepo ./vpnFiles
    sudo -sE cp -R ./vpnFiles/$VPN_TYPE/. ./gluetun
fi
declare -p VPN_USER VPN_CODE VPN_TYPE VPN_COUNTRY VPN_SERVER_HOSTNAMES VPN_PROTOCOL > ./settings.sh
. ./run.sh test_vpn
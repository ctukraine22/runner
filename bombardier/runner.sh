#!/bin/sh

run()
{
    export VPN_CODE=$1
    export B_TARGET=$2
    for i in {1..60}
    do
        echo "Running $i time. $VPN_CODE $B_TARGET"
        sudo -E docker-compose up -d --force-recreate vpn 
        sleep 10s
        sudo -E docker-compose run test
        sudo -E docker-compose run bombardier
        echo "Executing..."
        sleep 60s
        sudo -E docker-compose down
    done
}
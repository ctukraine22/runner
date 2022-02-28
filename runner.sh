#!/bin/sh

run()
{
    export VPN_CODE=$1
    export B_TARGET=$2
    for i in {1..60}
    do
        echo "Running $i time. $VPN_CODE $B_TARGET"
        target=$1
        sudo docker-compose up -d --force-recreate
        echo "Sleeping"
        sleep 60s
        sudo docker-compose down
    done
}
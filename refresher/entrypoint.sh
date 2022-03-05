#!/bin/bash

echo "Refresher started"
while true
do
    echo "Waiting ${1:-300} seconds";
    sleep "${1:-300}s"
    echo ""
    curl http://0.0.0.0:8000/openvpn/actions/restart
    curl --connect-timeout 5 -m 5 --retry 5 ipinfo.io
    echo "$(date)"
done
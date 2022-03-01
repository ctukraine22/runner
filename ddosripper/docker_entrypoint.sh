#!/bin/bash

HOSTNAME=$1
PORT=$2
IP=$(dig +short "$HOSTNAME"| tail -n 1)
python3 -u DRipper.py -s "$IP" -t 135 -p $PORT
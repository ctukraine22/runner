#!/bin/bash

IP=$1
PORT=$2
echo "Running: python3 -u DRipper.py -s \"$IP\" -t 135 -p $PORT"
python3 -u DRipper.py -s "$IP" -t 135 -p $PORT
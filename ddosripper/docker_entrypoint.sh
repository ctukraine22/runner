#!/bin/bash

IP=$1
PORT=$2
python3 -u DRipper.py -s "$IP" -t 135 -p $PORT
#!/bin/bash
apt update
apt install python3-pip

pip3 install -r requirements.txt 

sleep 5

echo "done" >> /opt/.backgroundfinished
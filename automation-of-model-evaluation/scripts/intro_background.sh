#!/bin/bash
apt update 
apt -y install python3-pip

yes | pip3 install -U -r requirements.txt 

sleep 5

echo "done" >> /opt/.backgroundfinished
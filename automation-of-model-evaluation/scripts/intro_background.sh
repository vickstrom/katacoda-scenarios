#!/bin/bash
apt update 
apt -y install python3-pip

echo "done" >> /opt/.pipdep

yes | pip3 install -U tensorflow 
yes | pip3 install -U cryptography 
yes | pip3 install -U numpy 

echo "done" >> /opt/.packages
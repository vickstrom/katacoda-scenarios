echo "Setting up your enviroment. Please wait."; while [ ! -f /opt/.backgroundfinished ] ; 
do sleep 2; done; echo "Installation Completed."

echo "The IP address for this environment is [[HOST_IP]]"
echo "Which means that your final endpoint will be [[HOST_IP]]:1337/mlops-server"
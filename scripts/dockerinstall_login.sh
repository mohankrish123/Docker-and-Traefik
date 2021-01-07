#!/bin/bash
if [ -x "$(command -v docker)" ]; then
    echo "Update docker"
else
    echo "Install docker"

    apt-get install apt-transport-https ca-certificates curl gnupg2 software-properties-common sudo

    curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg | sudo apt-key add -

    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") $(lsb_release -cs) stable"

    apt-get update -y

    apt-get install docker-ce -y

    curl -L https://github.com/docker/compose/releases/download/1.19.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose

    chmod +x /usr/local/bin/docker-compose

    docker-compose --version

fi

sudo usermod -aG docker $USER
a=$(date "+%d-%m-%Y:%H.%M.%S")
sudo chown -R $USER:$USER /home/$USER/.docker/

if [[ $(ls /home/$USER/.docker/) = "config.json" ]]; then

	sudo mv /home/$USER/.docker/config.json /home/$USER/.docker/config.json.bak.$a
else 

echo "$(tput setaf 1)$(tput setab 7) $(echo -e "\x1b[1m CONNECTING TO DOCKER REPOSITORY")$(tput sgr 0)"
for ((x = 1; x <= 3; x++)); do

        read -p $'Enter the username:\n' a
        read -s -p $'Enter the password:\n' b
        c= sudo docker login dockerhub.kensium.com --username=$a --password="$b"

        if [ "$?" -eq "0" ]; then
        break
        else
                echo "Login failed $x time/times. Please re-run the script file with correct LDAP credentials if the login failed for 3 times."
        fi
done
fi


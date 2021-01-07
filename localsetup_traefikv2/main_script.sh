#!/bin/bash

set -e

#Variables
DATE="$(date '+%d-%m-%Y-%Hhrs%Mmins%Ssecs')"
DBDUMPFILE="xxxxx_stg_db_backup_29OCT2020.sql.gz"
DBIMPORT="zcat $DBDUMPFILE | sed -e 's/DEFINER[ ]*=[ ]*[^*]*\*/\*/' | mysql -h localhost -u magento -pdoken1um magento -A"
RM="rm -rf"

#Installation of Docker & Docker-Compose
echo "$(tput setaf 1)$(tput setab 7) $(echo -e '\x1b[1m INSTALLING DOCKER & DOCKER-COMPOSE ON YOUR SYSTEM')$(tput sgr 0)"

if [ -x "$(command -v docker)" ] && [ -x "$(command -v docker-compose)" ]; then
        echo "DOCKER ALREADY INSTALLED"
else
        sudo sh install_docker.sh
fi
echo ""
echo ""

#Set sudo user permission for docker
echo "$(tput setaf 1)$(tput setab 7) $(echo -e "\x1b[1m SETTING USER PERMISSION TO RUN DOCKER COMMANDS")$(tput sgr 0)"
sudo chmod 666 /var/run/docker.sock
echo ""
echo ""

#Docker-Hub login with credentials
echo "$(tput setaf 1)$(tput setab 7) $(echo -e "\x1b[1m CONNECTING TO DOCKER REPOSITORY")$(tput sgr 0)"
echo ""
for ((x = 1; x <= 3; x++)); do

        echo "$(tput setaf 1)$(tput setab 7) $(echo -e "\x1b[1m ENTER YOUR LDAP CREDENTIALS")$(tput sgr 0)"
        read -p $'Enter the username:\n' a
        read -s -p $'Enter the password:\n' b

        if [ -d "$HOME/.docker" ]; then
            $RM $HOME/.docker 
            echo "REMOVING EXISTING DOCKER CREDENTIALS AND RUNNING DOCKER LOGIN"
            docker login dockerhub.*****.com -u $a -p $b
        else
            echo "DOCKER CREDENTIALS DOESN'T EXIST AND RUNNING DOCKER LOGIN"
            docker login dockerhub.*****.com -u $a -p $b
 
        fi

	if [ "$?" -eq "0" ]; then
        break
        else
                echo "Login failed $x time/times. Please re-run the script file with correct LDAP credentials if the login failed for 3 times."
        fi
done

#Download the image & bring up the container
echo "$(tput setaf 1)$(tput setab 7) $(echo -e "\x1b[1m DOWNLOADING THE IMAGE FROM DOCKER HUB AND CREATING THE ENVIRONMENT")$(tput sgr 0)"
if [ -z $(docker ps -q --filter "name=xxxxx") ]; then
       docker-compose up -d
else
       docker rm -f xxxxx && docker-compose up -d
fi
echo ""
echo ""

#Findout the ip to add it into /etc/hosts
PVTIP=$(ip route get 8.8.8.8 | sed -n '/src/{s/.*src *\([^ ]*\).*/\1/p;q}')
PUBIP=$(curl ifconfig.me)
echo ""
echo "$(tput setaf 1)$(tput setab 7) $(echo -e "\x1b[1m TO ACCESS DOMAIN NAME devops.xxxxx.com, PLEASE ADD THE BELOW LINE IN YOUR HOST FILE")$(tput sgr 0)"

echo "$(tput setaf 1)$(tput setab 7) $(echo -e "\x1b[1m ENTRY FOR THE PRIVATE IP ADDRESS")$(tput sgr 0)"
echo "$PVTIP devops.xxxxx.com"

echo ""
echo ""
echo "$(tput setaf 1)$(tput setab 7) $(echo -e "\x1b[1m ENTRY FOR PUBLIC IP ADDRESS")$(tput sgr 0)"
echo $PUBIP devops.xxxxx.com
echo ""
echo ""

#Cloning the project code
if [ -z "$(ls -A $PWD/code/)" ]; then
        echo "$(tput setaf 1)$(tput setab 7) $(echo -e "\x1b[1m THE CODE FOLDER IS EMPTY AND CLONING THE PROJECT CODE")$(tput sgr 0)" && sudo chown -R $USER:$USER ./code && git clone git@gitlab.*****.com:kensiumgitlab/localsetup-xxxxx.git ./code
else
	echo "$(tput setaf 1)$(tput setab 7) $(echo -e "\x1b[1m THE CODE FOLDER IS NON-EMPTY AND TAKING A BACKUP OF IT")$(tput sgr 0)" 
	sudo chown -R $USER:$USER ./code
       	mv ./code code_backup && mv code_backup code_$DATE 
       	git clone git@gitlab.*****.com:kensiumgitlab/localsetup-xxxxx.git ./code
fi

$RM ./code/.git
echo ""
echo ""

#Downloading the staging DB
echo "$(tput setaf 1)$(tput setab 7) $(echo -e "\x1b[1m DOWNLOADING THE DB BACKUP FILE")$(tput sgr 0)"
wget -O ./code/$DBDUMPFILE --user devops --password='Dbken$1um20' https://databases.******.tk:8443/$DBDUMPFILE
echo ""
echo ""

#Importing the database
echo "$(tput setaf 1)$(tput setab 7) $(echo -e "\x1b[1m IMPORTING THE DB")$(tput sgr 0)"
docker exec xxxxx sh -c "cd /var/www/html && $DBIMPORT"
docker exec xxxxx mysql -h localhost -u magento -pdoken1um magento -e 'update core_config_data set value="http://devops.xxxxx.com/" where config_id in (2,3,41,43,45,47,49,51,53,55,57,59);'
docker exec xxxxx mysql -h localhost -u magento -pdoken1um magento -e 'update core_config_data set value="0" where config_id in (214032,214033,214026);'
echo ""
echo ""

#Copying all the required files to code
cp files/composer.json code/html/composer.json
cp files/composer.lock code/html/composer.lock
cp files/config.php code/html/app/etc/config.php
cp files/env.php code/html/app/etc/env.php
cp files/be_ixf_client.php code/html/be_ixf_client.php

#Executing script
echo "$(tput setaf 1)$(tput setab 7) $(echo -e "\x1b[1m RUNNING COMPOSER INSTALL AND MAGENTO COMMANDS")$(tput sgr 0)"
sh startup.sh

#Set permissions for the nginx user in the container
echo "$(tput setaf 1)$(tput setab 7) $(echo -e "\x1b[1m SETTING PERMISSIONS INSIDE THE CONTAINER")$(tput sgr 0)"
docker exec -it xxxxx sh -c "chown -R nginx:nginx /var/www/html/"

echo ""
echo ""
echo "$(tput setaf 1)$(tput setab 7) $(echo -e "\x1b[1m YOUR DOCKER ENVIRONMENT IS READY TO USE")$(tput sgr 0)"



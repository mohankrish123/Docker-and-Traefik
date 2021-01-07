#Download the image & bring up the container
echo "$(tput setaf 1)$(tput setab 7) $(echo -e "\x1b[1m DOWNLOADING THE MAGENTO 2.2.5 IMAGE FROM DOCKER HUB")$(tput sgr 0)"
sudo docker-compose up -d

#Findout the ip to add it into /etc/hosts
PVTIP=$(ip route get 8.8.8.8 | sed -n '/src/{s/.*src *\([^ ]*\).*/\1/p;q}')
PUBIP=$(curl ifconfig.me)
echo ""
echo "$(tput setaf 1)$(tput setab 7) $(echo -e "\x1b[1m TO ACCESS DOMAIN NAME devops.tupperware.com, PLEASE ADD THE BELOW LINE IN YOUR HOST FILE")$(tput sgr 0)"
echo ""
echo "$(tput setaf 1)$(tput setab 7) $(echo -e "\x1b[1m Entry for Private IP Address")$(tput sgr 0)"
echo $PVTIP devops.tupperware.com

echo ""
echo ""
echo "$(tput setaf 1)$(tput setab 7) $(echo -e "\x1b[1m Entry for Public IP Address")$(tput sgr 0)"
echo $PUBIP devops.tupperware.com
echo ""

sudo docker cp tupperware_c_localsetup:/home/tupperware_container_code_backup.tar.gz ./tupperware_local/
cd ./tupperware_local/ && sudo tar -xvf tupperware_container_code_backup.tar.gz
sudo rm -rf tupperware_container_code_backup.tar.gz


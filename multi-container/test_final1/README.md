#MULTI SINGLE CONTAINER WITH TRAEFIK#

# Traefik: 
- Before doing below steps we need start traefik container, it will map 80 port to assigned traefik lables which we are mentioned in
docker-compose.yml file. 
Traefik Doamin Name: traefik.local.com

# Project
- Tupperware(2.3.1) and Parkingzone (2.3.3)

# Software versions
- Ubuntu 18.04

# Domain name assigned: 
- devops.tupperware.com for tupperware project and devops.parkingzone.com for parkingzone project. 

# Root folder
- /var/www/html/ for both projects.

# Database Details for tupperware project
    - Version: 5.7
    - Database name: magento
    - user: magento
    - password: magento
    - Please change the base URLs to devops.tupperware.com in database if you import with the DB backup.

# Database Details for parkingzone project
    - Version: 5.7
    - Database name: magento233
    - user: magento233
    - password: magento233
    - Please change the base URLs to devops.parkingzone.com in database if you import with the DB backup.
   
# Magento details for tupperware project:
    - Admin crendentials: [Username: devops, Password: Doken$1um123]

# Magento details for tupperware project:
    - Admin crendentials: [Username: devops, Password: Doken$1um123]

# Things to note:
- I have created two docker-compose.yml files with different traefik lables that lables includes domains, below are the lables which are mentioned in 
  docker-compose.yml files.

  * For Tupperware:
    --> labels:
       - traefik.enable=true
       - traefik.frontend.rule=Host:devops.tupperware.com
       - traefik.port=8080
       - traefik.docker.network=web
 
  * For Parkingzone:
     --> labels:
       - traefik.enable=true
       - traefik.frontend.rule=Host:devops.parkingzone.com
       - traefik.port=8090
       - traefik.docker.network=web 
   
# Things to be performed by developer:
- Run the traffic compose file
$ docker-compose traffic.yaml
- The main script needs to be executed first to start the process, use the below command, it will ask your LDAP credentials to connect to dockerhub.kensium.com,
$ ./main_script.sh
- Please perform netstat -tlpn and make sure if all the services are up and running. (Services include mysql, nginx, php7.1-fpm, elasticsearch). Please start the service manually if the service isn't running.
- The mount point assigned is project_local. This points to /var/www/html/ directory of the docker container. To run commands inside the container from your localhost, please follow this syntax:
$ docker exec <container id or container name> /bin/bash -c '<command that has to be performed>'

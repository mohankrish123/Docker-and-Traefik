FROM ubuntu:18.04
RUN apt update &&  apt install -y net-tools vim software-properties-common && add-apt-repository ppa:ondrej/php
## for apt to be noninteractive
ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true
RUN apt-get update && apt-get install php7.2 -y 
RUN apt-get install -y php7.2-enchant php7.2-mbstring php7.2-snmp php7.2-bcmath php7.2-fpm php7.2-mysql php7.2-soap php7.2-bz2 php7.2-gd php7.2-odbc php7.2-sqlite3 php7.2-cgi php7.2-gmp php7.2-opcache php7.2-cli php7.2-imap php7.2-pgsql php7.2-tidy php7.2-common php7.2-interbase php7.2-phpdbg php7.2-xml php7.2-curl php7.2-intl php7.2-pspell php7.2-xmlrpc php7.2-dba php7.2-json php7.2-readline php7.2-xsl php7.2-dev php7.2-ldap php7.2-recode php7.2-zip
COPY www.conf /etc/php/7.2/fpm/pool.d
COPY service.sh /tmp/service.sh
EXPOSE 9000
RUN mkdir /run/php && chown -R www-data:www-data /run/php && export PATH=$PATH:/usr/sbin/php-fpm7.2:/etc/init.d
#ENTRYPOINT ["/bin/bash";"-c";"service php7.2-fpm start"]
CMD /bin/bash /tmp/service.sh

FROM nginx:latest
RUN apt update && apt install -y net-tools curl vim iputils-ping
COPY default.conf /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/nginx.conf
COPY script.sh /tmp/script.sh
CMD /bin/bash /tmp/script.sh

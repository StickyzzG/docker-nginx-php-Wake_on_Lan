FROM alpine:latest

RUN apk update && apk upgrade
RUN apk add bash
RUN apk add nginx
RUN apk add php81 php81-fpm php81-opcache
RUN apk add php81-gd php81-zlib php81-curl php81-sockets

# uncomment below if you want to use --network host mode on this container, 
# to still be able to ssh into host
#RUN sed -i 's/\(^Port\)/#\1/' /etc/ssh/sshd_config && echo Port 2233 >> /etc/ssh/sshd_config

COPY server/etc/nginx /etc/nginx
COPY server/etc/php /etc/php81
COPY src /usr/share/nginx/html

RUN mkdir /var/run/php
EXPOSE 80
EXPOSE 443

STOPSIGNAL SIGTERM

CMD ["/bin/bash", "-c", "php-fpm81 && chmod 777 /var/run/php/php8-fpm.sock && chmod 777 /usr/share/nginx/html && chmod 755 /usr/share/nginx/html/* && nginx -g 'daemon off;'"]

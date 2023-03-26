FROM alpine:latest

RUN apk update && apk upgrade
RUN apk add bash
RUN apk add nginx
RUN apk add php81 php81-fpm php81-opcache
RUN apk add php81-gd php81-zlib php81-curl php81-sockets

COPY server/etc/nginx /etc/nginx
COPY server/etc/php /etc/php81
COPY src /usr/share/nginx/html

RUN mkdir /var/run/php
EXPOSE 80
EXPOSE 443

STOPSIGNAL SIGTERM

CMD ["/bin/bash", "-c", "php-fpm81 && chmod 777 /var/run/php/php8-fpm.sock && chmod 755 /usr/share/nginx/html/* && nginx -g 'daemon off;'"]

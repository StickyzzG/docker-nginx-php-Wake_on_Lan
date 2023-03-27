# docker-nginx-php-Wake_on_Lan

This is a docker made to run a simple nginx-php container.
It contains a php file to run a simple Wake on lan tool.

![Wake-On_Lan Screenshot](wake-on-lan.png "wake-on-lan screenshot")

I made the combination of 3 projects to make this.

All info about the php file you can find here:
https://github.com/AndiSHFR/wake-on-lan.php

The base for building this Dockerfile got from here:
https://github.com/johnathanesanders/docker-nginx-fpm

He even got a whole article about it:
https://levelup.gitconnected.com/containerizing-nginx-php-fpm-on-alpine-linux-953430ea6dbc

The last part is a script so you can send wake on lan magic packets from within a docker container
to you host network

info was found here:
https://www.devwithimagination.com/2020/06/15/homebridge-docker-and-wake-on-lan/
and is used his script found here and adjusted a bit:
https://github.com/dhutchison/container-images/blob/master/homebridge/configure_docker_networks_for_wol.sh

So all credits to these guys, i just made the combination.

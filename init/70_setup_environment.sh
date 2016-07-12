#!/bin/bash

mkdir -p /config/rtorrent/session /config/rutorrent /config/nginx
mkdir -p /data/downloading /data/complete /data/watch

[[ ! -f /config/rtorrent/rtorrent.rc ]] && cp /defaults/rtorrent.rc /config/rtorrent/rtorrent.rc
[[ ! -f /config/rutorrent/config.php ]] && cp /defaults/config.php /config/rutorrent/config.php
[[ ! -f /config/nginx/nginx.conf ]] && cp /defaults/nginx.conf /config/nginx/nginx.conf
[[ ! -f /config/nginx/php-fpm.conf ]] && cp /defaults/php-fpm.conf /config/nginx/php-fpm.conf

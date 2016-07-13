#!/bin/bash

# Default config for rtorrent
if [[ ! -d /config/rtorrent ]] ; then
    mkdir -p /config/rtorrent/session
    cp -v /defaults/rtorrent.rc /config/rtorrent/rtorrent.rc
fi

# Default config for rutorrent
if [[ ! -d /config/rutorrent ]] ; then 
    cp -rv /defaults/rutorrent /config/rutorrent
fi

# Enable only selected rutorrent plugins
echo "Disabling all plugins"
rm -f /ruTorrent/plugins/*
echo "Enabling only selected plugins: $RUTORRENT_PLUGINS"
for P in $RUTORRENT_PLUGINS ; do
    ln -sv /ruTorrent/plugins-available/$P /ruTorrent/plugins/$P
done

# Default config for nginx, php-fpm
if [[ ! -d /config/nginx ]] ; then
    mkdir -p /config/nginx
    cp -v /defaults/nginx.conf /config/nginx/nginx.conf
    cp -v /defaults/php-fpm.conf /config/nginx/php-fpm.conf
fi

# Make sure correct permissions exist for config
chown -Rv abc:abc /config

# Make sure data directories exist
(umask 0002 && /sbin/setuser abc mkdir -p /data/downloading /data/complete /data/watch)

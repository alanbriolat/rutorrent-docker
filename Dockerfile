# Stick to latest version based on 14.04 to simplify PHP 5 dependency
FROM phusion/baseimage:0.9.18
ENV DEBIAN_FRONTEND="noninteractive" HOME="/root" TERM="xterm"

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

RUN apt-get update && \
    apt-get install -y dtach rtorrent php5-fpm php5-cli unrar unzip wget nginx inotify-tools && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Create user/group that will be used to match host UID/GID for permissions on volumes
# (taken from linuxserver/docker-baseimage)
RUN useradd -u 911 -U -d /config -s /bin/false abc && \
    usermod -G users abc

ADD ruTorrent /ruTorrent/
RUN rm /ruTorrent/conf/config.php && \
    ln -sv /config/rutorrent/config.php /ruTorrent/conf/config.php && \
    rm -r /ruTorrent/share && \
    ln -sv /config/rutorrent/share /ruTorrent/share

# Move all the plugins out of the way, only enable the ones that were selected
ENV RUTORRENT_PLUGINS="autotools data datadir erasedata _getdir rpc rss scheduler seedingtime tracklabels"
RUN mv /ruTorrent/plugins /ruTorrent/plugins-available && \
    mkdir -p /ruTorrent/plugins
# (enabling plugins performed by init/70_setup_environment.sh)

ADD defaults/ /defaults/
ADD init/ /etc/my_init.d/
ADD services /etc/service/
RUN chmod -v +x /etc/service/*/run /etc/my_init.d/*.sh

EXPOSE 80 36890-36899
VOLUME /config /data

# alanbriolat/rutorrent

rTorrent and ruTorrent wrapped up as a single stateless docker container. Based heavily on the work
of [linuxserver/docker-rutorrent](https://github.com/linuxserver/docker-rutorrent) but adapted to my
own preferences. Major differences include:

* No auto-updating of ruTorrent
* `autotools` plugin configured by default for watch directory and hardlink copy of completed torrents

## Usage

The Docker image can be built by executing `make` (as a user with Docker permissions).

To run the client, provision a `config` and `data` directory and use the following:
```
docker run --rm  \
    -v <path to config>:/config  \
    -v <path to data>:/data  \
    -p 8080:80  \
    -p 36890-36899  \
    -e PUID=$(id -u <username>)  \
    -e PGID=$(getent group <groupname> | cut -d: -f3)  \
    alanbriolat/rutorrent:3.7-0.9.2-0
```

All state is encompassed by the `/config` and `/data` volumes, so it's safe to remove and recreate
the container rather than persisting it.

### Ports

* `-p 80` - HTTP for ruTorrent frontend
* `-p 36890-36899` - incoming torrent connections


### Volumes

* `-v /config` - service, client and frontend configuration/state
* `-v /data` - storage for `downloading` and `complete` torrents, plus a `watch` folder

### User / Group Identifiers

To avoid permission issues on volumes, the UID and GID that rTorrent/ruTorrent operate under can be
set explicitly. Ideally these should be the owner of the directory mounted as the `/data` volume.

* `-e PUID=...` - user ID for rTorrent/ruTorrent
* `-e PGID=...` - group ID for rTorrent/ruTorrent
* `-e RUTORRENT_PLUGINS="..."` - a space-separated list of ruTorrent plugins to load (default: 
  `autotools data datadir erasedata _getdir rpc rss scheduler seedingtime tracklabels`)

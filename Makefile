NAME = alanbriolat/rutorrent
RTORRENT_VERSION = 0.9.2
RUTORRENT_VERSION = 3.7
REVISION = 0

.PHONY: all build

all: build

build:
	docker build -t $(NAME):$(RUTORRENT_VERSION)-$(RTORRENT_VERSION)-$(REVISION) .

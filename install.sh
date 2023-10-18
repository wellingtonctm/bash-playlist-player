#!/bin/bash

if [[ $EUID -ne 0 ]]; then
	sudo $0
	exit $?;
fi

mkdir -p /opt/bash-playlist-player/ &&
cp main /opt/bash-playlist-player/ &&

if [[ -f /usr/local/bin/bash-playlist-player ]]; then
	rm -rf /usr/local/bin/bash-playlist-player
fi &&

ln -s /opt/bash-playlist-player/main /usr/local/bin/bash-playlist-player &&

echo "Bash Playlist Player instalado!" &&

exit 0
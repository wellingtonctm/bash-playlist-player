#!/bin/bash

if [[ $EUID -ne 0 ]]; then
	sudo $0
	exit $?;
fi

rm -f /usr/local/bin/bash-playlist-player;
rm -r /opt/bash-playlist-player/;

echo "Bash Playlist Player desinstalado!";

exit 0;
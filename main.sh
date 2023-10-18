#!/bin/bash

playlist_url="https://music.youtube.com/playlist?list=PLvNMtvKKQEsU65X5LFdvvia9h7QfqE9XI"

song_pid_file='song.pid'
keys_pid_file='keys.pid'

. songs.sh
. play.sh
. keys.sh
. trap.sh

for song in "${songs[@]}"; do
    if pidof mpv &>/dev/null; then
        killall mpv
    fi

    play_song "$song"
done

echo "All songs have been played."
exit 0
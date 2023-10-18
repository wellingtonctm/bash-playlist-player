#!/bin/bash

main_pid_file='main.pid'

if [[ -f $main_pid_file ]] && kill -0 $(cat $main_pid_file) &> /dev/null; then
    echo "Já existe uma instância em execução ($(cat $main_pid_file))."
    exit 1
fi

echo $$ > $main_pid_file

playlist_url="https://music.youtube.com/playlist?list=PLvNMtvKKQEsU65X5LFdvvia9h7QfqE9XI"

if [[ $1 != "" ]]; then
    playlist_url="$1"
fi

song_info_file="song.info"
song_pid_file='song.pid'
keys_pid_file='keys.pid'

. songs.sh
. play.sh
. keys.sh
. trap.sh

for song in "${songs[@]}"; do
    play_song "$song"
done

echo "All songs have been played."
exit 0
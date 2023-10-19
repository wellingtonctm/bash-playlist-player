#!/bin/bash

app_title='Bash Playlist Player'
base_dir=$(dirname "$(readlink -f "$(which "$0")")")

main_pid_file="$base_dir/main.pid"

if [[ -f $main_pid_file ]] && kill -0 $(cat $main_pid_file) &> /dev/null; then
    echo "Já existe uma instância em execução ($(cat $main_pid_file))."
    exit 1
fi

options_file="$base_dir/options.conf"
song_info_file="$base_dir/song.info"
song_pid_file="$base_dir/song.pid"
keys_pid_file="$base_dir/keys.pid"

. trap.sh

echo $$ > $main_pid_file

. choose.sh

if [[ $1 == "" ]]; then
    playlist_url="$(choose-playlist)"
else
    playlist_url="$1"
fi

if [[ $playlist_url == "" ]]; then
    exit 1
fi

. songs.sh
. play.sh
. keys.sh
. trap.sh

for song in "${songs[@]}"; do
    play_song "$song"
done

echo "All songs have been played."
exit 0
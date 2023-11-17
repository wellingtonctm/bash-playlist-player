#!/bin/bash

app_title='Bash Playlist Player'
base_dir=$(dirname "$(readlink -f "$(which "$0")")")
pids_dir="/var/run/user/$(id -u)/bash-playlist-player"
conf_dir="$(getent passwd "$(logname)" | cut -d: -f6)/.config/bash-playlist-player"

if [[ ! -d "$pids_dir" ]]; then
    mkdir -p "$pids_dir"
fi

if [[ ! -d "$conf_dir" ]]; then
    mkdir -p "$conf_dir"
fi

main_pid_file="$pids_dir/main.pid"

if [[ -f $main_pid_file ]] && kill -0 $(cat $main_pid_file) &> /dev/null; then
    echo "There is an instance already running ($(cat $main_pid_file))."
    exit 1
fi

echo $$ > $main_pid_file

options_file="$conf_dir/options.conf"
song_info_file="$conf_dir/song.info"
song_pid_file="$pids_dir/song.pid"
keys_pid_file="$pids_dir/keys.pid"
playlists_dir="$conf_dir/.playlists"
notification_file="$pids_dir/notify.pid"

mkdir -p "$playlists_dir"

. trap.sh
. songs.sh
. shuffle.sh
. play.sh
. keys.sh
. choose.sh

if [[ $1 == "" ]]; then
    playlist_id="$(choose-playlist)"
else
    playlist_id="$1"
fi

if [[ $playlist_id == "" ]]; then
    exit 1
fi

get-songs
shuffle
start-keys

for index in "${!songs[@]}"; do
    play_song "$index"
done

echo "All songs have been played."
exit 0
#!/bin/bash

## Get ID's from YT Music:
# Array.from(document.querySelectorAll('#contents a[href*="&list="]')).reduce((str, item) => str + "\n" + item.href.match(/youtube.com\/watch\?v\=(?<id>[^&]+)/).groups.id, '')

song_pid_file='song.pid';

# Define the songs to play
. playlist.sh

# Shuffle the array using the Fisher-Yates shuffle algorithm
for i in "${!songs[@]}"; do
    j=$((RANDOM % (i+1)))
    tmp="${songs[i]}"
    songs[i]="${songs[j]}"
    songs[j]="$tmp"
done

# Define the function to clean up on exit or interrupt
cleanup() {
    echo "Cleaning up and exiting..."
    kill -0 "$(cat $song_pid_file)" &> /dev/null && kill $(cat $song_pid_file)
    
    for pid in ${pids[@]}; do
        kill $pid 2> /dev/null;
    done;

    exit 1
}

# Set the trap to call the cleanup function on exit or interrupt
trap 'cleanup' INT

# Function to play a song
function play_song() {
    # Get the video link and title using youtube-dl
    #echo "Searching for: $1"
	video_info=$(yt-dlp -f 'bestaudio' --get-url --print "%(title)s - %(artist)s" "https://youtube.com/watch?v=$1")

	# Split the video_info string into title and youtube_link variables
	IFS=$'\n' read -d '' title youtube_link <<< "$video_info"

    # Play the song using mpv
    echo "Playing: $title"
    mpv --no-terminal --no-video --no-cache $youtube_link &
    song_pid=$!
    echo $song_pid > $song_pid_file

    while kill -0 "$song_pid" &> /dev/null; do
        sleep 1s;
    done;

    echo ""
    return 0
}

function main() {
    # Loop through the songs and play them
    for song in "${songs[@]}"; do
        # Check if a song is already playing
        if [[ $(pgrep mpv) ]]; then
            echo "Skipping $song, another song is currently playing."
            continue
        fi

        # Play the song
        play_song "$song"
    done

    echo "All songs have been played."
    return 0;
}

function keys() {
    xinput test-xi2 --root 3 | gawk '/RawKeyRelease/ {getline; getline; print $2; fflush()}' | \
    while read -r key; do
        if [[ $key == 208 ]]; then
            kill -0 "$(cat $song_pid_file)" &> /dev/null && kill -CONT $(cat $song_pid_file)
            echo "Resumed"
        elif [[ $key == 209 ]]; then
            kill -0 "$(cat $song_pid_file)" &> /dev/null && kill -STOP $(cat $song_pid_file)
            echo "Paused"
        elif [[ $key == 171 ]]; then
            kill -0 "$(cat $song_pid_file)" &> /dev/null && kill $(cat $song_pid_file)
            echo "Skipped"
        fi;
    done;
}

keys &
keys_pid=$!

pids=( $(pstree -p $keys_pid | grep -o '([0-9]\+)' | grep -o '[0-9]\+') )

main

for pid in ${pids[@]}; do
    kill $pid 2> /dev/null;
done;

exit 0
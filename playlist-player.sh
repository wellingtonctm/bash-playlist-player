#!/bin/bash

## Get ID's from YT Music:
#Array.from(document.querySelectorAll("ol[aria-label='Track list'] li")).reduce((arr, item) => [...arr, item.innerText.match('^[^\n]*\n(?<teste>[^\n]*\n[^\n]*)').groups.teste], [])

#window.open('https://music.youtube.com/search?q=' + 'song+' + temp1[i++].replace(/\n/g, ' - ').replace(/[^A-Za-z0-9- ]/g, '+'), '_blank')

# Array.from(document.querySelectorAll('#contents a[href*="&list="]')).reduce((str, item) => str + "\n" + item.href.match(/youtube.com\/watch\?v\=(?<id>[^&]+)/).groups.id, '')

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
    kill -0 "$song_pid" &> /dev/null && kill $song_pid
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

    # Wait for the song to finish playing or the user to press 'n' or 'space'
    while kill -0 "$song_pid" &> /dev/null; do
        read -n 1 -s -r -t 1 skip_song

        if [[ $skip_song == "n" ]]; then
            kill $song_pid
	    break
        elif [[ $skip_song == "p" ]]; then
            echo "Paused"
            kill -STOP $song_pid
            read -n 1 -s -r -p ""
            echo -e "Resumed"
            kill -CONT $song_pid
        fi
    done

    echo ""
    return 0
}

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

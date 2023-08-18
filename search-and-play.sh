#!/bin/bash

# Define the function to clean up on exit or interrupt
cleanup() {
    echo ""
    echo "Cleaning up and exiting..."
    kill -0 "$song_pid" &> /dev/null && (
        processes=$(ps --ppid $song_pid | awk '/[0-9]+/{printf("%s ", $1)}')
        kill -9 $processes
        wait $processes
    )
    exit 1
}

# Set the trap to call the cleanup function on exit or interrupt
trap 'cleanup' INT

while true; do
    # Read search terms from user input
    read -p "Enter search terms: " search_terms

    # Get the video link and title using youtube-dl
    video_info=$(youtube-dl -f "bestvideo[height<=1080,ext=mp4]+bestaudio[ext=m4a]" --get-url --get-title "ytsearch:$search_terms")

    # Split the video_info string into link and title variables
    IFS=$'\n' read -d '' title link1 link2 <<< "$video_info"

    # Print the link and title
    echo "Playing: $title"

    (
        ffmpeg -loglevel quiet -i $link1 -i $link2 -f matroska - | mpv --no-terminal --no-cache -
    ) &

    song_pid=$!
    echo "PID: $song_pid"

    # Wait for the song to finish playing or the user to press 'n' or 'space'
    while kill -0 "$song_pid" &> /dev/null; do
        read -n 1 -s -r -t 1 skip_song

        if [[ $skip_song == "n" ]]; then
            processes=$(ps --ppid $song_pid | awk '/[0-9]+/{printf("%s ", $1)}')
            kill $processes$song_pid &> /dev/null
            break
        elif [[ $skip_song == "p" ]]; then
            echo "Paused"
            kill -STOP $song_pid
            read -n 1 -s -r -p ""
            echo "Resumed"
            kill -CONT $song_pid
        fi
    done

    echo ""
done

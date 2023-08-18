#!/bin/bash

# Function to clean up on exit or interrupt
cleanup() {
	echo "Exiting..."
	exit 0
}

# Set the trap to call the cleanup function on exit or interrupt
trap 'cleanup' EXIT INT

# Read search terms from user input
read -p "Enter search terms: " search_terms

# Get the video link and title using youtube-dl
video_info=$(youtube-dl -f 'bestaudio' --get-url --get-title "ytsearch:$search_terms")

# Split the video_info string into link and title variables
IFS=$'\n'
read -d '' title link <<< "$video_info"

# Print the link and title
echo "Title: $title"
echo "Link: $link"

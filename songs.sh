if [[ $playlist_url == "" ]]; then
    playlist_url=$(zenity --entry --title "Bash Playlist Player" --text "Playlist URL:")
fi

songs=( $(yt-dlp --skip-download --get-id --flat-playlist $playlist_url) )

if [[ $? != 0 ]]; then
    zenity --error --title "Bash Playlist Player" --text "There was an error while processing the URL\!" &> /dev/null & disown
    exit 1
fi

for i in "${!songs[@]}"; do
    j=$((RANDOM % (i+1)))
    tmp="${songs[i]}"
    songs[i]="${songs[j]}"
    songs[j]="$tmp"
done
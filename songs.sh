songs=( $(yt-dlp --get-id --flat-playlist $playlist_url) )

if [[ $? != 0 ]]; then
    zenity --error --title "$app_title" --text "There was an error while processing the URL\!" &> /dev/null & disown
    exit 1
fi

for i in "${!songs[@]}"; do
    j=$((RANDOM % (i+1)))
    tmp="${songs[i]}"
    songs[i]="${songs[j]}"
    songs[j]="$tmp"
done
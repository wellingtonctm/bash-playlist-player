if [[ $playlist_url == "" ]]; then
    read playlist_url
fi

songs=( $(yt-dlp --skip-download --get-id --flat-playlist $playlist_url) )

for i in "${!songs[@]}"; do
    j=$((RANDOM % (i+1)))
    tmp="${songs[i]}"
    songs[i]="${songs[j]}"
    songs[j]="$tmp"
done
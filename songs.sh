function get-songs() {
    IFS=$'\n'
    songs=( $(cat "$playlists_dir/$playlist_id" | sed -n '1~3p') )
    channels=( $(cat "$playlists_dir/$playlist_id" | sed -n '2~3p') )
    urls=( $(cat "$playlists_dir/$playlist_id" | sed -n '3~3p') )
}
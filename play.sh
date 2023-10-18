function kill_song() {
    kill -0 "$(cat $song_pid_file)" &> /dev/null && kill $(cat $song_pid_file)
    return 0
}

notification_id=0

function play_song() {
    trap kill_song RETURN

	video_info=$(yt-dlp -f 'bestaudio' --get-url --print "%(title)s - %(artist)s" "https://youtube.com/watch?v=$1")
	IFS=$'\n' read -d '' title youtube_link <<< "$video_info"

    echo "$title" | tee $song_info_file
    mpv --no-terminal --no-video --no-cache $youtube_link &
    song_pid=$! && echo $song_pid > $song_pid_file

    notification_id=$(notify-send -p -r $notification_id -i 'mpv' "Bash Playlist Player" "$title")

    while kill -0 "$song_pid" &> /dev/null; do
        sleep 1s;
    done;

    echo ""
    return 0
}
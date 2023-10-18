function play_song() {
	video_info=$(yt-dlp -f 'bestaudio' --get-url --print "%(title)s - %(artist)s" "https://youtube.com/watch?v=$1")
	IFS=$'\n' read -d '' title youtube_link <<< "$video_info"

    echo "Playing: $title" | tee $song_info_file
    mpv --no-terminal --no-video --no-cache $youtube_link &
    
    song_pid=$!
    echo $song_pid > $song_pid_file

    while kill -0 "$song_pid" &> /dev/null; do
        sleep 1s;
    done;

    echo ""
    return 0
}
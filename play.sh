function kill_song() {
    kill -0 "$(cat $song_pid_file)" &> /dev/null && kill $(cat $song_pid_file)
    return 0
}

function play_song() {
    trap kill_song RETURN

    echo -e "${songs[$1]}\n${channels[$1]}" | tee $song_info_file
    mpv --no-terminal --no-video --cache-secs=60 ${urls[$1]} &
    song_pid=$! && echo $song_pid > $song_pid_file

    send-message "${songs[$1]} - ${channels[$1]}"

    while kill -0 "$song_pid" &> /dev/null; do
        sleep 1s;
    done;

    echo ""
    return 0
}
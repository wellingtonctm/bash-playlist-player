function kill_song() {
    kill -0 "$(cat $song_pid_file)" &> /dev/null && kill $(cat $song_pid_file)
    return 0
}

notification_id=0

function play_song() {
    trap kill_song RETURN

    echo -e "${songs[$1]}\n${channels[$1]}" | tee $song_info_file
    mpv --no-terminal --no-video --no-cache ${urls[$1]} &
    song_pid=$! && echo $song_pid > $song_pid_file

    notification_id=$(notify-send -p -r $notification_id -i 'mpv' "$app_title" "${songs[$1]} - ${channels[$1]}")

    while kill -0 "$song_pid" &> /dev/null; do
        sleep 1s;
    done;

    echo ""
    return 0
}
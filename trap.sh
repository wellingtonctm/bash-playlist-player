cleanup() {
    echo "Cleaning up and exiting..."

    if [[ -f $song_pid_file ]] && kill -0 "$(cat $song_pid_file)" &> /dev/null; then
        kill $(cat $song_pid_file)
    fi
    
    if [[ -f $keys_pid_file && "$(cat $keys_pid_file)" != "" ]]; then
        keys_pids=( $(cat $keys_pid_file) )

        for pid in ${keys_pids[@]}; do
            kill $pid &> /dev/null
        done
    fi

    notification_id=$(cat $notification_file 2> /dev/null)
    rm "$main_pid_file" "$song_info_file" "$song_pid_file" "$keys_pid_file" "$notification_file" &> /dev/null
    notify-send -h int:transient:1 -p -r ${notification_id:-0} -i 'mpv' "$app_title" "Stopped"
    exit 0
}

trap cleanup EXIT HUP
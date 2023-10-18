cleanup() {
    echo "Cleaning up and exiting..."
    kill -0 "$(cat $song_pid_file)" &> /dev/null && kill $(cat $song_pid_file)
    
    keys_pids=( $(cat $keys_pid_file) )

    for pid in ${keys_pids[@]}; do
        kill $pid 2> /dev/null
    done

    rm "$main_pid_file" "$song_info_file" "$song_pid_file" "$keys_pid_file"

    exit 0
}

trap cleanup EXIT
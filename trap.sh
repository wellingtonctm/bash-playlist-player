cleanup() {
    echo "Cleaning up and exiting..."
    kill -0 "$(cat $song_pid_file)" &> /dev/null && kill $(cat $song_pid_file)
    
    keys_pids=( $(cat $keys_pid_file) )

    for pid in ${keys_pids[@]}; do
        kill $pid 2> /dev/null
    done

    exit 0
}

trap cleanup EXIT
function keys() {
    paused=false

    xinput test-xi2 --root 3 | gawk '/RawKeyRelease/ {getline; getline; print $2; fflush()}' | \
    while read -r key; do
        if [[ $key == 172 && $paused == true ]]; then
            kill -0 "$(cat $song_pid_file)" &> /dev/null && kill -CONT $(cat $song_pid_file) &&
            echo "Resumed" && paused=false
        elif [[ $key == 172 && $paused == false ]]; then
            kill -0 "$(cat $song_pid_file)" &> /dev/null && kill -STOP $(cat $song_pid_file) &&
            echo "Paused" && paused=true
        elif [[ $key == 171 ]]; then
            kill -0 "$(cat $song_pid_file)" &> /dev/null && kill $(cat $song_pid_file)
            echo "Skipped"
        elif [[ $key == 174 ]]; then
            kill "$(cat $main_pid_file)"
        fi; 
    done;
}

function start-keys() {
    keys &
    keys_pid=$!
    pstree -p $keys_pid | grep -o '([0-9]\+)' | grep -o '[0-9]\+' > $keys_pid_file
}
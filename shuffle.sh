function shuffle() {
    zenity --question --text="Do you want to shuffle?"

    [[ $? == 0 ]] || return 1

    indices=( $(shuf -i 0-$((${#songs[@]}-1))) )

    shuffled_songs=()
    shuffled_channels=()
    shuffled_urls=()

    for index in "${indices[@]}"; do
        shuffled_songs+=("${songs[$index]}")
        shuffled_channels+=("${channels[$index]}")
        shuffled_urls+=("${urls[$index]}")
    done

    songs=("${shuffled_songs[@]}")
    channels=("${shuffled_channels[@]}")
    urls=("${shuffled_urls[@]}")
}

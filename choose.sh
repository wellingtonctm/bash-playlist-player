function choose-playlist() {
    if [[ ! -f $options_file ]]; then
        echo -e 'FALSE|0|New playlist...\nFALSE|1|Remove playlist...' > $options_file
    fi

    while true; do
        IFS=$'|\n'
        option=$(zenity --list --radiolist \
            --title "$app_title" --text "Choose a playlist:" \
            --hide-header \
                --column "" --column "" --column "" \
            --hide-column 2 \
            $(cat $options_file)
        )
        
        [[ $? == 0 ]] || break
        
        case $option in
            '0')
                info=$(zenity --forms --title "$app_title" --text "Playlist" --add-entry "Name" --add-entry "URL")
                        IFS='|' read name url <<< "$info"
                        id=$(grep -Po "^(https://)?(www.)?(music.)?(youtube.com/playlist\?list=)?\K[A-Za-z0-9_-]+" <<< "$url")
                
                if [[ $name == "" ]]; then
                                    zenity --error --title "$app_title" --text "Invalid name!"
                                    continue
                            fi

                        if [[ $id == "" ]] || ! yt-dlp --flat-playlist --playlist-end 1 "https://www.youtube.com/playlist?list=$id" &> /dev/null; then
                                zenity --error --title "$app_title" --text "Invalid playlist!"
                                continue
                        fi
                        
                sed -i "s/^TRUE|/FALSE|/g" $options_file
                        sed -i "1s/^/TRUE|$id|$name\n/" $options_file
                ;;
            '1')
                IFS=$'|\n'
                            value=$(zenity --list --radiolist \
                                    --title "$app_title" --text "Choose a playlist:" \
                                    --hide-header \
                                    --column "" --column "" --column "" \
                                    --hide-column 2 \
                                    $(head -n -2  $options_file)
                            )

                            [[ $? == 0 ]] || continue

                            if [[ $value != "" ]]; then
                                    sed -i "/^FALSE|$value|.*/d" $options_file
                            fi
                ;;
            '')
                break
                ;;
            *)
                playlist_id="$option"
                break
                ;;
        esac
    done

    echo "$playlist_id"
}
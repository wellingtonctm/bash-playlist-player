function send-message() {
	local text="$1"
	notification_id=$(notify-send -p -r ${notification_id:-0} -i 'mpv' "$app_title" "$text")
	sleep 1s
}

function send-error() {
	local text="$1"
	notification_id=$(notify-send -h int:transient:1 -p -r ${notification_id:-0} -i 'error' "$app_title" "$text")
	sleep 1s
}

function choose-playlist() {
	if [[ ! -f $options_file || $(cat $options_file) == "" ]]; then
		touch $options_file
		echo 'FALSE|0|New playlist...' >> $options_file
		echo 'FALSE|1|Remove playlist...' >> $options_file
	fi

	while true; do
		IFS=$'|\n'
		option=$(zenity --list --radiolist \
			--title "$app_title" \
			--text "Choose a playlist:" \
			--hide-header \
			--hide-column 2 \
			--column "" --column "" --column "" \
			$(cat $options_file)
		)
		
		[[ $? == 0 ]] || break
		
		case $option in
			'0')
				info=$(zenity --forms --title "$app_title" --text "Playlist" --add-entry "Name" --add-entry "URL")
						IFS='|' read name url <<< "$info"
						id=$(grep -Po "^(https://)?(www.)?(music.)?(youtube.com/playlist\?list=)?\K[A-Za-z0-9_-]+" <<< "$url")

				send-message "Validating..."
				
				if [[ $name == "" || $id == "" ]]; then
						# zenity --error --title "$app_title" --text "Invalid name!"
						send-error "No field can be blank!"
						continue
				fi

				content=$(yt-dlp --flat-playlist --print "%(title)s" --print "%(channel)s" \
					--print "%(url)s" "https://www.youtube.com/playlist?list=$id")

				if [[ $? -eq 0 ]]; then
					echo "$content" > "$playlists_dir/$id"
				else
					send-error "Invalid Playlist!"
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
									sed -i -r "/^(TRUE|FALSE)\|$value\|.*$/d" $options_file
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
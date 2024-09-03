#!/usr/bin/env bash
# Confirmation CMD

source "$HOME"/.config/rofi/applets/shared/theme.bash
theme="$type/$style"
yes=''
no=''
confirm_cmd() {
	rofi -theme-str 'window {location: center; anchor: center; fullscreen: false; width: 350px;}' \
		-theme-str 'mainbox {orientation: vertical; children: [ "message", "listview" ];}' \
		-theme-str 'listview {columns: 2; lines: 1;}' \
		-theme-str 'element-text {horizontal-align: 0.5;}' \
		-theme-str 'textbox {horizontal-align: 0.5;}' \
		-dmenu \
		-p 'Confirmation' \
		-mesg 'Are you Sure?' \
		-theme ${theme} -hover-select
}
# Ask for confirmation
confirm_exit() {
	echo -e "$yes\n$no" | confirm_cmd
}

# Confirm and execute
confirm_run () {	
	selected="$(confirm_exit)"
	if [[ "$selected" == "$yes" ]]; then
        ${1} && ${2} && ${3}
    else
        exit
    fi	
}

# Close the window
close_window() {
	# check first if there is an active window on focus
	active="$(hyprctl activewindow |awk '/pid:/ {print $2}')"
	echo $active
	if [[ -n "$active" ]]; then
		confirm_run "hyprctl dispatch killactive"
	else 
		notify-send -t 500 "No active window to close"
	fi
}


close_window
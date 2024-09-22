#!/usr/bin/env bash
# Confirmation CMD

source "$HOME"/dotfiles/.config/rofi-theme/applets/shared/theme.bash
theme="$type/$style"
yes=''
no=''

include=(
	"code"
)

confirm_cmd() {
	rofi -theme-str 'window {location: center; anchor: center; fullscreen: false; width: 350px;}' \
		-theme-str 'mainbox {orientation: vertical; children: [ "message", "listview" ];}' \
		-theme-str 'listview {columns: 2; lines: 1;}' \
		-theme-str 'element-text {horizontal-align: 0.5;}' \
		-theme-str 'textbox {horizontal-align: 0.5;}' \
		-dmenu \
		-p 'Confirmation' \
		-mesg 'Are you Sure?' \
		-theme ${theme} \
		-hover-select -scroll-method 0

}
# Ask for confirmation
confirm_exit() {
	echo -e "$yes\n$no" | confirm_cmd
}

# Confirm and execute
confirm_run() {
	selected="$(confirm_exit)"
	if [[ "$selected" == "$yes" ]]; then
		${1} && ${2} && ${3}
	else
		exit
	fi
}

# Close the window
close_window() {

	active="$(hyprctl activewindow | awk '/pid:/ {print $2}')"
	title="$(hyprctl activewindow | awk -F': ' '/initialTitle:/ {print $2}')"

	if [[ -z "$active" ]]; then
		notify-send -t 500 -a "Window" "No active window to close"
		exit
	fi

	if [[ "$1" == "-f" ]]; then
		hyprctl dispatch killactive
	else
		confirm_run "hyprctl dispatch killactive"
	fi

	notify-send -t 500 -a "Window" "Terminated: $title"
}

close_window "$@"

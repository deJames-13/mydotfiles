#!/usr/bin/bash
# lofi.sh - play a lofi hip hop radio stream using mpv and youtube

# options
option1="Lofi Girl - ChilledCow"
option2="Unwind with Lofi Vibes"
option3="Coffee Shop Radio ☕ - 24/7 lofi & jazzy hip-hop beats"
option4="jazz/lofi hip hop radio🌱chill beats to relax/study to [LIVE 24/7]"


# stream url
stream1="https://www.youtube.com/watch?v=jfKfPfyJRdk"
stream2="https://www.youtube.com/watch?v=Zs5C0JYiQog"
stream3="https://www.youtube.com/watch?v=lP26UCnoH9s"
stream4="https://www.youtube.com/watch?v=ehTuatSx5Wc"


options="$option1\n$option2\n$option3\n$option4"
choice=$(echo -e "$options" | rofi -dmenu -replace -config ~/dotfiles/rofi/config-screenshot.rasi -i -no-show-icons -l 4 -width 30 -p "Record Screen")

# kill mpv first if there is choice
if [[ $choice ]]; then
    if pgrep -x "mpv" > /dev/null
    then
        pkill mpv
    fi
fi



case $choice in
    $option1)
        mpv $stream1 >/dev/null 2>&1 & 
    ;;
    $option2)
        mpv $stream2 >/dev/null 2>&1 & 
    ;;
    $option3)
        mpv $stream3 >/dev/null 2>&1 & 
    ;;
    $option4)
        mpv $stream4 >/dev/null 2>&1 & 
    ;;
esac

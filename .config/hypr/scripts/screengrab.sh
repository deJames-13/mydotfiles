NAME="screenshot_$(date +%d%m%Y_%H%M%S).png"
FILE="$HOME/Pictures/screenshots/$NAME"

while getopts ":s:f:" flag; do
    case $flag in
        s)
        grim -g "$(slurp)" $FILE && wl-copy < $FILE && notify-send -t 1000 "$NAME created!" "Mode: Selection"
        ;;
        f)
        grim $FILE && wl-copy < $FILE && notify-send -t 1000 "$NAME created!" "Mode: Fullscreen"
        ;;
        *)
        ;;
    esac
done
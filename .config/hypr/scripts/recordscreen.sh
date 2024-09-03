NAME="screenrecord_$(date +%d%m%Y_%H%M%S).mp4"
FILE="$HOME/Videos/recordings/$NAME"

option2="Fullscreen with audio (delay 3s)"
option8="Fullscreen with mic audio (delay 3s)"
option3="Selected Area with audio"
option4="Fullscreen with bluetooth audio (delay 3s)"
option5="Selected Area with bluetooth audio"
option6="Fullscreen no audio (delay 3s)"
option7="Selected Area no audio"
option9="Selected Area (delay 3s)"
options="$option2\n$option8\n$option3\n$option4\n$option5\n$option6\n$option7\n$option9"

if [ -z $(pgrep wf-recorder) ];
then

case $1 in
    obs)
    if pgrep obs && [ -f /tmp/obsrec ] && grep -q 'STARTED' /tmp/obsrec; then
        python ~/dotfiles/hypr/scripts/recordtoggle.py 
        echo ";PAUSED" > /tmp/obsrec
        sleep 0.5
        notify-send -t 500 "OBS Toggle " "Recording PAUSED"
    elif pgrep obs; then
        notify-send -t 500 "OBS Toggle" "Recording STARTED"
        echo ";STARTED" > /tmp/obsrec
        sleep 0.5
        python ~/dotfiles/hypr/scripts/recordtoggle.py 
    elif [ -f /tmp/obsrec ]; then
        rm /tmp/obsrec
    fi
    ;;
    stop)
    killall -s SIGINT wf-recorder && notify-send "Recording stopped." "File saved at: $FILE"
    ;;
    choose)
    choice=$(echo -e "$options" | rofi -dmenu -replace -config ~/.config/rofi/config-screenshot.rasi -i -no-show-icons -l 4 -width 30 -p "Record Screen")
    case $choice in
    $option2)
        notify-send -t 1000 "Screen Record starting please wait..." "Mode: Fullscreen Audio" 
        sleep 1
        notify-send -t 1000 "Starting in 3..."
        sleep 1
        notify-send -t 1000 "Starting in 2..."
        sleep 1
        notify-send -t 1000 "Starting in 1..."
        sleep 1
        wf-recorder -a --muxer=mp4 --audio=alsa_output.pci-0000_00_1f.3.analog-stereo.monitor -f $FILE >/dev/null 2>&1 &
    ;;
    $option8)
        notify-send -t 1000 "Screen Record starting please wait..." "Mode: Fullscreen Audio" 
        sleep 1
        notify-send -t 1000 "Starting in 3..."
        sleep 1
        notify-send -t 1000 "Starting in 2..."
        sleep 1
        notify-send -t 1000 "Starting in 1..."
        sleep 1
        wf-recorder -a --muxer=mp4 --audio=output.rnnoise_source -f $FILE >/dev/null 2>&1 & 
    ;;
    $option3)
        notify-send -t 1000 "Screen Record starting..." "Mode: Selection"
        sleep 1
        wf-recorder -a -g "$(slurp)" --audio=alsa_output.pci-0000_00_1f.3.analog-stereo.monitor -f $FILE >/dev/null 2>&1 & 
    ;;
    $option4)
        notify-send -t 1000 "Screen Record starting please wait..." "Mode: Fullscreen Bluetooth" 
        sleep 1
        notify-send -t 1000 "Starting in 3..."
        sleep 1
        notify-send -t 1000 "Starting in 2..."
        sleep 1
        notify-send -t 1000 "Starting in 1..."
        sleep 1
        wf-recorder -a --muxer=mp4 --audio=bluez_output.41_42_12_58_FB_1B.1.monitor -f $FILE >/dev/null 2>&1 &
    ;;
    $option5)
        notify-send -t 1000 "Screen Record starting..." "Mode: Selection"
        sleep 1
        wf-recorder -a -g "$(slurp)" --audio=bluez_output.41_42_12_58_FB_1B.1.monitor  -f $FILE >/dev/null 2>&1 &
    ;;
    $option6)
        notify-send -t 1000 "Screen Record starting please wait..." "Mode: Fullscreen No Audio" 
        sleep 1
        notify-send -t 1000 "Starting in 3..."
        sleep 1
        notify-send -t 1000 "Starting in 2..."
        sleep 1
        notify-send -t 1000 "Starting in 1..."
        sleep 1
        wf-recorder -a -f $FILE >/dev/null 2>&1 &
    ;;
    $option7)
        notify-send -t 1000 "Screen Record starting..." "Mode: Selection"
        sleep 1
        wf-recorder -a -g "$(slurp)" -f $FILE >/dev/null 2>&1 &
    ;;

    
    $option9)
        notify-send -t 1000 "Screen Record starting please wait..." "Mode: Selection" 
        sleep 1
        region="$(slurp)"
        notify-send -t 1000 "Starting in 3..."
        sleep 1
        notify-send -t 1000 "Starting in 2..."
        sleep 1
        notify-send -t 1000 "Starting in 1..."
        sleep 1
        wf-recorder -a -g "$region" --audio=alsa_output.pci-0000_00_1f.3.analog-stereo.monitor -f $FILE >/dev/null 2>&1 & 
    ;;
    esac
esac

else
	killall -s SIGINT wf-recorder
	while [ ! -z $(pgrep -x wf-recorder) ]; do wait; done
	notify-send -t 1000 "Recording Complete"
fi
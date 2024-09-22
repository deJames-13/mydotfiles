NAME="screenrecord_$(date +%d%m%Y_%H%M%S).mp4"
FILE="$HOME/Videos/recordings/$NAME"
SCREENRECORDER=wf-recorder

mic="alsa_output.pci-0000_00_1f.3.analog-stereo.monitor"
option2="Fullscreen with audio (delay 3s)"
option8="Fullscreen with mic audio (delay 3s)"
option3="Selected Area with audio"
option4="Fullscreen with bluetooth audio (delay 3s)"
option5="Selected Area with bluetooth audio"
option6="Fullscreen no audio (delay 3s)"
option7="Selected Area no audio"
option9="Selected Area (delay 3s)"
option10="Select Microphone"
options="$option2\n$option8\n$option3\n$option4\n$option5\n$option6\n$option7\n$option9\n$option10"

stoprecording() {
    killall -s SIGINT $SCREENRECORDER
    while [ ! -z $(pgrep -x $SCREENRECORDER) ]; do wait; done
    notify-send -t 1000 -a "Recorder" "Recording Stopped"
    ctx=notify-send -t 1000 -a "Recorder" "Saved at: $FILE"
    if [ ctx == 'yes' ]; then
        ~/.config/ml4w/settings/filemanager.sh $FILE
    fi
}

setmic() {
    mic_options="$(pactl list sources | grep Name | sed 's/Name: //; s/^[[:space:]]*//; s/[[:space:]]*$//' | sort)"
    mic_choice=$(echo -e "$mic_options" | rofi -dmenu -replace -config ~/.config/rofi/config-screenshot.rasi -i -no-show-icons -l 4 -width 30 -p "Record Screen")
    echo "" >/tmp/WF-MIC
    sleep 0.5
    echo $mic_choice >/tmp/WF-MIC

    notify-send -t 1000 -a "Recorder" "Mic Set to: $mic_choice"
}

obs_toggle() {
    if pgrep obs && [ -f /tmp/obsrec ] && grep -q 'STARTED' /tmp/obsrec; then
        python ~/dotfiles/hypr/scripts/recordtoggle.py
        echo ";PAUSED" >/tmp/obsrec
        sleep 0.5
        notify-send -t 500 -a "Recorder" "OBS Toggle " "Recording PAUSED"
    elif pgrep obs; then
        notify-send -t 500 -a "Recorder" "OBS Toggle" "Recording STARTED"
        echo ";STARTED" >/tmp/obsrec
        sleep 0.5
        python ~/dotfiles/hypr/scripts/recordtoggle.py
    elif [ -f /tmp/obsrec ]; then
        rm /tmp/obsrec
    fi
}

delay() {
    count=$1
    message=$2
    notify-send -t 1000 -a "Recorder" "$message"
    sleep 1
    while [ $count -gt 0 ]; do
        notify-send -t 1000 -a "Recorder" "Starting in $count..."
        sleep 1
        count=$((count - 1))
    done
}

choose_modes() {
    choice=$(echo -e "$options" | rofi -dmenu -replace -config ~/.config/rofi/config-screenshot.rasi -i -no-show-icons -l 4 -width 30 -p "Record Screen")
    case $choice in
    $option10) setmic ;;
    $option2)
        delay 3 "Fullscreen with audio (delay 3s)"
        $SCREENRECORDER -a --muxer=mp4 --audio=alsa_output.pci-0000_00_1f.3.analog-stereo.monitor -f $FILE >/dev/null 2>&1 &
        ;;
    $option8)
        delay 3 "Fullscreen with mic audio (delay 3s)"
        $SCREENRECORDER -a --muxer=mp4 --audio=$mic -f $FILE >/dev/null 2>&1 &
        ;;
    $option3)
        notify-send -t 1000 -a "Recorder" "Screen Record starting... Mode: Selection"
        $SCREENRECORDER -a -g "$(slurp)" --audio=alsa_output.pci-0000_00_1f.3.analog-stereo.monitor -f $FILE >/dev/null 2>&1 &
        ;;
    $option4)
        curmic="bluez_output.41_42_12_58_FB_1B.1.monitor"
        if [ -z $(pactl list sources | grep "$curmic") ]; then
            notify-send -t 1000 -a "Recorder" "Bluetooth mic not found."
        else
            delay 3 "Fullscreen with bluetooth audio (delay 3s)"
            $SCREENRECORDER -a --muxer=mp4 --audio=$curmic -f $FILE >/dev/null 2>&1 &
        fi
        ;;
    $option5)
        notify-send -t 1000 -a "Recorder" "Screen Record starting... Mode: Selection"
        curmic="bluez_output.41_42_12_58_FB_1B.1.monitor"
        if [ -z $(pactl list sources | grep "$curmic") ]; then
            notify-send -t 1000 -a "Recorder" "Bluetooth mic not found."
        else
            $SCREENRECORDER -a --muxer=mp4 --audio=$curmic -f $FILE >/dev/null 2>&1 &
        fi
        ;;
    $option6)
        delay 3 "Fullscreen No Audio (delay 3s)"
        $SCREENRECORDER -a -f $FILE >/dev/null 2>&1 &
        ;;
    $option7)
        notify-send -t 1000 -a "Recorder" "Screen Record starting... Mode: Selection No Audio"
        $SCREENRECORDER -a -g --muxer=mp4 "$(slurp)" -f $FILE >/dev/null 2>&1 &
        ;;

    $option9)
        region="$(slurp)"
        setmic
        delay 3 "Screen Record starting please wait... Mode: Selection With Audio"
        $SCREENRECORDER -a -g "$region" --muxer=mp4 --audio=$mic -f $FILE >/dev/null 2>&1 &
        ;;
    esac
}

if [ -f /tmp/WF-MIC ]; then
    mic=$(cat /tmp/WF-MIC | xargs)
    if [ -z $(pactl list sources | grep "$mic") ]; then
        notify-send -t 1000 -a "Recorder" "Mic not found setting to default."
        mic="alsa_output.pci-0000_00_1f.3.analog-stereo.monitor"
    fi

fi

if [ -z $(pgrep $SCREENRECORDER) ]; then
    notify-send -a "Recorder" "Current Mic: $mic" -t 3000
    case $1 in
    obs) obs_toggle ;;
    stop) stoprecording ;;
    choose) choose_modes ;;
    esac

else
    stoprecording
fi

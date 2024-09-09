#!/bin/bash
if ! command -v mpv &>/dev/null; then
    notify-send -u low -t 5000 "mpv could not be found, please install mpv"
    exit 1
fi

# check if /dev/video0 exists
if [ ! -e /dev/video0 ]; then
    notify-send -u low -t 5000 "No webcam found"
    exit 1
fi

# if there is title "MPV Webcam"  and class "mpv-webcam" running, kill it
if pgrep -f "MPV Webcam" >/dev/null; then
    pkill -f "MPV Webcam"
    notify-send -u low -t 5000 "Closed existing webcam instance"
    exit 0
fi

get_devices() {
    output=$(v4l2-ctl --list-devices)
    device_name=""
    device_path=""
    devices=()

    echo "$output" | while IFS= read -r line; do
        if [[ "$line" =~ ^[[:space:]]+ ]]; then
            device_path=$(echo "$line" | sed 's/^[[:space:]]*//')
            if [[ "$device_path" == /dev/video* ]]; then
                if [[ -n "$device_name" ]]; then
                    echo "$device_name: $device_path"
                    devices+=("$device_name: $device_path")
                fi
            fi
        else
            if [[ -n "$device_name" && -n "$device_path" && "$device_path" == /dev/video* ]]; then
                devices+=("$device_name: $device_path")
            fi
            device_name=$(echo "$line" | sed 's/[[:space:]]*$//')
            device_path=""
        fi
    done
    if [[ -n "$device_name" && -n "$device_path" && "$device_path" == /dev/video* ]]; then
        echo "$device_name: $device_path"
    fi

    for device in "${devices[@]}"; do
        echo " $device"
    done
}

choose_cam() {
    devices=$(get_devices)
    device=$(
        echo "$devices" | rofi -dmenu -replace -config ~/.config/rofi/config-screenshot.rasi -i -l 4 -width 30 -p
        "Record Screen"
    )

    if [ -z "$device" ]; then
        exit 1
    fi

    notify-send -t 1000 "Selected: $device"

    cam=$(echo $device | sed 's/.*:: \(\/dev\/video[0-9]*\)/\1/')
    echo $cam
}

test_camera() {
    cam=$(choose_cam)
    if [[ -z "$cam" ]]; then
        exit 1
    fi
    if mpv --profile=low-latency --untimed "$cam" --geometry=100% --title="MPV Webcam" >/dev/null 2>&1; then
        notify-send -t 1000 "Stopped: $cam"
    else
        notify-send -u critical -t 5000 "Selected camera is not working: $cam"
        exit 1
    fi
}

test_camera

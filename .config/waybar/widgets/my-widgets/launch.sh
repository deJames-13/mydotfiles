#!/usr/bin/bash

# Define the path for the PID file
PIDFILE="/tmp/waybar_my_widgets.pid"

# Check if the PID file exists and if the process is running
if [ -f "$PIDFILE" ]; then
    OLDPID=$(cat "$PIDFILE")
    if kill -0 "$OLDPID" 2>/dev/null; then
        echo "Killing previous waybar my_widgets instance with PID $OLDPID"
        kill "$OLDPID"
    fi
    rm "$PIDFILE"
fi

# Start a new waybar process and store its PID
waybar -c ~/dotfiles/waybar/widgets/my-widgets/config -s ~/dotfiles/waybar/widgets/my-widgets/style.css &
NEWPID=$!
echo $NEWPID > "$PIDFILE"

echo "Started new waybar my_widgets instance with PID $NEWPID"

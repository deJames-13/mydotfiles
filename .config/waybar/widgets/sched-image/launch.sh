#!/usr/bin/bash

# Define the path for the PID file
PIDFILE="/tmp/sched-image.pid"

# Check if the PID file exists and if the process is running
if [ -f "$PIDFILE" ]; then
    OLDPID=$(cat "$PIDFILE")
    if kill -0 "$OLDPID" 2>/dev/null; then
        echo "Killing previous waybar sched-image instance with PID $OLDPID"
        kill "$OLDPID"
    fi
    rm "$PIDFILE"
fi

# Start a new waybar process and store its PID
waybar -c ~/dotfiles/waybar/widgets/sched-image/config -s ~/dotfiles/waybar/widgets/sched-image/style.css &
NEWPID=$!
echo $NEWPID > "$PIDFILE"

echo "Started new waybar sched-image instance with PID $NEWPID"

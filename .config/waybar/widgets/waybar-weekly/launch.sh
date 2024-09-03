#!/usr/bin/bash

# Define the path for the PID file
PIDFILE="/tmp/waybar_weekly.pid"

# Check if the PID file exists and if the process is running
if [ -f "$PIDFILE" ]; then
    OLDPID=$(cat "$PIDFILE")
    if kill -0 "$OLDPID" 2>/dev/null; then
        echo "Killing previous waybar weekly instance with PID $OLDPID"
        kill "$OLDPID"
    fi
    rm "$PIDFILE"
fi

# Start a new waybar process and store its PID
waybar -c ~/dotfiles/waybar/widgets/waybar-weekly/config -s ~/dotfiles/waybar/widgets/waybar-weekly/style.css &
NEWPID=$!
echo $NEWPID > "$PIDFILE"

echo "Started new waybar weekly instance with PID $NEWPID"

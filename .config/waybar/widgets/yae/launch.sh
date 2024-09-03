#!/usr/bin/bash

# Define the path for the PID file
PIDFILE="/tmp/yae.pid"

# Check if the PID file exists and if the process is running
if [ -f "$PIDFILE" ]; then
    OLDPID=$(cat "$PIDFILE")
    if kill -0 "$OLDPID" 2>/dev/null; then
        echo "Killing previous waybar yae instance with PID $OLDPID"
        kill "$OLDPID"
    fi
    rm "$PIDFILE"
fi

# Start a new waybar process and store its PID
waybar -c ~/dotfiles/waybar/widgets/yae/config -s ~/dotfiles/waybar/widgets/yae/style.css &
NEWPID=$!
echo $NEWPID > "$PIDFILE"

echo "Started new waybar yae instance with PID $NEWPID"

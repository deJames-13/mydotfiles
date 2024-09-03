#!/usr/bin/bash

# Custom clock for waybar using json
# Requires jq
# {text:"", class:"", alt:"", tooltip:""}

while true; do
    day=$(date +"%a")
    today=$(date +"%d %B, %Y")
    time=$(date +"%H:%M")

    # Output needs to be in json format using jq
    # # {text:"",day:"",today="",time="" class:"", alt:"", tooltip:""}
    echo "{\"text\":\"$day\n$today\n$time\",\"class\":\"\",\"alt\":\"\",\"tooltip\":\"\"}" | jq --unbuffered --compact-output


    # Pause for 1 minute (60 seconds)
    sleep 10
done
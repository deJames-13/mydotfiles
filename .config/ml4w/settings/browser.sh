if [[ -f ~/.cache/gamemode ]]; then
    export MOZ_ACCELERATED=1
    export MOZ_WEBRENDER=1
    notify-send "Firefox started in safe mode"
    firefox -safe-mode
else
    zen-browser
fi

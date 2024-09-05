printProp(){
    prop=$(hyprprop)
    title=$(echo "$prop" | grep '"title"' | awk -F'"' '{print $4}')
    class=$(echo "$prop" | grep '"class"' | awk -F'"' '{print $4}')
    initialTitle=$(echo "$prop" | grep '"initialTitle"' | awk -F'"' '{print $4}')
    initialClass=$(echo "$prop" | grep '"initialClass"' | awk -F'"' '{print $4}')

    msg="
    Title: $title
    Class: $class
    Initial Title: $initialTitle
    Initial Class: $initialClass
    "   

    notify-send -w "$msg"
    wl-copy $msg 
}

printProp
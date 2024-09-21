gitpush(){
    message=${@:-$(date)}

    git add .
    git commit -m "$message"
    git push
}
setmonitormode(){
    interface=${1:-wlan0}
    sudo airmon-ng check kill
    sudo ifconfig $interface down
    sudo iwconfig $interface mode monitor
    sudo ifconfig $interface up
    echo "Interface $interface set to monitor mode"
    sudo iwconfig
}
setmanagemode(){   
    interface=${1:-wlan0}
    sudo ifconfig $interface down
    sudo iwconfig $interface mode managed
    sudo ifconfig $interface up
    echo "Interface $interface set to managed mode"
    sudo systemctl restart NetworkManager
    sudo systemctl restart dhcpcd
    iwconfig
}


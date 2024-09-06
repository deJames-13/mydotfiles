gitpush(){
    message=${@:-$(date)}

    git add .
    git commit -m "$message"
    git push
}
setmonitormode(){
    interface=${1:-wlan0}
    airmon-ng check kill
    ifconfig $interface down
    iwconfig $interface mode monitor
    ifconfig $interface up
    echo "Interface $interface set to monitor mode"
    iwconfig
}
setmanagemode(){   
    interface=${1:-wlan0}
    ifconfig $interface down
    iwconfig $interface mode managed
    ifconfig $interface up
    echo "Interface $interface set to managed mode"
    systemctl restart NetworkManager
    systemctl restart dhcpcd
    iwconfig
}
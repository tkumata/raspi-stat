#!/bin/bash

# Check.
ping -c2 www.google.com > /dev/null

# $? is return code of previous latest command.
# 0 is true.
# non-zero is false.
if [ $? != 0 ]
then
    # Wait for AP finishes boot.
    sleep 40

    # Turn off power management for RPi3 WiFi.
    sudo iw dev wlan0 set power_save off

    # RPi3 wifi dead after AP rebooting. Try following but workaround is nothing.
    sudo ifdown --force eth0
    sudo ifdown --force wlan0
    sudo systemctl daemon-reload
    #sudo /etc/init.d/networking restart
    sudo systemctl stop dhcpcd.service
    sudo systemctl restart networking.service
    sudo systemctl restart avahi-daemon.service
    sudo systemctl restart wpa_supplicant.service
    sudo systemctl start dhcpcd.service
    sudo ifup --force wlan0
    wpa_cli -i wlan0 reconfigure

    # Log
    #echo $(date; iwgetid -r) >> reconnect.log
    ifconfig >> reconnect.log
    #iwconfig >> reconnect.log
    #systemctl status >> recoonect.log

    sleep 5

    # So give up.
    if ifconfig wlan0 | grep '192.168.2.1' > /dev/null
    then
        echo $(date; iwgetid -r; echo "OK.") >> reconnect.log
    else
        echo $(date; iwgetid -r; echo "NG. Need reboot.") >> reconnect.log
        sudo reboot
    fi
fi

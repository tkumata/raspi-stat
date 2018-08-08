#!/bin/bash
set -e

# Check.
ping -c2 www.google.com > /dev/null

# $? is return code of previous latest command.
# 0 is true.
# non-zero is false.
if [ $? != 0 ]
then
    sleep 40

    # Turn off power management for RPi3 WiFi.
    sudo iw dev wlan0 set power_save off

    # RPi3 wifi dead after AP rebooting. Try following but workaround is nothing.
    sudo ifdown --force eth0
    sudo ifdown --force wlan0
    sudo systemctl daemon-reload
    sudo /etc/init.d/networking restart
    sudo systemctl restart avahi-daemon.service
    sudo systemctl restart wpa_supplicant.service
    wpa_cli -i wlan0 reconfigure

    # Log
    echo $(date; iwgetid -r) >> reconnect.log
    #ifconfig wlan0 >> reconnect.log
    #iwconfig wlan0 >> reconnect.log
    #systemctl status >> recoonect.log

    # So give up.
    if ifconfig wlan0 | grep '192.168.2.1' > /dev/null
    then
        echo "OK." >> reconnect.log
    else
        echo "NG. Need reboot." >> reconnect.log
        sudo reboot
    fi
fi

#!/bin/bash
set -e

# Turn off power management for RPi3 WiFi.
sudo /sbin/iw dev wlan0 set power_save off

# Check.
ping -c2 www.google.com > /dev/null

# $? is return code of previous latest command.
# 0 is true.
# non-zero is false.
if [ $? != 0 ]
then
    sleep 30

    sudo ifdown --force eth0
    sudo ifdown --force wlan0
    sudo systemctl daemon-reload
    sudo /etc/init.d/networking restart
    sudo systemctl restart avahi-daemon.service
    sudo systemctl restart wpa_supplicant.service
    wpa_cli -i wlan0 reconfigure

    echo $(date; iwgetid -r) >> reconnect.log
    #/sbin/ifconfig >> reconnect.log
fi

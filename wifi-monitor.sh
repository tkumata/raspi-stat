#!/bin/bash
ping -c2 www.google.com > /dev/null

if [ $? != 0 ]
then
    sleep 40

    sudo iw dev wlan0 set power_save off
    sudo ifdown --force eth0
    sudo ifdown --force wlan0
    sudo systemctl daemon-reload
    sudo /etc/init.d/networking restart
    sudo systemctl restart avahi-daemon.service
    sudo systemctl restart wpa_supplicant.service
    wpa_cli -i wlan0 reconfigure

    echo $(date; iwgetid -r) >> reconnect.log
    #ifconfig wlan0 >> reconnect.log
    #iwconfig wlan0 >> reconnect.log
    #systemctl status >> recoonect.log

    if ifconfig wlan0 | grep '192.168.2.1' > /dev/null
    then
        echo "OK." >> reconnect.log
    else
        echo "NG. Need reboot." >> reconnect.log
        sudo reboot
    fi
fi

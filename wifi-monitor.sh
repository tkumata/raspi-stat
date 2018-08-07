#!/bin/bash
ping -c2 www.google.com > /dev/null

if [ $? != 0 ]
then
    sleep 60

    sudo ifdown --force eth0
    sudo ifdown --force wlan0
    sudo systemctl daemon-reload
    sudo /etc/init.d/networking restart
    sudo systemctl restart avahi-daemon.service
    sudo systemctl restart wpa_supplicant.service

    sleep 3

    echo $(date; iwgetid -r) >> reconnect.log
    /sbin/ifconfig >> reconnect.log
fi

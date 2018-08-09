#!/bin/bash
#
# DONOT forget following.
# echo '@reboot nohup $HOME/bin/raspi-stat/wifi-monitor.sh >/dev/null 2>&1 &' | crontab
#

site='www.google.com'
count=0
threshold=3

while :
do
    # Check.
    ping -c2 $site > /dev/null

    # $? is return code of previous latest command.
    # 0 is true.
    # non-zero is false.
    if [ $? != 0 ]
    then
        count=$((count++)) # bash only

        # Wait for AP finishes boot.
        sleep 40

        # Turn off power management for RPi3 WiFi.
        sudo iw dev wlan0 set power_save off

        # RPi3 wifi dead after AP rebooting. Try following but workaround is nothing.
        sudo ifdown --force eth0
        sudo ifdown --force wlan0
        sudo systemctl daemon-reload
        # sudo /etc/init.d/networking restart
        sudo systemctl stop dhcpcd.service
        sudo systemctl restart networking.service
        sudo systemctl restart avahi-daemon.service
        sudo systemctl restart wpa_supplicant.service
        sudo systemctl start dhcpcd.service
        sudo ifup --force wlan0
        wpa_cli -i wlan0 reconfigure

        # Log
        # echo $(date; iwgetid -r) >> reconnect.log
        # ifconfig >> reconnect.log
        # iwconfig >> reconnect.log
        # systemctl status >> recoonect.log

        sleep 5

        # So give up.
        if ifconfig wlan0 | grep '192.168.2.1' > /dev/null
        then
            echo $(date; iwgetid -r; echo "OK.") >> reconnect.log
        else
            echo $(date; iwgetid -r; echo "NG.") >> reconnect.log

            if [ $count -eq $threshold ]; then
                echo $(date; iwgetid -r; echo "Reboot.") >> reconnect.log
                sudo reboot
            fi
        fi
    fi

    sleep 300
done

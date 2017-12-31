#!/bin/bash

echo "Checking packages..."
sudo apt-get update
echo ""
sudo apt-get upgrade -y
echo ""
sudo apt-get dist-upgrade -y
echo ""
sudo apt-get autoremove
echo ""
sudo apt-get autoclean
echo ""

echo "Load preset infinality."
sudo /etc/fonts/infinality/infctl.sh setstyle osx

echo "Checking firmware..."
FIRM_CHECK="$(sudo JUST_CHECK=1 rpi-update)"
if [ "$(echo "$FIRM_CHECK" | grep -i "kernel: bump to")" ]; then
    tmp="$(echo "$FIRM_CHECK" | sed '/kernel: Bump to /!d')"
    NEW_VERSION="$(echo "$tmp" | awk '{print $5}')"

    CUR_VERSION="$(uname -ri | awk '{if(match($0, /[0-9]+.[0-9]+.[0-9]+-/)) print substr($0, RSTART, RLENGTH-1)}')"

    echo "Current: $CUR_VERSION"
    echo "New: $NEW_VERSION"
    echo "New firmware found."
    echo "Do you update firmware? [Y/n]"

    read answer

    case "$answer" in
        y|Y)
            echo "Backup icurrent firmware revision."
            cp /boot/.firmware_revision ~/"$CUR_VERSION"_boot_.firmware_revision
            cp /boot/config.txt ~/"$CUR_VERSION"_boot_config.txt
            echo "Start rpi-update."
            sudo rpi-update
            for i in {1..6}; do
                c=$((6 - $i))
                echo $c
                if [ $c -eq 0 ]; then
                    echo "sudo reboot"
                    sudo reboot
                fi
                sleep 1
            done
            ;;
        *)
            ;;
    esac
else
    echo "No new firmware found."
fi
echo ""

echo "Finish update.sh."

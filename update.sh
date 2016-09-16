#!/bin/bash

sudo apt-get update
echo ""
sudo apt-get upgrade -y
echo ""
sudo apt-get autoremove
echo ""
sudo apt-get autoclean
echo ""

echo "Checking firmware..."
FIRM_CHECK="$(sudo JUST_CHECK=1 rpi-update)"
if [ "$(echo "$FIRM_CHECK" | grep -i "kernel: bump to")" ]; then
    tmp="$(echo "$FIRM_CHECK" | sed '/kernel: Bump to /!d')"
    NEW_VERSION=$(echo "$tmp" | awk '{print $5}')

    CUR_VERSION="$(uname -ri | awk '{if(match($0, /[0-9]+.[0-9]+.[0-9]+-/))print substr($0, RSTART, RLENGTH-1)}')"

    echo "Current: $CUR_VERSION"
    echo "New: $NEW_VERSION"

    if [ "$CUR_VERSION" = "$NEW_VERSION" ]; then
        echo "No new firmware found."
    else
        echo "New firmware found."
        echo "Do you update firmware? [Y/n]"
        read answer
        case $answer in
            y|Y)
                echo "Start rpi-update."
                sudo rpi-update
                ;;
            *)
                ;;
        esac
    fi
fi

echo ""
echo "Finish update."

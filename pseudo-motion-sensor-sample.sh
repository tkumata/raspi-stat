#!/bin/bash
#
# THIS IS SAMPLE.
#
# wlan0     IEEE 802.11bgn  ESSID:"XXXXXXXXXXXXXXXXXXXXXX"
#           Mode:Managed  Frequency:2.462 GHz  Access Point: XX:XX:XX:XX:XX:XX
#           Bit Rate=72.2 Mb/s   Tx-Power=31 dBm
#           Retry short limit:7   RTS thr:off   Fragment thr:off
#           Power Management:off
#           Link Quality=70/70  Signal level=-40 dBm
#           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
#           Tx excessive retries:26  Invalid misc:0   Missed beacon:0
#
set -eu

THRESHOLD="45" # Your threshold of Wi-Fi RSSI.
COUNT="0"
COUNT_THRESHOLD="5"

function led_fire_on() {
    if [ "$(pgrep -f 'led_fire.py')" = "" ]; then
        /home/pi/bin/led_fire/led_fire.py &
    fi
}

function led_fire_off() {
    if [ "$(pgrep -f 'led_fire.py')" != "" ]; then
        pkill -f 'led_fire.py'
    fi
}

while :
do
    iwconfig_result="$(iwconfig wlan0)"
    link_quality="$(echo -e "$iwconfig_result" | grep -i "Link Quality" | awk 'match($0, /[0-9][0-9]\/[0-9][0-9]/) {print substr($0, RSTART, RLENGTH)}' | sed -e 's/\/70//')"
    signal_level="$(echo -e "$iwconfig_result" | grep -i "Signal level" | awk 'match($0, /[0-9]* dBm/) {print substr($0, RSTART, RLENGTH)}' | sed -e 's/ dBm//')"

    if [ "$THRESHOLD" -le "$signal_level" ]; then
        COUNT="$(($COUNT + 1))"
        #echo -e "$link_quality/70\t-$signal_level dBm"
        echo -n "x"

        if [ "$COUNT" -ge "$COUNT_THRESHOLD" ]; then
            led_fire_on
        fi
    else
        COUNT="0"
        echo -n "."
        led_fire_off
    fi

    sleep .1
done

echo "end"

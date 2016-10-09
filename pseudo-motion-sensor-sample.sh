#!/bin/bash
#
# THIS IS SAMPLE.
#
set -eu

THRESHOLD="45" # Your threshold of Wi-Fi RSSI.
COUNT="0"
COUNT_THRESHOLD="1"
SLEEP_TIMER="0.3"

function led_fire_on() {
    if [ "$(pgrep -f 'led_fire')" = "" ]; then
        /home/pi/bin/led_fire/led_fire.py &
    fi
}

function led_fire_off() {
    if [ "$(pgrep -f 'led_fire')" != "" ]; then
        pkill -f 'led_fire'
    fi
}

while :
do
    #link_quality="$(cat /proc/net/wireless | tail -1 | awk '{print $3}' | sed -e 's/\.//')"
    signal_level="$(cat /proc/net/wireless | tail -1 | awk '{print $4}' | sed -e 's/\-//' -e 's/\.//')"

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

    if [ "$COUNT" -gt "100" ]; then
        COUNT="0"
        echo -n "."
    fi

    sleep $SLEEP_TIMER
done

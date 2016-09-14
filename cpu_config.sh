#!/bin/sh
governor="$(sudo cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor)"
if [ "$governor" = "ondemand" ]; then
    sudo sh -c "echo 70 > /sys/devices/system/cpu/cpufreq/ondemand/up_threshold"
fi

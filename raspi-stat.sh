#!/bin/bash
set -e
. /etc/os-release

trap catch ERR
trap finally EXIT
trap handler SIGINT

function catch() {
    echo "Error"
}

function finally() {
    echo "Normal End"
    exit 0
}

function handler() {
    echo "Press Ctrl+C"
    exit 0
}

while true; do
    clear
    CPUINFO=""
    VOLT=""

    if [ "$(sudo cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor)" = "ondemand" ]; then
        CPUINFO="${CPUINFO}\nUP threshold\t$(cat /sys/devices/system/cpu/cpufreq/ondemand/up_threshold)\n"
        CPUINFO="${CPUINFO}\nDown factor\t$(cat /sys/devices/system/cpu/cpufreq/ondemand/sampling_down_factor)\n"
    else
        CPUINFO=""
    fi

    for id in core sdram_c sdram_i sdram_p; do
        VOLT="${VOLT}\n$id\t$(vcgencmd measure_volts $id)\n"
    done

    DISP=`cat << EOS
----- OS ------\t--------------------
Name\t${NAME}
Version\t${VERSION}
----- CPU -----\t--------------------
Clock arm\t$(($(sudo cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq)*1000))Hz
Clock core\t$(vcgencmd measure_clock core | cut -d = -f 2)Hz
CPU temperature\t$(echo "scale=1;$(cat /sys/class/thermal/thermal_zone0/temp)/1000"|bc) C
GPU temperature\t$(vcgencmd measure_temp | cut -d = -f 2)
Governor\t$(sudo cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor)
${CPUINFO}
--- Memory ----\t--------------------
arm\t$(vcgencmd get_mem arm | cut -d = -f 2)
gpu\t$(vcgencmd get_mem gpu | cut -d = -f 2)
---- Volt -----\t--------------------
${VOLT}
---------------\t--------------------
EOS
`

    echo -e "${DISP}" | column -s $'\t' -t
    sleep 2
done

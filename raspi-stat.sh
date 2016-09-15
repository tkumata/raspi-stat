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
    RES="===== OS ======\t==================\n"

    CPUINFO="${CPUINFO}\nName\t${NAME}"
    CPUINFO="${CPUINFO}\nVersion\t${VERSION}"
    CPUINFO="${CPUINFO}\n===== CPU =====\t==================\n"
    CPUINFO="${CPUINFO}\nClock arm\t$(($(sudo cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq)*1000))Hz\n"
    CPUINFO="${CPUINFO}\nClock core\t$(vcgencmd measure_clock core | cut -d = -f 2)Hz\n"
    CPUINFO="${CPUINFO}\nCPU Temperature\t$(echo "scale=1;$(cat /sys/class/thermal/thermal_zone0/temp)/1000"|bc) C\n"
    CPUINFO="${CPUINFO}\nGPU Temperature\t$(vcgencmd measure_temp | cut -d = -f 2)\n"
    CPUINFO="${CPUINFO}\nGovernor\t$(sudo cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor)\n"
    if [ "$(sudo cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor)" = "ondemand" ]; then
        CPUINFO="${CPUINFO}\nUP threshold\t$(cat /sys/devices/system/cpu/cpufreq/ondemand/up_threshold)\n"
        CPUINFO="${CPUINFO}\nDown threshold\t$(cat /sys/devices/system/cpu/cpufreq/ondemand/sampling_down_factor)\n"
    fi
    CPUINFO="${CPUINFO}\n===== Mem =====\t==================\n"
    CPUINFO="${CPUINFO}\nMem arm\t$(vcgencmd get_mem arm | cut -d = -f 2)\n"
    CPUINFO="${CPUINFO}\nMem gpu\t$(vcgencmd get_mem gpu | cut -d = -f 2)\n"
    CPUINFO="${CPUINFO}\n==== Volt =====\t==================\n"

    for id in core sdram_c sdram_i sdram_p; do
        VOLT="${VOLT}\n$id\t$(vcgencmd measure_volts $id)\n"
    done

    RES=${RES}`cat <<EoS
${CPUINFO}
${VOLT}
EoS
`
    RES="${RES}\n===============\t==================\n"

    echo -e ${RES} | column -s $'\t' -t

    sleep 2
done

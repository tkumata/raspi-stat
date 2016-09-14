#!/bin/bash

function exec_performance() {
    sudo sh -c "echo performance > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor"
}

function exec_ondemand() {
    sudo sh -c "echo ondemand > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor"
    governor="$(sudo cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor)"
    if [ "$governor" = "ondemand" ]; then
        sudo sh -c "echo 70 > /sys/devices/system/cpu/cpufreq/ondemand/up_threshold"
    fi
}

function exec_default() {
    sudo sh -c "echo ondemand > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor"
    governor="$(sudo cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor)"
    if [ "$governor" = "ondemand" ]; then
        sudo sh -c "echo 50 > /sys/devices/system/cpu/cpufreq/ondemand/up_threshold"
    fi
}

if [ $# -eq 1 ]; then
    arg="$1"
    case "$arg" in
        performance) exec_performance
        ;;
        ondemand) exec_ondemand
        ;;
        default) exec_default
        ;;
        *) exit 1
        ;;
    esac
else
    exit 1
fi

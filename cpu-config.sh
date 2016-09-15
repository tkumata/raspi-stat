#!/bin/bash

function exec_performance() {
    for i in 0 1 2 3; do
        sudo sh -c "echo performance > /sys/devices/system/cpu/cpu${i}/cpufreq/scaling_governor"
    done
}

function exec_ondemand() {
    for i in 0 1 2 3; do
        sudo sh -c "echo ondemand > /sys/devices/system/cpu/cpu${i}/cpufreq/scaling_governor"
    done
    governor="$(sudo cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor)"
    if [ "$governor" = "ondemand" ]; then
        sudo sh -c "echo 95 > /sys/devices/system/cpu/cpufreq/ondemand/up_threshold"
        sudo sh -c "echo 85 > /sys/devices/system/cpu/cpufreq/ondemand/sampling_down_factor"
    fi
}

function exec_default() {
    for i in 0 1 2 3; do
        sudo sh -c "echo ondemand > /sys/devices/system/cpu/cpu${i}/cpufreq/scaling_governor"
    done
    governor="$(sudo cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor)"
    if [ "$governor" = "ondemand" ]; then
        sudo sh -c "echo 50 > /sys/devices/system/cpu/cpufreq/ondemand/up_threshold"
        sudo sh -c "echo 50 > /sys/devices/system/cpu/cpufreq/ondemand/sampling_down_factor"
    fi
}

if [ $# -eq 1 ]; then
    arg="$1"
    case "$arg" in
        performance)
            exec_performance
            ;;
        ondemand)
            exec_ondemand
            ;;
        default) exec_default
            ;;
        *)
            echo "a"
            exit 1
            ;;
    esac
else
    exit 1
fi

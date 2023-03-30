#!/bin/bash

current_governor=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor)
if [ "$current_governor" != "performance" ]; then
    echo "Current scaling governor: $current_governor"
    if echo "performance" | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor > /dev/null; then
        echo "Changed scaling governor to performance"
    else
        echo "Couldn't change scaling governor to performance"
    fi
else
    echo "Current scaling governor: $current_governor"
fi
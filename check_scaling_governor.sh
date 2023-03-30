#!/bin/bash

current_governor=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor)

if [ "$current_governor" != "performance" ]; then
echo "Current scaling governor: $current_governor"
exit 1
else
echo "Current scaling governor: $current_governor"
exit 0
fi

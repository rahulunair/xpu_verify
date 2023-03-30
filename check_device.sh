#!/bin/bash
echo "Checking kernel configuration for intel discrete GPUs"
echo "===================================================="

overall_status=0

echo "Checking if i915 kernel module is loaded..."
if lsmod | grep i915 > /dev/null; then
    echo "i915 kernel module is loaded"
else
    echo "i915 kernel module is not loaded"
    overall_status=1
fi

echo ""
echo "Checking if the user is in render group..."
if groups | grep render > /dev/null; then
    echo "User is in render group"
else
    echo "User is not in render group"
    overall_status=1
fi

echo ""
echo "Checking if Intel discrete GPU is visible as a pcie device..."
if lspci | grep -i intel | grep -i display > /dev/null; then
    echo "Intel discrete GPU is visible"
else
    echo "Intel discrete GPU is not visible"
    overall_status=1
fi

echo ""
echo "Checking if appropriate graphics microcode is loaded in i915"
if sudo dmesg | grep -i i915 -A20  | grep -i "guc" | grep -iE "dg2_guc_|pvc_guc_" > /dev/null ; then
    guc=$(sudo dmesg | grep -i i915 -A20 | grep -i "guc" | grep -iE "dg2_guc_|pvc_guc_" | cut -d "/" -f 2)
    echo "Discrete GPU GuC loaded with firmware version: $guc"
else
    echo "Discrete GPU GUC not loaded"
    overall_status=1
fi

echo "===================================================="
echo ""

if [ $overall_status -eq 0 ]; then
    echo "All tests passed."
    exit 0
else
    echo "Some tests failed. Please check the output for more information."
    exit 1
fi

#!/bin/bash

if command -v lsb_release &> /dev/null
then
    os_version=$(lsb_release -d | awk '{print $2,$3,$4,$5}')
else
    os_version=$(grep "PRETTY_NAME" /etc/os-release | cut -d "=" -f 2 | tr -d '"')
fi

kernel_version=$(uname -r)
major_kernel_version=$(echo "$kernel_version" | cut -d. -f1,2)

echo "OS Version: $os_version"
echo "Kernel Version: $kernel_version"

if [[ "$os_version" == *"Ubuntu"* && $(echo "$major_kernel_version >= 6.2" | bc) -eq 1 ]]; then
    exit 0
else
    if [[ "$os_version" == *"Ubuntu 22.04"* && "$kernel_version" != "5.15.0-57-generic" ]]; then
        echo "Kernel version for Ubuntu 22.04 should be 5.15.0-57-generic"
    elif [[ "$os_version" == *"Ubuntu 20.04"* && "$kernel_version" != "5.14.0-1047-oem" ]]; then
        echo "Kernel version for Ubuntu 20.04 should be 5.14.0-1047-oem"
    else
        echo "Kernel version for $os_version is not supported. More details can be found at https://dgpu-docs.intel.com/installation-guides/ubuntu/ubuntu-focal-arc.html"
    fi
    exit 1
fi

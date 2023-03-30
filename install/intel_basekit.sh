#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

oneapi_sources=$(find /etc/apt/sources.list.d/ -type f -name "*.list" -exec grep -q "apt.repos.intel.com/oneapi" {} \; -print)
if [ -z "$oneapi_sources" ]; then
    wget -O- https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB \
    | gpg --dearmor | sudo tee /usr/share/keyrings/oneapi-archive-keyring.gpg > /dev/null
    echo "deb [signed-by=/usr/share/keyrings/oneapi-archive-keyring.gpg] https://apt.repos.intel.com/oneapi all main" | sudo tee /etc/apt/sources.list.d/oneAPI.list
    echo "Added oneAPI repository"
    sudo -E apt update
fi
if "$SCRIPT_DIR/../check_intel_basekit.sh"; then
    echo "Intel oneAPI Base Toolkit is already installed."
else
    sudo -E apt install intel-basekit -y
    echo "Intel oneAPI Base Toolkit has been installed."
fi

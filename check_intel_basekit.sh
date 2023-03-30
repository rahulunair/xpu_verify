BASEKIT_VERSION=$(dpkg -l intel-basekit 2>/dev/null | grep -q "^ii" && dpkg -l intel-basekit | awk '{print $3}' | grep "^2023")
if echo "$BASEKIT_VERSION" | grep -q "2023"; then
    echo "intel-basekit is installed and with the version: $BASEKIT_VERSION"
    exit 0
elif [ -d "/opt/intel/oneapi/mkl/latest/lib/intel64" ] && [ -n "$(find /opt/intel/oneapi/mkl/latest/lib/intel64/ -type f -name 'libmkl*' -print -quit)" ] && [ -n "$(find /opt/intel/oneapi/dpcpp-ct/*/lib/clang/*/include/ -type f -name '*.h' -print -quit)" ]; then
    echo "intel-basekit is installed"
    exit 0
else
    echo "intel-basekit is not installed"
    exit 1
fi

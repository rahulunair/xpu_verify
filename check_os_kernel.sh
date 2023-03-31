declare -A ubuntu_kernel_versions
ubuntu_kernel_versions=(
    ["20.04"]="5.14.0-1047-oem"
    ["22.04"]="5.15.0-57-generic"
)
if command -v lsb_release &> /dev/null
then
    os_version=$(lsb_release -d | awk '{print $2,$3,$4,$5}')
else
    os_version=$(grep "PRETTY_NAME" /etc/os-release | cut -d "=" -f 2 | tr -d '"')
fi

kernel_version=$(uname -r)
echo "OS Version: $os_version"
major_kernel_version=$(echo "$kernel_version" | awk -F. '{print $1}')
minor_kernel_version=$(echo "$kernel_version" | awk -F. '{print $2}')
os_version_number=$(echo "$os_version" | grep -oP '\d{2}\.\d{2}')
if [[ $major_kernel_version -gt 6 || ( $major_kernel_version -eq 6 && $minor_kernel_version -ge 2 ) ]] || [[ ${ubuntu_kernel_versions["$os_version_number"]} == "$kernel_version" ]]; then
    echo "Kernel version is $kernel_version and has support for Intel dGPUs by default"
    exit 0
else
    if [[ -n ${ubuntu_kernel_versions["$os_version_number"]} ]]; then
        echo "Kernel version for Ubuntu $os_version_number should be ${ubuntu_kernel_versions["$os_version_number"]}"
    else
        echo "Kernel version for $os_version is not supported. More details on how to setup dGPU drivers can be found at https://dgpu-docs.intel.com/installation-guides/ubuntu/ubuntu-focal-arc.html"
    fi
    exit 1
fi

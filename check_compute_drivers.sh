#!/bin/bash

# Define colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

os_name="$(awk -F= '/^NAME/{print $2}' /etc/os-release | tr -d '"' | tr '[:upper:]' '[:lower:]')"
os_version="$(awk -F= '/^VERSION_ID/{print $2}' /etc/os-release | tr -d '"')"

ubuntu_version_list=(20.04 22.04 23.04)
ubuntu_runtime_drivers=(
  "intel-level-zero-gpu"
  "intel-opencl-icd"
  "level-zero"
  "libdrm-common"
  "libdrm2"
  "libdrm-amdgpu1"
  "libdrm-intel1"
  "libdrm-nouveau2"
  "libigc1"
  "libigdfcl1"
  "libigdgmm12"
)
ubuntu_devel_drivers=(
  "level-zero-dev"
  "libdrm-dev"
)

redhat_version_list=(8.5)
redhat_runtime_drivers=(
  "intel-igc-core"
  "intel-igc-opencl"
  "intel-gmmlib"
  "intel-opencl"
  "level-zero"
  "libdrm"
  "libpciaccess"
  "libpkgconf"
  "pkgconf"
)
redhat_devel_drivers=(
  "level-zero-devel"
 )

function is_driver_installed() {
  if [[ "$os_name" == "ubuntu" ]]; then
    dpkg -s "$1" > /dev/null 2>&1
  elif [[ "$os_name" == "redhat" ]]; then
    rpm -q "$1" > /dev/null 2>&1
  fi
}

function get_driver_version() {
  if [[ "$os_name" == "ubuntu" ]]; then
    dpkg -s "$1" | grep Version | awk '{print $2}'
  elif [[ "$os_name" == "redhat" ]]; then
    rpm -q --queryformat '%{VERSION}' "$1"
  fi
}

function check_drivers() {
  local driver_list=("${@}")

  for driver in "${driver_list[@]}"; do
    if is_driver_installed "$driver"; then
      driver_version=$(get_driver_version "$driver")
      installed_drivers+=("$driver ($driver_version)")
    else
      missing_drivers+=("$driver")
    fi
  done
}

function check_dev_drivers() {
  local driver_list=("${@}")

  for driver in "${driver_list[@]}"; do
    if is_driver_installed "$driver"; then
      driver_version=$(get_driver_version "$driver")
      installed_drivers+=("$driver ($driver_version)")
    else
      missing_dev_drivers+=("$driver")
    fi
  done
}
function print_missing_drivers() {
  if [[ ${#missing_drivers[@]} -eq 0 ]]; then
    return
  fi

  echo -e "${RED}The following required drivers are missing:${NC}"
  printf '%s\n' "${missing_drivers[@]}"
  echo "============================================"
}

function print_installed_drivers() {
  if [[ ${#installed_drivers[@]} -eq 0 ]]; then
    return
  fi

  echo -e "${GREEN}The following compute drivers are installed:${NC}"
  printf '%s\n' "${installed_drivers[@]}"
  echo "============================================"
}

function print_warning_dev_drivers() {
  if [[ ${#missing_dev_drivers[@]} -eq 0 ]]; then
    return
  fi

  echo -e "${YELLOW}Warning! The following development drivers are missing:${NC}"
  printf '%s\n' "${missing_dev_drivers[@]}"
  echo "You may need to install them if you are using the libs for development."
  echo "============================================"
}

function check_os_drivers() {
  local os_runtime_drivers
  local os_devel_drivers
  local os_version_list
  local os_name_full

  if [[ "$os_name" == "ubuntu" ]]; then
    os_runtime_drivers=("${ubuntu_runtime_drivers[@]}")
    os_devel_drivers=("${ubuntu_devel_drivers[@]}")
    os_version_list=("${ubuntu_version_list[@]}")
    os_name_full="Ubuntu"
  elif [[ "$os_name" == "redhat" ]]; then
    os_runtime_drivers=("${redhat_runtime_drivers[@]}")
    os_devel_drivers=("${redhat_devel_drivers[@]}")
    os_version_list=("${redhat_version_list[@]}")
    os_name_full="Red Hat Enterprise Linux"
  else
    echo "This operating system is not supported."
    return
  fi

  if [[ "${os_version_list[*]}" =~ "$os_version" ]]; then
    echo "Checking for required drivers on $os_name_full $os_version ..."
    missing_drivers=()
    check_drivers "${os_runtime_drivers[@]}"
    print_missing_drivers
    print_installed_drivers
    missing_dev_drivers=()
    check_dev_drivers "${os_devel_drivers[@]}"
    missing_dev_drivers=("${missing_dev_drivers[@]}")
    print_warning_dev_drivers
  else
    echo "This version of $os_name_full is not supported."
    exit 1
  fi
}

echo "Detected operating system: $os_name $os_version"
check_os_drivers
if [[ "${#missing_drivers[@]}" -eq 0 ]]; then
    if [[ "${#missing_dev_drivers[@]}" -gt 0 ]]; then
    	exit 0
    fi
    exit 0
else
    exit 1
fi

#!/bin/bash

os_name="$(awk -F= '/^NAME/{print $2}' /etc/os-release | tr -d '"' | tr '[:upper:]' '[:lower:]')"
os_version="$(awk -F= '/^VERSION_ID/{print $2}' /etc/os-release | tr -d '"')"

ubuntu_version_list=(20.04 22.04)
ubuntu_driver_list=(
  "intel-level-zero-gpu"
  "intel-opencl-icd"
  "level-zero"
  "level-zero-dev"
  "libdrm-common"
  "libdrm2"
  "libdrm-amdgpu1"
  "libdrm-intel1"
  "libdrm-nouveau2"
  "libdrm-dev"
  "libigc1"
  "libigdfcl1"
  "libigdgmm12"
)

redhat_version_list=(8.5)
redhat_driver_list=(
  "intel-igc-core"
  "intel-igc-opencl"
  "intel-gmmlib"
  "intel-opencl"
  "level-zero"
  "level-zero-devel"
  "libdrm"
  "libpciaccess"
  "libpkgconf"
  "pkgconf"
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
  missing_drivers=()
  installed_drivers=()
  for driver in "${driver_list[@]}"; do
    if is_driver_installed "$driver"; then
      driver_version=$(get_driver_version "$driver")
      installed_drivers+=("$driver ($driver_version)")
    else
      missing_drivers+=("$driver")
    fi
  done
}

function print_missing_drivers() {
  echo "============================================"
  echo "The following required drivers are missing:"
  printf '%s\n' "${missing_drivers[@]}"
  echo "============================================"
}

function print_installed_drivers() {
  echo "============================================"
  echo "The following compute drivers are installed:"
  printf '%s\n' "${installed_drivers[@]}"
  echo "============================================"
}

function check_os_drivers() {
  local os_driver_list
  local os_version_list
  local os_name_full

  if [[ "$os_name" == "ubuntu" ]]; then
    os_driver_list=("${ubuntu_driver_list[@]}")
    os_version_list=("${ubuntu_version_list[@]}")
    os_name_full="Ubuntu"
  elif [[ "$os_name" == "redhat" ]]; then
    os_driver_list=("${redhat_driver_list[@]}")
    os_version_list=("${redhat_version_list[@]}")
    os_name_full="Red Hat Enterprise Linux"
  else
    echo "This operating system is not supported."
    return
  fi

  if [[ "${os_version_list[*]}" =~ "$os_version" ]]; then
    echo "Checking for required drivers on $os_name_full $os_version ..."
    driver_list=("${os_driver_list[@]}")
    check_drivers

    if [[ "${#missing_drivers[@]}" -eq 0 ]]; then
      echo "All required drivers are installed."
    else
      print_missing_drivers
    fi

    if [[ "${#installed_drivers[@]}" -ne 0 ]]; then
      print_installed_drivers
    fi
  else
    echo "This version of $os_name_full is not supported."
  fi
}

echo "Detected operating system: $os_name $os_version"
check_os_drivers

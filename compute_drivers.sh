#!/bin/bash

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


os_name="$(awk -F= '/^NAME/{print $2}' /etc/os-release | tr -d '"' | tr '[:upper:]' '[:lower:]')"
os_version="$(awk -F= '/^VERSION_ID/{print $2}' /etc/os-release | tr -d '"')"
echo "Detected operating system: $os_name $os_version"

if [[ "$os_name" == "ubuntu" ]]; then
  if [[ "${ubuntu_version_list[*]}" =~ "$os_version" ]]; then
    echo "Checking for required drivers..."
    missing_drivers=()
    installed_drivers=()
    for driver in "${ubuntu_driver_list[@]}"; do
      if dpkg -s "$driver" > /dev/null 2>&1; then
        driver_version=$(dpkg -s "$driver" | grep Version | awk '{print $2}')
        installed_drivers+=("$driver ($driver_version)")
      else
        missing_drivers+=("$driver")
      fi
    done
    if [[ "${#missing_drivers[@]}" -eq 0 ]]; then
      echo "All required drivers are installed."
    else
      echo "============================================"
      echo "The following required drivers are missing:"
      printf '%s\n' "${missing_drivers[@]}"
      echo "============================================"
    fi
    if [[ "${#installed_drivers[@]}" -ne 0 ]]; then
      echo "============================================"
      echo "The following compute drivers are installed:"
      printf '%s\n' "${installed_drivers[@]}"
      echo "============================================"
    fi
  else
    echo "This version of Ubuntu is not supported."
  fi
elif [[ "$os_name" == "redhat" ]]; then
  if [[ "${redhat_version_list[*]}" =~ "$os_version" ]]; then
    echo "Checking for required drivers..."
    missing_drivers=()
    installed_drivers=()
    for driver in "${redhat_driver_list[@]}"; do
      if rpm -q "$driver" > /dev/null 2>&1; then
        driver_version=$(rpm -q --queryformat '%{VERSION}' "$driver")
        installed_drivers+=("$driver ($driver_version)")
      else
        missing_drivers+=("$driver")
      fi
    done
    if [[ "${#missing_drivers[@]}" -eq 0 ]]; then
      echo "All required drivers are installed."
    else
      echo "============================================"
      echo "The following required drivers are missing:"
      printf '%s\n' "${missing_drivers[@]}"
      echo "============================================"
    fi
    if [[ "${#installed_drivers[@]}" -ne 0 ]]; then
      echo "============================================"
      echo "The following compute drivers are installed:"
      printf '%s\n' "${installed_drivers[@]}"
      echo "============================================"
    fi
  else
    echo "This version of Red Hat Enterprise Linux is not supported."
  fi
else
  echo "This operating system is not supported."
fi


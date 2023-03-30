#!/bin/bash

# Check if setvars.sh can be sourced and sycl-ls is successful
if source /opt/intel/oneapi/setvars.sh > /dev/null && sycl-ls  > /tmp/syclls.txt; then
  SYCL_DEVICES=$(tail -n2 /tmp/syclls.txt)
  echo "Available sycl GPU devices:"
  echo "$SYCL_DEVICES"
  exit 0
else
  echo "Error: setvars.sh could not be sourced or sycl-ls failed"
  echo "If Intel oneAPI basekit is not installed, install from: https://tinyurl.com/yfve55y7"
  exit 1
fi


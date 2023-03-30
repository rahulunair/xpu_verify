#!/bin/env bash

export CPLUS_INCLUDE_PATH=$(echo /usr/include/c++/*):$(echo /usr/include/x86_64-linux-gnu/c++/*):/usr/include
export LIBRARY_PATH=$(dirname $(find /usr/lib /usr/lib64 -name "libstdc++.so" | head -n 1)):$LIBRARY_PATH

if which icpx >/dev/null 2>&1; then
  echo "icpx is in the environment"
cd ./sycl_samples/ && make all > /dev/null &&\
  make run &&\
  make clean > /dev/null
echo "Test passed"
echo "compile and execute sycl programs on the device"
exit 0
else
  echo "icpx is required to compile the program in sycl_samples, but it is not in the environment"
  exit 1
fi

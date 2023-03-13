#!/bin/env bash

if which icpx >/dev/null 2>&1; then
  echo "icpx is in the environment"
cd ./sycl_samples/ && make all > /dev/null &&\
  make run &&\
  make clean > /dev/null
echo "compile and execute sycl programs on the device"
else
  echo "icpx is required to compile the program in sycl_samples, but it is not in the environment"
fi

#!/bin/env bash

echo "check kernel and i915 config"
echo "==================================================="
./check_device.sh
echo ""

echo "check for compute drivers"
echo "==================================================="
./check_compute_drivers.sh
echo ""

echo "check if syclls can list the gpu devices"
echo "==================================================="
./syclls.sh --force
echo ""

echo "compile and execute sycl programs on the device"
echo "==================================================="
./check_sycl.sh
echo ""

echo "check if PyTorch can see the GPU (XPU) device"
echo "==================================================="
./check_pytorch.sh
echo ""

echo "check if TensorFlow can see the GPU (XPU) device"
echo "==================================================="
./check_tensorflow.sh
echo ""

echo "==================================================="

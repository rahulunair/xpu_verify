#!/bin/env bash

CURRENT_DIR=$(pwd)
IMAGE_NAME=intel/intel-extension-for-tensorflow:gpu-flex
if command -v docker &> /dev/null
then
  echo "pulling TensorFlow docker image..."
  # gpu-max tag can be used for PVC
  docker pull "$IMAGE_NAME" &&\
    docker run --rm \
    -v  "$CURRENT_DIR":/workspace \
    -v /dev/dri/by-path:/dev/dri/by-path \
    --device /dev/dri \
    --privileged \
    	  $IMAGE_NAME python ./workspace/tensorflow/xpu_test.py
else
    echo "To run TensorFlow test, docker is required, not found..."
fi

#!/bin/env bash

CURRENT_DIR=$(pwd)
IMAGE_TAG="gpu-flex"  # could be gpu-max also
IMAGE_NAME="intel/intel-extension-for-tensorflow"

if command -v docker &> /dev/null
then
    echo "check if TensorFlow can see the GPU (XPU) device"
    echo "==================================================="
    echo "pulling TensorFlow docker image..."
    if docker pull "$IMAGE_NAME:$IMAGE_TAG"; then
        docker run --rm \
        -v "$CURRENT_DIR":/workspace \
        -v /dev/dri/by-path:/dev/dri/by-path \
        --device /dev/dri \
        --privileged \
        $IMAGE_NAME:IMAGE_TAG python ./workspace/tensorflow/xpu_test.py > output.txt

        if grep -q "XPU devices detected:" output.txt; then
            echo "Tests passed"
            rm output.txt
            exit 0
        else
            echo "Tests failed"
            rm output.txt
            exit 1
        fi
    else
        echo "Failed to pull TensorFlow docker image."
        exit 1
    fi
else
    echo "To run TensorFlow test, docker is required, not found..."
    exit 1
fi

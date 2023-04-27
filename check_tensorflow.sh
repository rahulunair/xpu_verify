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
        CONTAINER_ID=$(docker run -d --rm --privileged $IMAGE_NAME:$IMAGE_TAG sleep infinity)
        
        docker cp ./tensorflow/xpu_test.py $CONTAINER_ID:/xpu_test.py
        docker exec $CONTAINER_ID python /xpu_test.py #> output.txt
        
        #if grep -q "XPU devices detected:" output.txt; then
        #    echo "Tests passed"
        #    rm output.txt
        #    docker stop $CONTAINER_ID
        #    exit 0
        #else
        #    echo "Tests failed"
        #    rm output.txt
        #    docker stop $CONTAINER_ID
        #    exit 1
        #fi
    else
        echo "Failed to pull TensorFlow docker image."
        exit 1
    fi
else
    echo "To run TensorFlow test, docker is required, not found..."
    exit 1
fi

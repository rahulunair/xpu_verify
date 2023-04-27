#!/bin/env bash

CURRENT_DIR=$(pwd)
IMAGE_TAG="xpu-flex"  # could be gpu-max also
IMAGE_NAME="intel/intel-extension-for-pytorch"

if command -v docker &> /dev/null
then
    echo "check if PyTorch can see the GPU (XPU) device"
    echo "==================================================="
    echo "pulling PyTorch docker image..."
    if docker pull "$IMAGE_NAME:$IMAGE_TAG"; then
        CONTAINER_ID=$(docker run -d --rm --privileged $IMAGE_NAME:$IMAGE_TAG sleep infinity)
        
        docker cp ./pytorch/xpu_test.py $CONTAINER_ID:/xpu_test.py
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
        echo "Failed to pull PyTorch docker image."
        exit 1
    fi
else
    echo "To run PyTorch test, docker is required, not found..."
    exit 1
fi

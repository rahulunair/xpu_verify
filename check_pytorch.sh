#!/bin/env bash

CURRENT_DIR=$(pwd)
IMAGE_TAG="xpu-flex"  # can be xpu-max also
IMAGE_NAME="intel/intel-extension-for-pytorch"

if command -v docker &> /dev/null
then
    echo "PyTorch test"
    echo "pulling PyTorch docker image, if not found locally..."
    if docker pull "$IMAGE_NAME:$IMAGE_TAG"; then
        docker run --rm \
        -v "$CURRENT_DIR":/workspace \
        -v /dev/dri/by-path:/dev/dri/by-path \
        --device /dev/dri \
        --privileged \
        "$IMAGE_NAME" python ./workspace/pytorch/xpu_test.py > output.txt

        if grep -q "XPU tests successful!" output.txt; then
            echo "Tests passed"
            rm output.txt
            exit 0
        else
            echo "Tests failed"
            rm output.txt
            exit 1
        fi
    else
        echo "Failed to pull PyTorch docker image."
        exit 1
    fi
else
    echo "To run PyTorch test, docker is required, not found..."
    exit 1
fi

#!/bin/env bash

CURRENT_DIR=$(pwd)
IMAGE_NAME="intel/intel-optimized-pytorch:gpu"

if command -v docker &> /dev/null
then
  echo "PyTorch test"
  echo "pulling PyTorch docker image..."
  docker pull "$IMAGE_NAME" &&\
    docker run --rm  \
	  -v  "$CURRENT_DIR":/workspace \
 	  -v /dev/dri/by-path:/dev/dri/by-path \
 	  --device /dev/dri  \
 	  --privileged  \
   		  "$IMAGE_NAME" python  ./workspace/pytorch/xpu_test.py
else
    echo "To run PyTorch test, docker is required, not found..."
fi
echo ""
echo "==================================================="

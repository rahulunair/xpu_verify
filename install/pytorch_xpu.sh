#!/bin/bash

ENV_NAME="pytorch-xpu"
CONDA_CMD="$HOME/miniconda/condabin/conda"
ENV_PATH="$HOME/miniconda/envs/${ENV_NAME}"
INTEL_PYTORCH_URL="https://intel-optimized-pytorch.s3.cn-north-1.amazonaws.com.cn"
IPEX_VERSION="1.13.10%2Bxpu"
ONECCL_VERSION="1.13.100%2Bgpu"
TORCH_VERSION="1.13.0a0%2Bgitb1dde16"
TORCHVISION_VERSION="0.14.1a0%2B0504df5"
TMP_DIR="/tmp"

if [ -d "$HOME/miniconda" ]; then
  CONDA_CMD="$HOME/miniconda/condabin/conda"
  ENV_PATH="$HOME/miniconda/envs/${ENV_NAME}"
elif [ -d "$HOME/miniconda3" ]; then
  CONDA_CMD="$HOME/miniconda3/condabin/conda"
  ENV_PATH="$HOME/miniconda3/envs/${ENV_NAME}"
else
  echo "Error: Could not find Miniconda directory"
  exit 1
fi

if $CONDA_CMD info --envs | grep -q "${ENV_NAME}"; then
  echo "Installing wget if not available..."
  command -v wget &> /dev/null || sudo -E apt-get install -y wget
  echo "Downloading PyTorch packages..."
  wget "${INTEL_PYTORCH_URL}/ipex_stable/xpu/intel_extension_for_pytorch-${IPEX_VERSION}-cp310-cp310-linux_x86_64.whl" -P "$TMP_DIR"
  wget "${INTEL_PYTORCH_URL}/torch_ccl/xpu/oneccl_bind_pt-${ONECCL_VERSION}-cp310-cp310-linux_x86_64.whl" -P "$TMP_DIR"
  wget "${INTEL_PYTORCH_URL}/ipex_stable/xpu/torch-${TORCH_VERSION}-cp310-cp310-linux_x86_64.whl" -P "$TMP_DIR"
  wget "${INTEL_PYTORCH_URL}/ipex_stable/xpu/torchvision-${TORCHVISION_VERSION}-cp310-cp310-linux_x86_64.whl" -P "$TMP_DIR"
  echo "Installing PyTorch packages in ${ENV_NAME} environment..."
  $ENV_PATH/bin/pip install "${TMP_DIR}/intel_extension_for_pytorch-${IPEX_VERSION}-cp310-cp310-linux_x86_64.whl"
  $ENV_PATH/bin/pip install "${TMP_DIR}/oneccl_bind_pt-${ONECCL_VERSION}-cp310-cp310-linux_x86_64.whl"
  $ENV_PATH/bin/pip install "${TMP_DIR}/torch-${TORCH_VERSION}-cp310-cp310-linux_x86_64.whl"
  $ENV_PATH/bin/pip install "${TMP_DIR}/torchvision-${TORCHVISION_VERSION}-cp310-cp310-linux_x86_64.whl"
  echo "Installing IPython in ${ENV_NAME} environment..."
  $ENV_PATH/bin/pip install ipython
else
  echo "${ENV_NAME} environment not found."
fi

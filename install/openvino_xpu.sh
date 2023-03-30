#!/bin/bash

ENV_NAME="openvino-xpu"
CONDA_CMD="$HOME/miniconda/bin/conda"
ENV_PATH="$HOME/miniconda/envs/${ENV_NAME}"

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
  echo "Installing OpenVINO packages in ${ENV_NAME} environment..."
  $ENV_PATH/bin/pip install openvino==2022.3.0
  $ENV_PATH/bin/pip install openvino-dev==2022.3.0
  echo "Installing IPython in ${ENV_NAME} environment..."
  $ENV_PATH/bin/pip install ipython
else
  echo "${ENV_NAME} environment not found."
fi

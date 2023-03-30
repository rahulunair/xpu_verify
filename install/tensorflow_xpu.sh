#!/bin/bash

ENV_NAME="tensorflow-xpu"
CONDA_CMD="$HOME/miniconda/condabin/conda"
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
  echo "Installing wget if not available..."
  command -v wget &> /dev/null || sudo -E apt-get install -y wget
  echo "Downloading TensorFlow packages..."
  echo "Installing TensorFlow packages in ${ENV_NAME} environment..."
  $ENV_PATH/bin/pip install tensorflow==2.12.0
  $ENV_PATH/bin/pip install --upgrade intel-extension-for-tensorflow[gpu]
  echo "Installing IPython in ${ENV_NAME} environment..."
  $ENV_PATH/bin/pip install ipython
else
  echo "${ENV_NAME} environment not found."
fi

#!/bin/bash

install_miniconda() {
  echo "Miniconda not found. Downloading and installing..."
  wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
  chmod +x Miniconda3-latest-Linux-x86_64.sh
  ./Miniconda3-latest-Linux-x86_64.sh -b -p $HOME/miniconda
  export PATH="$HOME/miniconda/bin:$PATH"
}

create_conda_env() {
  local env_name="$1"
  local env_path=""
  if [ -d "$HOME/miniconda/envs/" ]; then
    env_path="$HOME/miniconda/envs/$env_name"
  elif [ -d "$HOME/miniconda3/envs" ]; then
    env_path="$HOME/miniconda3/envs/$env_name"
  else
    echo "Error: Could not find Miniconda directory"
    exit 1
  fi
  if ! "$CONDA_CMD" info --envs | grep -q "$env_name"; then
    echo "Creating $env_name environment..."
    "$CONDA_CMD" create -y -n "$env_name" python=3.10
    "$env_path"/bin/pip install -U pip
  else
    echo "The $env_name environment already exists."
  fi
}
if ! command -v conda &> /dev/null; then
  install_miniconda
  CONDA_CMD="$HOME/miniconda/condabin/conda"
else
  echo "Miniconda is already installed."
  if [ -x "$(which conda)" ]; then
    CONDA_CMD="conda"
  elif [ -x "$(which $HOME/miniconda/condabin/conda)" ]; then
    CONDA_CMD="$HOME/miniconda/condabin/conda"
  elif [ -x "$(which $HOME/miniconda3/condabin/conda)" ]; then
    CONDA_CMD="$HOME/miniconda3/condabin/conda"
  else
    echo "Error: Could not find Conda binary"
    exit 1
  fi
fi

# Create Conda environments
create_conda_env "pytorch-xpu"
create_conda_env "tensorflow-xpu"
create_conda_env "openvino-xpu"


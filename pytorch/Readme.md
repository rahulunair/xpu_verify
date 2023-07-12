# PyTorch and TensorFlow on Intel XPUs

This repository contains example code for running PyTorch and TensorFlow workloads on Intel XPUs (discrete GPUs).

## Prerequisites

- Intel XPU set up on your system
- Conda environment with PyTorch and/or TensorFlow installed 

## Usage

To run the PyTorch example:

```bash
conda activate pytorch_xpu
python ./pytorch/xpu_test.py

This will perform some basic PyTorch operations on the XPU like random and specific int8/float64 multiplications.

Sample output:

```bash
torch version: 1.13.0a0+git6c9b55e
ipex version: 1.13.120+xpu  
Intel XPU device is available, Device name: Intel(R) Data Center GPU Max 1550
Random int8 multiplication:
  Input x: tensor([[0]], dtype=torch.int8)
  Input y: tensor([[0]], dtype=torch.int8)
  Output z: tensor([[0]], dtype=torch.int8)
  ...
Random float64 multiplication: 
  Input x: tensor([[0.7411]], dtype=torch.float64)
  Input y: tensor([[0.4294]], dtype=torch.float64)
  Output z: tensor([[0.3182]], dtype=torch.float64)
Specific float64 multiplication:
  Input x: tensor([[1., 2.]], dtype=torch.float64)
  Input y: tensor([[3., 4.]], dtype=torch.float64)
  Output z: tensor([[3., 8.]], dtype=torch.float64)
Calculation is correct
```


To run the TensorFlow example:

```bash
conda activate tensorflow_xpu
python ./tensorflow/xpu_test.py
```

This will perform similar multiplication operations using TensorFlow on the XPU.

```bash
TensorFlow version: 2.12.0
XPU devices detected:
name: "/device:XPU:0"
device_type: "XPU" 
...

Random <dtype: 'float64'> multiplication:
  Input x: [[-0.19599483]]
  Input y: [[-1.73269836]]
  Output z: [[0.33959993]]  
Specific <dtype: 'float64'> multiplication:
  Input x: [[1. 2.]]
  Input y: [[3. 4.]]
  Output z: [[3. 8.]]
Calculation is correct  
TensorFLow XPU tests successful!
```

## References

For more information on running PyTorch and TensorFlow on Intel XPUs, see:

[Intel PyTorch EXTENSIONS ↗](https://github.com/intel/intel_extension_for_pytorch)
[Intel TensorFlow ↗](https://github.com/intel/intel_extension_for_tensorflow)

License

This project is licensed under the MIT License - see the LICENSE file for details.

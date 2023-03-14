## Intel GPU sanity tests

### Oneliner:

```bash
git clone https://github.com/unrahul/intel_gpu_tests && cd intel_gpu_tests && sudo ./check_all.sh
```

These tests can be used to see if Intel discrete GPUs have been properly set up on Linux. The following checks can be performed:

- Linux Kernel i915 module loaded and Graphics microcode for the the GPU loaded
- Compute drivers are installed
- `sycl-ls` can list the GPU devices for opencl and level-zero backend  # oneapi basekit required
- `sycl` programs can be compiled using icpx # oneapi basekit required
- PyTorch and TensorFlow can detect XPU device and can run workloads using the device.  # docker required

### How to Use?

1. Verify if the Linux kernel and i915 drivers are in place:

```bash
└❯ ./check_device.sh 
```
Output:

```bash
check kernel and i915 config
===================================================
Checking kernel configuration for intel discrete GPUs
====================================================
Checking if i915 kernel module is loaded...
i915 kernel module is loaded

Checking if the user is in render group...
User is in render group

Checking if Intel discrete GPU is visible as a pcie device...
Intel discrete GPU is visible

Checking if appropriate graphics microcode is loaded in i915
[sudo] password for runnikri: 
Discrete GPU GuC loaded with firmware version: dg2_guc_70.bin version 70.5.1
====================================================
```

2. To check if compute drivers are loaded (Ubuntu and Rhel):

```bash
└❯ ./check_compute_drivers.sh
```
Output:

```bash
check for compute drivers
===================================================
Detected operating system: ubuntu 22.04
Checking for required drivers on Ubuntu 22.04 ...
All required drivers are installed.
============================================
The following compute drivers are installed:
intel-level-zero-gpu (1.3.25018.23+i554~22.04)
intel-opencl-icd (22.49.25018.23+i554~22.04)
level-zero (1.8.8+i524~u22.04)
level-zero-dev (1.8.8+i524~u22.04)
libdrm-common (2.4.112.3+2048~u22.04)
libdrm2 (2.4.112.3+2048~u22.04)
libdrm-amdgpu1 (2.4.112.3+2048~u22.04)
libdrm-intel1 (2.4.112.3+2048~u22.04)
libdrm-nouveau2 (2.4.112.3+2048~u22.04)
libdrm-dev (2.4.112.3+2048~u22.04)
libigc1 (1.0.12812.24+i554~22.04)
libigdfcl1 (1.0.12812.24+i554~22.04)
libigdgmm12 (22.3.3+i550~22.04)
============================================
```

3. To  check if sycl-ls can list GPU devices:

```bash
└❯ ./check_syclls.sh
```

Output:

```bash
check if syclls can list the gpu devices
===================================================
Available sycl GPU devices:
[ext_oneapi_level_zero:gpu:0] Intel(R) Level-Zero, Intel(R) Graphics [0x5693] 1.3 [1.3.25018]
[ext_oneapi_level_zero:gpu:1] Intel(R) Level-Zero, Intel(R) Graphics [0x46a6] 1.3 [1.3.25018]
```

4. To check if sycl programs can be compiled and run using intel compiler `icpx`:

```bash
└❯./check_sycl.sh
```

Output:

```bash
compile and execute sycl programs on the device
===================================================
icpx is in the environment
./device_info
Device name: Intel(R) Graphics [0x5693]
Device memory: 3.75547 GB
Device max compute units: 128
Device max work-group size: 1024
./add_nums
sum 30 random numbers using device: Intel(R) Graphics [0x5693]
15 + 19 = 34
5 + 15 = 20
8 + 13 = 21
17 + 9 = 26
13 + 8 = 21
7 + 19 = 26
18 + 13 = 31
13 + 6 = 19
16 + 12 = 28
6 + 19 = 25
9 + 12 = 21
15 + 18 = 33
11 + 9 = 20
18 + 3 = 21
5 + 4 = 9
17 + 12 = 29
15 + 3 = 18
19 + 15 = 34
16 + 17 = 33
5 + 9 = 14
17 + 4 = 21
0 + 15 = 15
17 + 6 = 23
14 + 6 = 20
18 + 0 = 18
5 + 8 = 13
4 + 12 = 16
18 + 15 = 33
1 + 16 = 17
11 + 18 = 29
./enum_devices
Platform: Intel(R) FPGA Emulation Platform for OpenCL(TM)
	Device: Intel(R) FPGA Emulation Device
Platform: Intel(R) OpenCL
	Device: 12th Gen Intel(R) Core(TM) i7-12700H
Platform: Intel(R) OpenCL HD Graphics
	Device: Intel(R) Graphics [0x5693]
Platform: Intel(R) OpenCL HD Graphics
	Device: Intel(R) Graphics [0x46a6]
Platform: Intel(R) Level-Zero
	Device: Intel(R) Graphics [0x5693]
	Device: Intel(R) Graphics [0x46a6]
compile and execute sycl programs on the device
```

5. To check if PyTorch workloads can be run using the GPU (xpu device):


```bash
└❯./check_pytorch.sh
```

Output:

```bash
check if PyTorch can see the GPU (XPU) device
===================================================
PyTorch test
pulling PyTorch docker image...
gpu: Pulling from intel/intel-optimized-pytorch
Digest: sha256:4d4b06040e9ee8ca4e5055142514b91506cf23880a630f8a912bb58ef61d016e
Status: Image is up to date for intel/intel-optimized-pytorch:gpu
docker.io/intel/intel-optimized-pytorch:gpu
INFO:__main__:Intel XPU device is available
INFO:__main__:Device name: Intel(R) Graphics [0x5693]
WARNING:__main__:Native FP64 type not supported on this platform
INFO:__main__:Random FP16 multiplication:
INFO:__main__:  Input x: tensor([[0.8823]], dtype=torch.float16)
INFO:__main__:  Input y: tensor([[0.9150]], dtype=torch.float16)
INFO:__main__:  Output z: tensor([[0.8071]], dtype=torch.float16)
INFO:__main__:Check if multiplication with two tensors gives expected value
INFO:__main__:Specific FP16 multiplication:
INFO:__main__:  Input x: tensor([[1., 2.]], dtype=torch.float16)
INFO:__main__:  Input y: tensor([[3., 4.]], dtype=torch.float16)
INFO:__main__:  Output z: tensor([[3., 8.]], dtype=torch.float16)
INFO:__main__:Calculation is correct
INFO:__main__:XPU tests successful!

===================================================
```

6. To check if TensorFlow workloads can be run using the GPU (xpu device):

```bash
└❯./check_tesorflow.sh
```

Output:

```bash
check if TensorFlow can see the GPU (XPU) device
===================================================
pulling TensorFlow docker image...
gpu-flex: Pulling from intel/intel-extension-for-tensorflow
Digest: sha256:c2a0ee126befd3b2f5dca78cce3c6f19c6cf0f60d7b4ed615b48efcbfa0198e9
Status: Image is up to date for intel/intel-extension-for-tensorflow:gpu-flex
docker.io/intel/intel-extension-for-tensorflow:gpu-flex
2023-03-14 01:14:41.101399: I tensorflow/core/platform/cpu_feature_guard.cc:193] This TensorFlow binary is optimized with oneAPI Deep Neural Network Library (oneDNN) to use the following CPU instructions in performance-critical operations:  AVX2 AVX_VNNI FMA
To enable them in other operations, rebuild TensorFlow with the appropriate compiler flags.
2023-03-14 01:14:41.222203: I tensorflow/core/util/port.cc:104] oneDNN custom operations are on. You may see slightly different numerical results due to floating-point round-off errors from different computation orders. To turn them off, set the environment variable `TF_ENABLE_ONEDNN_OPTS=0`.
2023-03-14 01:14:41.225826: W tensorflow/compiler/xla/stream_executor/platform/default/dso_loader.cc:64] Could not load dynamic library 'libcudart.so.11.0'; dlerror: libcudart.so.11.0: cannot open shared object file: No such file or directory; LD_LIBRARY_PATH: /opt/intel/oneapi/lib:/opt/intel/oneapi/lib/intel64:
2023-03-14 01:14:41.225842: I tensorflow/compiler/xla/stream_executor/cuda/cudart_stub.cc:29] Ignore above cudart dlerror if you do not have a GPU set up on your machine.
2023-03-14 01:14:41.908520: W tensorflow/compiler/xla/stream_executor/platform/default/dso_loader.cc:64] Could not load dynamic library 'libnvinfer.so.7'; dlerror: libnvinfer.so.7: cannot open shared object file: No such file or directory; LD_LIBRARY_PATH: /opt/intel/oneapi/lib:/opt/intel/oneapi/lib/intel64:
2023-03-14 01:14:41.908600: W tensorflow/compiler/xla/stream_executor/platform/default/dso_loader.cc:64] Could not load dynamic library 'libnvinfer_plugin.so.7'; dlerror: libnvinfer_plugin.so.7: cannot open shared object file: No such file or directory; LD_LIBRARY_PATH: /opt/intel/oneapi/lib:/opt/intel/oneapi/lib/intel64:
2023-03-14 01:14:41.908606: W tensorflow/compiler/tf2tensorrt/utils/py_utils.cc:38] TF-TRT Warning: Cannot dlopen some TensorRT libraries. If you would like to use Nvidia GPU with TensorRT, please make sure the missing libraries mentioned above are installed properly.
2023-03-14 01:14:42.775994: I itex/core/devices/gpu/itex_gpu_runtime.cc:129] Selected platform: Intel(R) Level-Zero
2023-03-14 01:14:42.776031: I itex/core/devices/gpu/itex_gpu_runtime.cc:154] number of sub-devices is zero, expose root device.
2023-03-14 01:14:42.776036: I itex/core/devices/gpu/itex_gpu_runtime.cc:154] number of sub-devices is zero, expose root device.
2023-03-14 01:14:42.776255: W tensorflow/compiler/xla/stream_executor/platform/default/dso_loader.cc:64] Could not load dynamic library 'libcuda.so.1'; dlerror: libcuda.so.1: cannot open shared object file: No such file or directory; LD_LIBRARY_PATH: /opt/intel/oneapi/lib:/opt/intel/oneapi/lib/intel64:
2023-03-14 01:14:42.776266: W tensorflow/compiler/xla/stream_executor/cuda/cuda_driver.cc:265] failed call to cuInit: UNKNOWN ERROR (303)
2023-03-14 01:14:42.776285: I tensorflow/compiler/xla/stream_executor/cuda/cuda_diagnostics.cc:156] kernel driver does not appear to be running on this host (c4df3ead4b0c): /proc/driver/nvidia/version does not exist
2023-03-14 01:14:42.974360: I tensorflow/core/platform/cpu_feature_guard.cc:193] This TensorFlow binary is optimized with oneAPI Deep Neural Network Library (oneDNN) to use the following CPU instructions in performance-critical operations:  AVX2 AVX_VNNI FMA
To enable them in other operations, rebuild TensorFlow with the appropriate compiler flags.
2023-03-14 01:14:42.975411: I tensorflow/core/common_runtime/pluggable_device/pluggable_device_factory.cc:306] Could not identify NUMA node of platform XPU ID 0, defaulting to 0. Your kernel may not have been built with NUMA support.
2023-03-14 01:14:42.975426: I tensorflow/core/common_runtime/pluggable_device/pluggable_device_factory.cc:306] Could not identify NUMA node of platform XPU ID 1, defaulting to 0. Your kernel may not have been built with NUMA support.
2023-03-14 01:14:42.975450: I tensorflow/core/common_runtime/pluggable_device/pluggable_device_factory.cc:272] Created TensorFlow device (/device:XPU:0 with 0 MB memory) -> physical PluggableDevice (device: 0, name: XPU, pci bus id: <undefined>)
2023-03-14 01:14:42.975773: I tensorflow/core/common_runtime/pluggable_device/pluggable_device_factory.cc:272] Created TensorFlow device (/device:XPU:1 with 0 MB memory) -> physical PluggableDevice (device: 1, name: XPU, pci bus id: <undefined>)
[name: "/device:CPU:0"
device_type: "CPU"
memory_limit: 268435456
locality {
}
incarnation: 17404753498867757733
xla_global_id: -1
, name: "/device:XPU:0"
device_type: "XPU"
locality {
  bus_id: 1
}
incarnation: 14973945165464988944
physical_device_desc: "device: 0, name: XPU, pci bus id: <undefined>"
xla_global_id: -1
, name: "/device:XPU:1"
device_type: "XPU"
locality {
  bus_id: 1
}
incarnation: 8102261655652644080
physical_device_desc: "device: 1, name: XPU, pci bus id: <undefined>"
xla_global_id: -1
]
XPU test successful!

===================================================
```

7. To run all tests:

```bash
 |base|💁  unrahul @ 💻  minicle in 📁  intel_gpu_tests on 🌿  main ✓
└❯ ./check_all.sh 
```

Output:

```bash

check kernel and i915 config
===================================================
Checking kernel configuration for intel discrete GPUs
====================================================
Checking if i915 kernel module is loaded...
i915 kernel module is loaded

Checking if the user is in render group...
User is in render group

Checking if Intel discrete GPU is visible as a pcie device...
Intel discrete GPU is visible

Checking if appropriate graphics microcode is loaded in i915
[sudo] password for runnikri: 
Discrete GPU GuC loaded with firmware version: dg2_guc_70.bin version 70.5.1
====================================================


check for compute drivers
===================================================
Detected operating system: ubuntu 22.04
Checking for required drivers on Ubuntu 22.04 ...
All required drivers are installed.
============================================
The following compute drivers are installed:
intel-level-zero-gpu (1.3.25018.23+i554~22.04)
intel-opencl-icd (22.49.25018.23+i554~22.04)
level-zero (1.8.8+i524~u22.04)
level-zero-dev (1.8.8+i524~u22.04)
libdrm-common (2.4.112.3+2048~u22.04)
libdrm2 (2.4.112.3+2048~u22.04)
libdrm-amdgpu1 (2.4.112.3+2048~u22.04)
libdrm-intel1 (2.4.112.3+2048~u22.04)
libdrm-nouveau2 (2.4.112.3+2048~u22.04)
libdrm-dev (2.4.112.3+2048~u22.04)
libigc1 (1.0.12812.24+i554~22.04)
libigdfcl1 (1.0.12812.24+i554~22.04)
libigdgmm12 (22.3.3+i550~22.04)
============================================

check if syclls can list the gpu devices
===================================================
Available sycl GPU devices:
[ext_oneapi_level_zero:gpu:0] Intel(R) Level-Zero, Intel(R) Graphics [0x5693] 1.3 [1.3.25018]
[ext_oneapi_level_zero:gpu:1] Intel(R) Level-Zero, Intel(R) Graphics [0x46a6] 1.3 [1.3.25018]

compile and execute sycl programs on the device
===================================================
icpx is in the environment
./device_info
Device name: Intel(R) Graphics [0x5693]
Device memory: 3.75547 GB
Device max compute units: 128
Device max work-group size: 1024
./add_nums
sum 30 random numbers using device: Intel(R) Graphics [0x5693]
15 + 19 = 34
5 + 15 = 20
8 + 13 = 21
17 + 9 = 26
13 + 8 = 21
...
...
./enum_devices
Platform: Intel(R) FPGA Emulation Platform for OpenCL(TM)
	Device: Intel(R) FPGA Emulation Device
Platform: Intel(R) OpenCL
	Device: 12th Gen Intel(R) Core(TM) i7-12700H
Platform: Intel(R) OpenCL HD Graphics
	Device: Intel(R) Graphics [0x5693]
Platform: Intel(R) OpenCL HD Graphics
	Device: Intel(R) Graphics [0x46a6]
Platform: Intel(R) Level-Zero
	Device: Intel(R) Graphics [0x5693]
	Device: Intel(R) Graphics [0x46a6]
compile and execute sycl programs on the device

check if PyTorch can see the GPU (XPU) device
===================================================
PyTorch test
pulling PyTorch docker image...
gpu: Pulling from intel/intel-optimized-pytorch
Digest: sha256:4d4b06040e9ee8ca4e5055142514b91506cf23880a630f8a912bb58ef61d016e
Status: Image is up to date for intel/intel-optimized-pytorch:gpu
docker.io/intel/intel-optimized-pytorch:gpu
INFO:__main__:Intel XPU device is available
INFO:__main__:Device name: Intel(R) Graphics [0x5693]
WARNING:__main__:Native FP64 type not supported on this platform
INFO:__main__:Random FP16 multiplication:
INFO:__main__:  Input x: tensor([[0.8823]], dtype=torch.float16)
INFO:__main__:  Input y: tensor([[0.9150]], dtype=torch.float16)
INFO:__main__:  Output z: tensor([[0.8071]], dtype=torch.float16)
INFO:__main__:Check if multiplication with two tensors gives expected value
INFO:__main__:Specific FP16 multiplication:
INFO:__main__:  Input x: tensor([[1., 2.]], dtype=torch.float16)
INFO:__main__:  Input y: tensor([[3., 4.]], dtype=torch.float16)
INFO:__main__:  Output z: tensor([[3., 8.]], dtype=torch.float16)
INFO:__main__:Calculation is correct
INFO:__main__:XPU tests successful!

===================================================

check if TensorFlow can see the GPU (XPU) device
===================================================
pulling TensorFlow docker image...
gpu-flex: Pulling from intel/intel-extension-for-tensorflow
Digest: sha256:c2a0ee126befd3b2f5dca78cce3c6f19c6cf0f60d7b4ed615b48efcbfa0198e9
Status: Image is up to date for intel/intel-extension-for-tensorflow:gpu-flex
docker.io/intel/intel-extension-for-tensorflow:gpu-flex
2023-03-14 01:14:41.101399: I tensorflow/core/platform/cpu_feature_guard.cc:193] This TensorFlow binary is optimized with oneAPI Deep Neural Network Library (oneDNN) to use the following CPU instructions in performance-critical operations:  AVX2 AVX_VNNI FMA
...
...
2023-03-14 01:14:42.975426: I tensorflow/core/common_runtime/pluggable_device/pluggable_device_factory.cc:306] Could not identify NUMA node of platform XPU ID 1, defaulting to 0. Your kernel may not have been built with NUMA support.
2023-03-14 01:14:42.975450: I tensorflow/core/common_runtime/pluggable_device/pluggable_device_factory.cc:272] Created TensorFlow device (/device:XPU:0 with 0 MB memory) -> physical PluggableDevice (device: 0, name: XPU, pci bus id: <undefined>)
2023-03-14 01:14:42.975773: I tensorflow/core/common_runtime/pluggable_device/pluggable_device_factory.cc:272] Created TensorFlow device (/device:XPU:1 with 0 MB memory) -> physical PluggableDevice (device: 1, name: XPU, pci bus id: <undefined>)
[name: "/device:CPU:0"
device_type: "CPU"
memory_limit: 268435456
locality {
}
incarnation: 17404753498867757733
xla_global_id: -1
, name: "/device:XPU:0"
device_type: "XPU"
locality {
  bus_id: 1
}
incarnation: 14973945165464988944
physical_device_desc: "device: 0, name: XPU, pci bus id: <undefined>"
xla_global_id: -1
, name: "/device:XPU:1"
device_type: "XPU"
locality {
  bus_id: 1
}
incarnation: 8102261655652644080
physical_device_desc: "device: 1, name: XPU, pci bus id: <undefined>"
xla_global_id: -1
]
XPU test successful!

===================================================
```

If you would rather not use the provided automated scripts and prefer to execute the commands manually, you can refer to this [gist](https://gist.github.com/unrahul/7813841506677fe8b3d381fd82d3385d) for more information . It provides additional explanations on some of the commands used here.


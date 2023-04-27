# Intel GPU Sanity Tests

'xpu-verify' tool provides a comprehensive set of tests and automated fixes to help ensure that Intel discrete GPUs have been correctly set up on Linux systems. The tool supports various distributions, such as Ubuntu (20.04 and 22.04), RHEL, and Fedora.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Usage](#usage)
  - [Check System Setup](#check-system-setup)
  - [Fix System Setup](#fix-system-scripts)
  - [Check and Fix System Setup](#combined-test-and-fix)
  - [AI Libraries Installation](#ai-libraries-installation)
- [Supported Tests](#supported-tests)
- [Additional Checks](#additional-checks)

## Prerequisites

- Ensure that the kernel, compute drivers, and other necessary components for Intel discrete GPUs have been set up according to the [Intel GPU documentation](https://dgpu-docs.intel.com/installation-guides/index.html).
- To run SYCL tests, install the `intel-oneapi-compiler-dpcpp-cpp` package, which includes the oneAPI compiler. For installation instructions on Ubuntu, refer to this [link](https://www.intel.com/content/www/us/en/docs/oneapi/installation-guide-linux/2023-0/apt.html), and for RHEL, SUSE, and other similar systems, refer to this [link](https://www.intel.com/content/www/us/en/docs/oneapi/installation-guide-linux/2023-0/yum-dnf-zypper.html).
- To run AI tests, Docker is required.

## Installation

Clone the Intel GPU sanity tests repository and navigate to the directory:

```bash
└❯ git clone https://github.com/unrahul/xpu_verify && cd xpu_verify
```

### Usage

#### Checking System Setup

To check if the system is set up correctly for Intel discrete GPUs, run the script with the -c option:

```bash
└❯ ./xpu_verify.sh -c
```
#### Fix System Setup

To fix and augment the system setup with essential tools and libraries for Intel discrete GPUs, run the script with the -f option:

```bash
└❯ ./xpu_verify.sh -f
```

#### Check and Fix System Setup

To check and fix the system setup for Intel discrete GPUs, run the script with the -p option:

```bash
└❯ ./xpu_verify.sh -p
```

#### AI Libraries Installation

To install specific AI packages with XPU support (e.g., openvino_xpu, pytorch_xpu, tensorflow_xpu, ai_xpu), run:

```
└❯ ./xpu_verify.sh -i pkg1, pkg2,...
```

## Supported Tests

The following tests can be performed:

##### Linux Kernel i915 Module and Graphics Microcode

This test checks if the Linux Kernel i915 module is loaded and the Graphics microcode for the GPU is loaded.

```bash
└❯ ./check_device.sh
```

##### Check OS kernel and version

```bash
└❯ ./check_os_kernel.sh
```

##### Compute Drivers

This test checks if the necessary intel compute drivers are installed.

```bash
└❯ ./check_compute_drivers.sh
```

##### GPU Devices Listing

This test verifies if sycl-ls can list the GPU devices for OpenCL and Level-Zero backends. The oneAPI basekit is required for this test.

```bash
└❯ ./syclls.sh --force
```

##### Check if Intel basekit is installed

```bash
└❯ ./check_intel_basekit.sh
```

##### SYCL Programs Compilation

This test checks if sycl programs can be compiled using icpx. The oneAPI basekit is required for this test.

```bash
└❯ ./check_sycl.sh
```

##### Check scaling governer

```bash
└❯ ./scaling_governor.sh
```

##### PyTorch and TensorFlow XPU Device Detection

This test checks if PyTorch and TensorFlow can detect the XPU device and run workloads using the device. Docker is required for this test.

For PyTorch:

```bash
└❯ ./check_pytorch.sh
```
For TensorFlow:

```bash
└❯ ./check_tensorflow.sh
```

##### Additional Checks

Check if network proxy is setup, print the proxy, remove proxy settings and restore proxy settings:

```bash
└❯ ./proxy_helper.sh
```
## Contributing

Contributions to improve and expand the Intel GPU sanity tests are welcome. If you are interested in contributing, please consider the following areas:

1. **Adding more tests**: Continuously improving the coverage of tests is valuable. If you have a specific test or benchmark in mind that would help validate the Intel discrete GPU setup, feel free to create a new script and submit a pull request.

2. **Bug fixes and improvements**: If you find any bugs or areas where the existing tests can be improved, please report the issue or submit a pull request with your proposed changes.

3. **Platform support**: The goal is to support a wide range of Linux distributions and kernel versions. If you have experience with a specific distribution and would like to ensure the tests work correctly on it, your help would be appreciated.

4. **Documentation**: Clear and comprehensive documentation is essential for users to understand and effectively use the tool. If you find areas where the documentation can be improved or expanded, please submit your suggestions or create a pull request with your proposed changes.

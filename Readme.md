## Intel GPU sanity tests

Use these tests to verify if you have the GPU setup correctly.

To check if Linux kernel and compute drivers are in place:

```bash
make test kernel_compute
```

To check if sycl programs can be compiled and run using intel compiler `icpx`:

```bash
make test sycl
```

To check if AI workloads can be run using the GPU (xpu device):

```bash
make test dl
```

To run all tests:

```bash
make test all
```


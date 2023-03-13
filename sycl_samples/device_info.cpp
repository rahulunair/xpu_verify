#include <CL/sycl.hpp>
using namespace sycl;

int main() {
      device dev;
    try {
        dev = sycl::device(sycl::gpu_selector_v);
    }
    catch (sycl::exception const &e) {
        dev = sycl::device(sycl::cpu_selector_v);
    }

  std::cout << "Device name: " << dev.get_info<info::device::name>() << std::endl;
  std::cout << "Device memory: " << static_cast<float>(dev.get_info<info::device::global_mem_size>()) / (1024.0f * 1024.0f * 1024.0f) << " GB" << std::endl;
  std::cout << "Device max compute units: " << dev.get_info<info::device::max_compute_units>() << std::endl;
  std::cout << "Device max work-group size: " << dev.get_info<info::device::max_work_group_size>() << std::endl;
}

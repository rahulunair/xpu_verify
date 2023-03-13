#include <CL/sycl.hpp>
#include <iostream>

using namespace sycl;

int main() {
  std::srand(std::time(nullptr));
  const size_t n = 30;
  std::vector<int> a(n, 1), b(n, 2), c(n, 0);
  queue q(default_selector_v);
  std::cout << "sum " << n << " random numbers using device: " << q.get_device().get_info<info::device::name>() << std::endl;  
  for (size_t i = 0; i < n; ++i) {
   a[i] = std::rand() % 20;
   b[i] = std::rand() % 20;
  }
  {
    buffer<int, 1> a_buf(a.data(), range<1>{n});
    buffer<int, 1> b_buf(b.data(), range<1>{n});
    buffer<int, 1> c_buf(c.data(), range<1>{n});

    q.submit([&](handler& h) {
      auto a_acc = a_buf.get_access<access::mode::read>(h);
      auto b_acc = b_buf.get_access<access::mode::read>(h);
      auto c_acc = c_buf.get_access<access::mode::write>(h);
      h.parallel_for(range<1>{n}, [=](id<1> i) {
        c_acc[i] = a_acc[i] + b_acc[i];
      });
    });
  }
  for (size_t i = 0; i < n; ++i) {
    std::cout << a[i] << " + " << b[i] << " = " << c[i] << std::endl;
  }

  return 0;
}

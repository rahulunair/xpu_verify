export CPLUS_INCLUDE_PATH=$(echo /usr/include/c++/*):$(echo /usr/include/x86_64-linux-gnu/c++/*):/usr/include
export LIBRARY_PATH=$(dirname $(find /usr/lib /usr/lib64 -name "libstdc++.so" | head -n 1)):$LIBRARY_PATH

if which icpx >/dev/null 2>&1; then
  echo "icpx is in the environment"
  echo "sleeping for 5 seconds..."
  sleep 5
  cd ./sycl_samples/ && \
  make all > /dev/null
  build_status=$?
  if [ $build_status -eq 0 ]; then
    make run
    run_status=$?
    if [ $run_status -eq 0 ]; then
      make clean > /dev/null
      clean_status=$?
      if [ $clean_status -eq 0 ]; then
        echo "compile and execute sycl programs on the device"
        exit 0
      else
        echo "Error: 'make clean' failed"
        exit $clean_status
      fi
    else
      echo "Error: 'make run' failed"
      exit $run_status
    fi
  else
    echo "Error: 'make all' failed"
    exit $build_status
  fi
else
  echo "icpx is required to compile the program in sycl_samples, but it is not in the environment"
  exit 1
fi

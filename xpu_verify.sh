#!/bin/bash


remove_local_repo() {
    echo "remove local repo"
    echo "==================================================="
    ./fixes/remove_local_repo.sh
    echo ""
}

check_fix_scaling_governer() {
    echo "check and fix scaling governor"
    echo "==================================================="
    ./fixes/check_fix_scaling_governor.sh
    echo ""
}

fix_set_render_group() {
    echo "check if user in render group and fix if not"
    echo "==================================================="
    ./fixes/check_set_render_group.sh
    echo ""
}

install_intel_basekit() {
    echo "check if intel basekit is installed and fix if not"
    echo "==================================================="
    ./install/intel_basekit.sh
    echo ""
}

install_miniconda_and_envs() {
    echo "check if miniconda and environments are installed and fix if not"
    echo "==================================================="
    ./install/miniconda_and_envs.sh
    echo ""
}

install_pytorch_xpu() {
    echo "check if pytorch-xpu is installed and fix if not"
    echo "==================================================="
    ./install/pytorch_xpu.sh
    echo ""
}

install_tensorflow_xpu() {
    echo "check if tensorflow-xpu is installed and fix if not"
    echo "==================================================="
    ./install/tensorflow_xpu.sh
    echo ""
}

install_openvino_xpu() {
    echo "check if openvino is installed and fix if not"
    echo "==================================================="
    ./install/openvino_xpu.sh
    echo ""
}

install_ai_xpu() {
    install_openvino_xpu
    install_pytorch_xpu
    install_tensorflow_xpu
}

check_all() {
    all_tests_passed=true

    check_functions=(
        "./check_os_kernel.sh"
        "./check_scaling_governor.sh"
        "./check_device.sh"
        "./check_compute_drivers.sh"
        "./check_render_group.sh"
        "./check_intel_basekit.sh"
        "./syclls.sh --force"
        "./check_sycl.sh"
        "./check_pytorch.sh"
        "./check_tensorflow.sh"
    )

    check_names=(
        "check OS and kernel version"
        "check scaling governor"
        "check kernel and i915 config"
        "check for compute drivers"
        "check if user in render group"
        "check if Intel Basekit is installed"
        "check if syclls can list the GPU devices"
        "compile and execute SYCL programs on the device"
        "check if PyTorch can see the GPU (XPU) device"
        "check if TensorFlow can see the GPU (XPU) device"
    )

    for index in "${!check_functions[@]}"; do
        check_function=${check_functions[index]}
        check_name=${check_names[index]}

        echo "Running ${check_name}"
        echo "==================================================="
        ${check_function}
        result=$?
        echo "result of $check_name test is: $result"
        if [ ${result} -ne 0 ] && [ "$check_name" != "check for compute drivers" ]; then
            all_tests_passed=false
        elif [ ${result} -ne 0 ] && [ "$check_name" == "check for compute drivers" ]; then
            missing_runtime_drivers=$(./check_compute_drivers.sh | grep "The following required drivers are missing")
            if [ -z "$missing_runtime_drivers" ]; then
                all_tests_passed=true
            else
                all_tests_passed=false
            fi
        fi
    done

    if $all_tests_passed; then
        echo "All checks ran successfully."
    else
        echo "Some checks have failed. Please review the output for more information."
    fi
}

# check and fix options
while getopts "cfpi:" opt; do
    case "$opt" in
        c)
            check_all
            exit 0
            ;;
        f)
            fix_set_render_group
            check_fix_scaling_governer
            remove_local_repo
            ./check_intel_basekit.sh
            intel_basekit_status=$?
            if [ $intel_basekit_status -eq 0 ]; then
                echo ""
            else
                echo "intel-basekit is not installed, installing..."
                install_intel_basekit
            fi
            
            exit 0
            ;;
        p)
            check_all
            fix_set_render_group
            check_fix_scaling_governer
            remove_local_repo
            ./check_intel_basekit.sh
            intel_basekit_status=$?
            if [ $intel_basekit_status -eq 0 ]; then
                echo ""
            else
                echo "intel-basekit is not installed, installing..."
                install_intel_basekit
            fi
            exit 0
            ;;
        i)
            IFS=',' read -ra INSTALL_OPTS <<< "$OPTARG"
            for i in "${INSTALL_OPTS[@]}"; do
                ./check_os_kernel.sh
                os_kernel_check_status=$?
                ./check_compute_drivers.sh
                compute_drivers_check_status=$?
                ./check_intel_basekit.sh
                intel_basekit_check_status=$?
                install_miniconda_and_envs
                if [ $os_kernel_check_status -eq 0 ] && [ $compute_drivers_check_status -eq 0 ] && [ $intel_basekit_check_status -eq 0 ]; then
                    case "$i" in
                        openvino_xpu) install_miniconda_and_envs && install_openvino_xpu ;;
                        pytorch_xpu) install_miniconda_and_envs && install_pytorch_xpu ;;
                        tensorflow_xpu) install_miniconda_and_envs && install_tensorflow_xpu ;;
                        ai_xpu) install_ai_xpu ;;
                        *) echo "Invalid installation option: $i" ;;
                    esac
                else
                    echo "Please use '-c' with the script to ensure that the system has the correct OS kernel, compute drivers, and Intel basekit installed before installing XPU libraries."
                fi
            done
            exit 0
            ;;
        *)
            echo "Invalid option: -$OPTARG" >&2
            exit 1
            ;;
    esac
done

echo "Usage: ./check_all.sh [-c] [-f] [-p] [-i library1,library2,...]"
echo "-c: check if the system is setup correctly"
echo "-f: fix and augment with essential tools and libs"
echo "-p: check and fix"
echo "-i: install specified AI packages with XPU support (openvino_xpu, pytorch_xpu, tensorflow_xpu, ai_xpu)"
exit 1

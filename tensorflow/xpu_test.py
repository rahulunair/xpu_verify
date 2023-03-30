import os
os.environ['TF_CPP_MIN_LOG_LEVEL'] = '2'

import warnings
warnings.filterwarnings('ignore')
import sys
import tensorflow as tf
from tensorflow.python.client import device_lib

def check_for_xpu_devices():
    try:
        devices = device_lib.list_local_devices()
    except Exception as e:
        print(f"Error while listing local devices: {e}")
        sys.exit(1)
    xpu_devices = [device for device in devices if device.device_type == "XPU"]
    if not xpu_devices:
        print("TensorFlow cannot detect an XPU.")
        return False
    else:
        print("XPU devices detected:")
        for xpu_device in xpu_devices:
            print(xpu_device)
        return True

def main():
    xpu_detected = check_for_xpu_devices()
    if not xpu_detected:
        sys.exit(1)

if __name__ == "__main__":
    main()

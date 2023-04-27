import os
import sys
import warnings

os.environ["TF_CPP_MIN_LOG_LEVEL"] = "2"
warnings.filterwarnings("ignore")

import argparse
import numpy as np
import tensorflow as tf
from tensorflow.python.client import device_lib


GREEN = "\033[32m"
YELLOW = "\033[33m"
RED = "\033[31m"
RESET = "\033[0m"

def colorize(text, color):
    return f"{color}{text}{RESET}"

def test_random_multiplication(dtype=tf.float32):
    try:
        print(colorize(f"Random {dtype} multiplication:", GREEN))
        if dtype.is_integer:
            x_np = np.random.randint(low=np.iinfo(dtype.as_numpy_dtype).min,
                                     high=np.iinfo(dtype.as_numpy_dtype).max, size=(1, 1))
            y_np = np.random.randint(low=np.iinfo(dtype.as_numpy_dtype).min,
                                     high=np.iinfo(dtype.as_numpy_dtype).max, size=(1, 1))
            x = tf.convert_to_tensor(x_np, dtype=dtype)
            y = tf.convert_to_tensor(y_np, dtype=dtype)
        else:
            x = tf.random.normal((1, 1), dtype=dtype)
            y = tf.random.normal((1, 1), dtype=dtype)
        with tf.device("XPU:0"):
            z = x * y
        print("  Input x:", x.numpy())
        print("  Input y:", y.numpy())
        print("  Output z:", z.numpy())
    except Exception as e:
        print(colorize(f"Error during {dtype} random multiplication: {e}", RED))
        exit(1)

def test_specific_multiplication(dtype=tf.float32):
    try:
        print(colorize(f"Specific {dtype} multiplication:", GREEN))
        if dtype.is_integer:
            x = tf.constant([[1, 2]], dtype=dtype)
            y = tf.constant([[3, 4]], dtype=dtype)
            z_expected = tf.constant([[3, 8]], dtype=dtype)
        else:
            x = tf.constant([[1.0, 2.0]], dtype=dtype)
            y = tf.constant([[3.0, 4.0]], dtype=dtype)
            z_expected = tf.constant([[3.0, 8.0]], dtype=dtype)
        with tf.device("XPU:0"):
            z = x * y
        print("  Input x:", x.numpy())
        print("  Input y:", y.numpy())
        print("  Output z:", z.numpy())
        if dtype == tf.bfloat16:
            z = tf.cast(z, tf.float32)
            z_expected = tf.cast(z_expected, tf.float32)
        if np.allclose(z, z_expected):
            print("Calculation is correct")
        else:
            print("Calculation is incorrect")
    except Exception as e:
        print(colorize(f"Error during {dtype} specific multiplication: {e}", RED))
        exit(1)

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
   
def main(args):
    try:
        print(f"TensorFlow version: {tf.__version__}")
        np.random.seed(args.seed)
        tf.random.set_seed(args.seed)
        xpu_detected = check_for_xpu_devices()
        if xpu_detected:
            data_types = [
                tf.int8,
                tf.int16,
                tf.int32,
                tf.int64,
                tf.float16,
                tf.float32,
                tf.bfloat16,
                tf.float64,
            ]
            for dtype in data_types:
                test_random_multiplication(dtype)
                test_specific_multiplication(dtype)
        else:
            raise Exception("XPU device not detected")
        print(colorize("TensorFLow XPU tests successful!", GREEN))
    except ImportError as e:
        print(colorize(f"Failed to import TensorFlow: {e}", RED))
    except Exception as e:
        print(colorize(f"An error occurred during the test: {e}", RED))



if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Test XPU device with TensorFlow")
    parser.add_argument("--seed", type=int, default=42, help="Random seed")
    args = parser.parse_args()
    main(args)

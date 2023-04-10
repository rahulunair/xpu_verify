import warnings
warnings.filterwarnings("ignore")

import argparse
import torch

def test_random_multiplication(dtype=torch.float32):
    try:
        print(f"Random {dtype.__str__().split('.')} multiplication:")
        x = torch.rand(1, 1).to('xpu', dtype=dtype)
        y = torch.rand(1, 1).to('xpu', dtype=dtype)
        z = x * y
        print("  Input x:", x.cpu())
        print("  Input y:", y.cpu())
        print("  Output z:", z.cpu())
    except Exception as e:
        print(f"Error during {dtype.__str__().split('.')} random multiplication:", e)
        exit(1)

def test_specific_multiplication(dtype=torch.float32):
    try:
        print(f"Specific {dtype.__str__().split('.')} multiplication:")
        x = torch.tensor([[1.0, 2.0]]).to('xpu', dtype=dtype)
        y = torch.tensor([[3.0, 4.0]]).to('xpu', dtype=dtype)
        z_expected = torch.tensor([[3.0, 8.0]]).to('xpu', dtype=dtype)
        z = x * y
        print("  Input x:", x.cpu())
        print("  Input y:", y.cpu())
        print("  Output z:", z.cpu())
        if torch.allclose(z, z_expected):
            print("Calculation is correct")
        else:
            print("Calculation is incorrect")
    except Exception as e:
        print(f"Error during {dtype.__str__().split('.')} specific multiplication:", e)
        exit(1)

def main(args):
    try:
        print(f"torch version: {torch.__version__}")
        torch.manual_seed(args.seed)
        import intel_extension_for_pytorch as ipex
        ipex.xpu.seed_all()
        if ipex.xpu.is_available():
            print(f"ipex version: {ipex.__version__}")
            print("Intel XPU device is available")
            device_name = ipex.xpu.get_device_name()
            print(f"Device name: {device_name}")
            if not ipex.xpu.has_fp64_dtype():
                print("Warning: Native FP64 type not supported on this platform")

            data_types = [torch.int8, torch.int16, torch.int32, torch.int64, 
                          torch.float16, torch.float32, torch.bfloat16, torch.float64]
            for dtype in data_types:
                if dtype == torch.float64 and not ipex.xpu.has_fp64_dtype():
                    print("Skipping FP64 tests, as the device doesn't support it.")
                    continue
                test_random_multiplication(dtype)
                test_specific_multiplication(dtype)

        else:
            print("Warning: Intel XPU device is not available")
            raise Exception("Intel XPU device not detected")
        print("XPU tests successful!")
    except ImportError as e:
        print("Failed to import Intel Extension for PyTorch:", e)
    except Exception as e:
        print("An error occurred during the test:", e)

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Test Intel XPU device')
    parser.add_argument('--seed', type=int, default=42, help='Random seed')
    args = parser.parse_args()
    main(args)


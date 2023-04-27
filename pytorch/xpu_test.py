import warnings

warnings.filterwarnings("ignore")

import argparse
import torch

GREEN = "\033[32m"
YELLOW = "\033[33m"
RED = "\033[31m"
RESET = "\033[0m"


def colorize(text, color):
    return f"{color}{text}{RESET}"


def test_random_multiplication(dtype=torch.float32):
    try:
        print(
            colorize(f"Random {dtype.__str__().split('.')[-1]} multiplication:", GREEN)
        )
        x = torch.rand(1, 1).to("xpu", dtype=dtype)
        y = torch.rand(1, 1).to("xpu", dtype=dtype)
        z = x * y
        print("  Input x:", x.cpu())
        print("  Input y:", y.cpu())
        print("  Output z:", z.cpu())
    except Exception as e:
        print(
            colorize(
                f"Error during {dtype.__str__().split('.')} random multiplication: {e}",
                RED,
            )
        )
        exit(1)


def test_specific_multiplication(dtype=torch.float32):
    try:
        print(
            colorize(
                f"Specific {dtype.__str__().split('.')[-1]} multiplication:", GREEN
            )
        )
        x = torch.tensor([[1.0, 2.0]]).to("xpu", dtype=dtype)
        y = torch.tensor([[3.0, 4.0]]).to("xpu", dtype=dtype)
        z_expected = torch.tensor([[3.0, 8.0]]).to("xpu", dtype=dtype)
        z = x * y
        print("  Input x:", x.cpu())
        print("  Input y:", y.cpu())
        print("  Output z:", z.cpu())
        if torch.allclose(z, z_expected):
            print("Calculation is correct")
        else:
            print("Calculation is incorrect")
    except Exception as e:
        print(
            colorize(
                f"Error during {dtype.__str__().split('.')} specific multiplication: {e}",
                RED,
            )
        )
        exit(1)


def main(args):
    try:
        print(f"torch version: {torch.__version__}")
        torch.manual_seed(args.seed)
        import intel_extension_for_pytorch as ipex
        ipex.xpu.seed_all()
        if ipex.xpu.is_available():
            print(f"ipex version: {ipex.__version__}")
            device_name = ipex.xpu.get_device_name()
            print(f"Intel XPU device is available, Device name: {device_name}")
            if not ipex.xpu.has_fp64_dtype():
                print(
                    colorize(
                        "Warning: Native FP64 type not supported on this platform",
                        YELLOW,
                    )
                )
            data_types = [
                torch.int8,
                torch.int16,
                torch.int32,
                torch.int64,
                torch.float16,
                torch.float32,
                torch.bfloat16,
                torch.float64,
            ]
            for dtype in data_types:
                if dtype == torch.float64 and not ipex.xpu.has_fp64_dtype():
                    print(
                        colorize(
                            "Skipping direct FP64 multiplication tests, as the device doesn't support it.",
                            YELLOW,
                        )
                    )
                    continue
                test_random_multiplication(dtype)
                test_specific_multiplication(dtype)
        else:
            print("Warning: Intel XPU device is not available")
            raise Exception("Intel XPU device not detected")
        print(colorize("PyTorch XPU tests successful!", GREEN))
    except ImportError as e:
        print(colorize(f"Failed to import Intel Extension for PyTorch: {e}", RED))
    except Exception as e:
        print(colorize("An error occurred during the test: {e}", RED))


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Test Intel XPU device")
    parser.add_argument("--seed", type=int, default=42, help="Random seed")
    args = parser.parse_args()
    main(args)

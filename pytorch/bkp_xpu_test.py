import argparse
import logging
import torch

logger = logging.getLogger(__name__)

def test_random_multiplication():
    x = torch.rand(1, 1).to('xpu', dtype=torch.float16)
    y = torch.rand(1, 1).to('xpu', dtype=torch.float16)
    z = x * y
    logger.info("Random FP16 multiplication:")
    logger.info("  Input x: %s", x.cpu())
    logger.info("  Input y: %s", y.cpu())
    logger.info("  Output z: %s", z.cpu())

def test_specific_multiplication():
    x = torch.tensor([[1.0, 2.0]]).to('xpu', dtype=torch.float16)
    y = torch.tensor([[3.0, 4.0]]).to('xpu', dtype=torch.float16)
    z_expected = torch.tensor([[3.0, 8.0]]).to('xpu', dtype=torch.float16)
    z = x * y
    logger.info("Specific FP16 multiplication:")
    logger.info("  Input x: %s", x.cpu())
    logger.info("  Input y: %s", y.cpu())
    logger.info("  Output z: %s", z.cpu())
    if torch.allclose(z, z_expected):
        logger.info("Calculation is correct")
    else:
        logger.info("Calculation is incorrect")

def main(args):
    try:
        # Set random seed for reproducibility
        torch.manual_seed(args.seed)
        import intel_extension_for_pytorch as ipex
        ipex.xpu.seed_all()
        if ipex.xpu.is_available():
            logger.info("Intel XPU device is available")
            device_name = ipex.xpu.get_device_name()
            logger.info("Device name: %s", device_name)
            if not ipex.xpu.has_fp64_dtype():
                logger.warning("Native FP64 type not supported on this platform")
            # Test random multiplication
            test_random_multiplication()
            # Test specific multiplication
            logger.info("Check if multiplication with two tensors gives expected value")
            test_specific_multiplication()
        else:
            logger.warning("Intel XPU device is not available")
            raise Exception("Intel XPU device not detected")
        logger.info("XPU tests successful!")
    except ImportError as e:
        logger.exception("Failed to import Intel Extension for PyTorch: %s", e)
    except Exception as e:
        logger.exception("An error occurred during the test: %s", e)

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Test Intel XPU device')
    parser.add_argument('--seed', type=int, default=42, help='Random seed')
    parser.add_argument('--log-level', choices=['INFO', 'WARNING', 'ERROR', 'CRITICAL'], default='INFO', help='Logging level')
    args = parser.parse_args()
    logging.basicConfig(level=args.log_level)
    main(args)


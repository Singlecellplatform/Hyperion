import tensorflow as tf
import importlib.metadata
import sys
import cupy

cupy.show_config()try:
    cudnn_version = tf.sysconfig.get_build_info().get("cudnn_version", "Not Found")
    print("cuDNN Version:", cudnn_version)
except Exception as e:
    print("Error fetching cuDNN version:", e)

cuda_version = tf.sysconfig.get_build_info().get("cuda_version", "Not Found")
print("CUDA Toolkit Version:", cuda_version)


def get_package_versions():
    # List of all required packages
    all_packages = [
        "opencv-python", "matplotlib", "scipy", "seaborn", "tqdm", "numpy", 
        "scikit-image", "scikit-learn", "pillow", "shapely", "squidpy", 
        "descartes", "scanpy", "imctools"
    ]

    # Dictionary to store versions
    package_versions = {"Python": sys.version}

    # Check installed packages
    for pkg_name in all_packages:
        try:
            package_versions[pkg_name] = importlib.metadata.version(pkg_name)
            print(f"{pkg_name}: {package_versions[pkg_name]}")
        except importlib.metadata.PackageNotFoundError:
            package_versions[pkg_name] = "Not Installed"
            print(f"{pkg_name}: Not Installed")

 
if __name__ == "__main__":
    get_package_versions()



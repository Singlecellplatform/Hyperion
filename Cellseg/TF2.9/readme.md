set up the tensorflow 2.9 environment by conda in FIVE STEPS
1. chekc nvidia driver version in terminial nvidia-smi.
```
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 470.223.02   Driver Version: 470.223.02   CUDA Version: 11.4     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Quadro RTX 5000     Off  | 00000000:65:00.0  On |                  Off |
| 34%   34C    P8    15W / 230W |    291MiB / 16116MiB |      1%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|    0   N/A  N/A      1564      G   /usr/lib/xorg/Xorg                223MiB |
|    0   N/A  N/A      2962      G   /usr/bin/gnome-shell               36MiB |
|    0   N/A  N/A      6101      G   ...on=20250515-180047.882000       28MiB |
+-----------------------------------------------------------------------------+
```

2. Install nvidia toolkit by "https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html"
3. Use docker to run your tensorflow (we used tensorflow2.9,cuda 11.4, cudnn8), I also put my dockerfile in the folder and you can use it as template to build your onw Envirionment
test.sh
```
# wokring directory
WORKING_DIR="/media/yang/Hirbe_lab_Drive_5/MPNST_IMC_b3"

 # docker name in hub
DOCKER_Image="aibiologist/imc_sc:v1"

# Container name
DOCKER_NAME="imc_tf_run"

#export  LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu/:$LD_LIBRARY_PATH
 

docker run --runtime=nvidia --gpus all -it --rm \
    --name ${DOCKER_NAME} \
    -v ${WORKING_DIR}:/mnt \
    $DOCKER_Image /bin/bash -c "python /mnt/PY_function/python_Version_check.py"
```
 
4. The correct output after rnning ()

OS                           : Linux-5.4.0-150-generic-x86_64-with-glibc2.10
Python Version               : 3.8.15
CuPy Version                 : 10.6.0
CuPy Platform                : NVIDIA CUDA
NumPy Version                : 1.23.5
SciPy Version                : 1.10.1
Cython Build Version         : 0.29.24
Cython Runtime Version       : None
CUDA Root                    : /usr/local/cuda
nvcc PATH                    : None
CUDA Build Version           : 11040
CUDA Driver Version          : 11040
CUDA Runtime Version         : 11040
cuBLAS Version               : (available)
cuFFT Version                : 10502
cuRAND Version               : 10205
cuSOLVER Version             : (11, 2, 0)
cuSPARSE Version             : (available)
NVRTC Version                : (11, 4)
Thrust Version               : 101201
CUB Build Version            : 101201
Jitify Build Version         : 4a37de0
cuDNN Build Version          : 8400
cuDNN Version                : 8204
NCCL Build Version           : 21104
NCCL Runtime Version         : 21104
cuTENSOR Version             : None
cuSPARSELt Build Version     : None
Device 0 Name                : Quadro RTX 5000
Device 0 Compute Capability  : 75
Device 0 PCI Bus ID          : 0000:65:00.0
cuDNN Version: 8
CUDA Toolkit Version: 11.2
opencv-python: 4.6.0
matplotlib: 3.7.3
scipy: 1.10.1
seaborn: 0.11.2
tqdm: 4.67.1
numpy: 1.23.5
scikit-image: 0.21.0
scikit-learn: 1.3.2
pillow: 9.0.1
shapely: 1.7.1
squidpy: 1.1.2
descartes: 1.1.0
scanpy: 1.9.1
imctools: Not Installed

  

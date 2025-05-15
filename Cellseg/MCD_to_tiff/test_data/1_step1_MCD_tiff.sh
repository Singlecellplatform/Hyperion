#!/bin/bash

# wokring directory
WORKING_DIR="/Volumes/lyu.yang/MAC_1/Docker/IMC_pipeline/test_data"

 # docker name in hub
DOCKER_Image="aibiologist/imctools:v1"

# Container name
DOCKER_NAME="imctools_run"
 
 docker run -it --rm \
    --name ${DOCKER_NAME} \
    -v ${WORKING_DIR}:/mnt \
    $DOCKER_Image /bin/bash -c "ls /mnt/test_data; /sh_files/1_MCD_to_tiff.sh"
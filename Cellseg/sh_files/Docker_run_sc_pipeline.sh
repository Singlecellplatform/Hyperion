#!/bin/bash

Up_dir=$(dirname "$PWD")
CONFIG_FILE="${Up_dir}/config.sh"
if [ -z "$CONFIG_FILE" ]; then
    echo "No config.sh file found in /mnt"
    exit 1
fi
source "$CONFIG_FILE"
source "$CONFIG_FILE"
 
# Container name
DOCKER_NAME="imc_tf_run"
docker run --runtime=nvidia --gpus all -it --rm \
    --name ${DOCKER_NAME} \
    -v ${WORKING_DIR}:/mnt \
    $DOCKER_Image_sc /bin/bash /mnt/sh_files/Sc_expression_pipeline.sh 

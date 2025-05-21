#!/bin/bash

Up_dir=$(dirname "$PWD")
CONFIG_FILE="${Up_dir}/config.sh"
if [ -z "$CONFIG_FILE" ]; then
    echo "No config.sh file found in /mnt"
    exit 1
fi
source "$CONFIG_FILE"

# Container name
DOCKER_NAME="imctools_run"
echo $DOCKER_NAME

docker run -it --rm \
    --name ${DOCKER_NAME} \
    -v ${WORKING_DIR}:/mnt \
    $DOCKER_Image_imctools /bin/bash -c "/mnt/sh_files/MCD_to_tiff.sh"

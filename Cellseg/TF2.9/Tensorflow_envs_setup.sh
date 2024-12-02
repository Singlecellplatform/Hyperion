#!/bin/bash

 #!/bin/bash

# Function to display usage instructions
usage() {
    echo "Usage: $0 [install|update]"
    echo "  install: Create the Conda environment using the requirements file"
    echo "  update : Update the Conda environment using the requirements file"
    exit 1
}

# Check if an argument is provided
if [ -z "$1" ]; then
    usage
fi

# Path to mamba and the requirements file
MAMBA_PATH=~/miniforge3/bin/mamba
REQUIREMENTS_FILE=./Deepimcyto_docker/requirements_update.yml
ENV_NAME=rapids

# Function to create the environment
create_env() {
    echo "Creating the Conda environment..."
    $MAMBA_PATH env create -f $REQUIREMENTS_FILE
}

# Function to update the environment
update_env() {
    echo "Updating the Conda environment..."
    $MAMBA_PATH env update --name $ENV_NAME -f $REQUIREMENTS_FILE
}

# Perform action based on the argument
case "$1" in
    install)
        create_env
        ;;
    update)
        update_env
        ;;
    *)
        usage
        ;;
esac

 
# run only for the first time
# ~/miniforge3/bin/mamba env create -f ./Deepimcyto_docker/requirements_update.yml

# update env
 #~/miniforge3/bin/mamba env update --name rapids -f ./Deepimcyto_docker/requirements_update.yml
 
# source activate  ~/miniforge3/envs/rapids


 exit
 

# config.sh - Configuration for IMC pipeline

# set your work project, make sure your mcd files is in /your_project/Raw 
WORKING_DIR="/media/yang/Hirbe_lab_Drive_5/MPNST_IMC_b3"

# docker images setting
DOCKER_Image_imctools="aibiologist/imctools:v1"
DOCKER_Image_sc="aibiologist/imc_sc:v1"


# sample list file (if the file is not prepared, the pipeline will make it automately)
csv_file="/mnt/Sample_list.csv"

#######################################################################################3
# These parameters are for nuclei segmentation and single cell expression

# Number of neighbors for segmentation analysis
N_neighbours=5

# Radius used in nuclear dilation
nuclear_dilation_radius=2

# Parameters for hot pixel removal
filter_size=3
hot_pixel_threshold=50

# Weight path
Weight_path="/mnt/8263899/deep-imcyto_weights"

 




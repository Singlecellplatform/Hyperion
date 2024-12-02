#!/bin/bash -euo pipefail
  source activate rapids
  #export PATH=/depot/cuda/cuda-11.2/bin:$PATH
  #export TF_GPU_ALLOCATOR=cuda_malloc_async
  #export TF_ENABLE_ONEDNN_OPTS=0
  export PATH=/usr/local/cuda-11.4/bin${PATH:+:${PATH}}$ # solve the issue ptxas
  
  export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/yang/miniconda3/envs/rapids/lib
  echo $LD_LIBRARY_PATH
  
  
  #export TF_GPU_ALLOCATOR=cuda_malloc_async

  #correct lr with learning_rate in adam.py
  
  # set the path for the file.png
  Result_path=./results/deep-imcyto/Test_simple
  IMCtool_path=$Result_path/imctools
  for d in ${IMCtool_path}/*; do
   PT_name=$(basename "$d" \;)
 
   ROI=$(find "$d" -mindepth 1 -maxdepth 2 -type d -exec basename {} \; | grep "roi")
   ###########################################################
   for R in $ROI; do
   # Output the ROI paths
    echo "ROI paths:"
    fname="$PT_name"-"$R"
    echo $fname
    stack_dir=$d/$R/full_stack
    echo $stack_dir
    filename=$Result_path/nuclear_preprocess/${fname}.png 
    sample_name=$(basename "$fname" .png)
    outfile=${sample_name}.cells.csv
    mask=$Result_path/postprocess_predictions/${sample_name}_nuclear_mask.tiff
    echo $mask
    cellmask=$Result_path/postprocess_predictions/${sample_name}_nuclear_mask_nuclear_dilation.tiff
    echo $cellmask
    N_neighbours=5
    nuclear_dilation_radius=2
   
   
 
   if [ ! -f ${mask} ]; then
   echo "predict processing is starting"
      /media/yang/Hirbe_lab_Drive_5/Deepcyto2/deep-imcyto/bin/predict.py --image $filename --outdir $Result_path --weights /media/yang/Hirbe_lab_Drive_5/Deepcyto2/8263899/deep-imcyto_weights 2>&1 | tee output.txt
  
   fi

   if [ ! -f ${cellmask} ]; then
    echo "nuclear dilation is starting"
  /media/yang/Hirbe_lab_Drive_5/Deepcyto2/deep-imcyto/bin/nuclear_dilation.py --input_mask ${mask} --output_directory $Result_path/postprocess_predictions --radius $nuclear_dilation_radius

   fi
 
   hotpixel_remove_path=${d}/${R}/hotpixel_removed
  
   tiff_count_d=$(find "${hotpixel_remove_path}" -maxdepth 1 -type f -name "*.tiff" | wc -l)
   tiff_count_stack=$(find "$stack_dir" -maxdepth 1 -type f -name "*.tiff" | wc -l) 
   echo $tiff_count_d
   echo $tiff_count_stack
  
   if [ "$tiff_count_d" != "$tiff_count_stack" ]; then
      echo "remove hot pixel is starting"
    /media/yang/Hirbe_lab_Drive_5/Deepcyto2/deep-imcyto/bin/remove_hotpixels_channel.py --input_dir $stack_dir\
                  --outdir $hotpixel_remove_path\
                  --filter_size 3\
                  --hot_pixel_threshold 50\
                  --file_extension '.tiff'  2>&1 | tee output.txt
   fi
   
   mkdir $Result_path/single_cell

   # single cell measurment for original image
   outfile=${sample_name}.cells.csv
   #if [ ! -f $Result_path/single_cell/${outfile} ]; then
    echo "single cell measurement starting"
     
   /media/yang/Hirbe_lab_Drive_5/Deepcyto2/deep-imcyto/bin/simple_seg_measurement.py --input_dir ${stack_dir} --output_dir $Result_path/single_cell --label_image_path ${cellmask} --output_file ${outfile} --n_neighbours $N_neighbours
   
   
   #fi
   
   # single cell measurment for hotpixel removal image
   outfile=${sample_name}_hot_pixel_removal.cells.csv
   #if [ ! -f $Result_path/single_cell/${outfile} ]; then
    echo "single cell measurement starting"
    /media/yang/Hirbe_lab_Drive_5/Deepcyto2/deep-imcyto/bin/simple_seg_measurement.py --input_dir ${hotpixel_remove_path} --output_dir $Result_path/single_cell --label_image_path ${cellmask} --output_file ${outfile} --n_neighbours $N_neighbours

   #fi
   ##########################################################   
 
  done
 
 done
 

 exit


   

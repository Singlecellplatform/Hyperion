#!/bin/bash

# Example shell script

CONFIG_FILE="/mnt/config.sh"


if [ -z "$CONFIG_FILE" ]; then
    echo "No config.sh file found in /mnt"
    exit 1
fi
source "$CONFIG_FILE"

PY_function_path="/mnt/PY_function"
# Step 1: Check if the CSV file exists

if [ ! -f "$csv_file" ]; then
  echo "CSV file not found. Generating with Python script..."
  python ${PY_function_path}/Generating_samplelist.py /mnt/Raw
fi


new_csv="${csv_file%.csv}_new.csv"

echo $csv_file
if grep -q $'\r$' "$csv_file"; then
     echo "$(tr -d '\r' < $csv_file)" > $new_csv
     echo "Converted file saved as $new_csv"
else
   new_csv=${csv_file}
  
fi

 

tail -n +2 "$new_csv" | while IFS=$',\t' read -r raw_file_path metafile_path output_path; do

  echo $output_path
  Slide_ID=$(basename "$raw_file_path")
  echo "$Slide_ID"
  Slide_ID=${Slide_ID%%.mcd}
  Slide_path="$output_path/$Slide_ID"
  echo "$Slide_path"
  for d in ${Slide_path}/*roi*; do
    nuclei_path=${d}/nuclear
    DNA1_path=$(find "$nuclei_path" -type f | grep "DNA1")
    DNA2_path=$(find "$nuclei_path" -type f | grep "DNA2")
    ROI_name=$(basename "$d" \;)
    filename=${d}/nuclear_preprocess/$nuclear_preprocess/${Slide_ID}_${ROI_name}.png 
    if [ ! -f $filename ]; then 
      python3 ${PY_function_path}/unet_preprocess.py --dna1 $DNA1_path --dna2 $DNA2_path --outdir ${d}/nuclear_preprocess --imagename ${Slide_ID}_$ROI_name
    fi
    sample_name=$(basename "$filename" .png)
    outfile="${sample_name}.cells.csv"
    mask="${d}/postprocess_predictions/${sample_name}_nuclear_mask.tiff"
    cellmask="${d}/postprocess_predictions/${sample_name}_nuclear_mask_nuclear_dilation.tiff"

    echo "Mask path: $mask"
    echo "Cell mask: $cellmask"

    # Predict nuclei if mask not present
    if [ ! -f "$mask" ]; then
      echo "Prediction starting..."
      python3 ${PY_function_path}/predict.py \
        --image "$filename" \
        --outdir "$d" \
        --weights $Weight_path 2>&1 | tee output.txt
    fi

    # Nuclear dilation if not already done
    if [ ! -f "$cellmask" ]; then
      echo "Dilation starting..."
      python3 ${PY_function_path}/nuclear_dilation.py \
        --input_mask "$mask" \
        --output_directory "${d}/postprocess_predictions" \
        --radius $nuclear_dilation_radius
    fi

     # === Hot pixel removal ===
    stack_dir="${d}/full_stack"
    hotpixel_remove_path="${d}/hotpixel_removed"
    tiff_count_d=$(find "$hotpixel_remove_path" -maxdepth 1 -type f -name "*.tiff" | wc -l)
    tiff_count_stack=$(find "$stack_dir" -maxdepth 1 -type f -name "*.tiff" | wc -l)

    echo "Tiff count (original): $tiff_count_stack"
    echo "Tiff count (denoised): $tiff_count_d"

    if [ "$tiff_count_d" -ne "$tiff_count_stack" ]; then
      echo "Removing hot pixels..."
      python3 ${PY_function_path}/remove_hotpixels_channel.py \
        --input_dir "$stack_dir" \
        --outdir "$hotpixel_remove_path" \
        --filter_size $filter_size \
        --hot_pixel_threshold $hot_pixel_threshold \
        --file_extension '.tiff' 2>&1 | tee output.txt
    fi
    # === Single-cell measurements ===
    mkdir -p "${d}/single_cell"

    outfile="${sample_name}.cells.csv"
    if [ ! -f "${d}/single_cell/${outfile}" ]; then
      echo "Measuring single cells (raw)..."
      python3 ${PY_function_path}/simple_seg_measurement.py \
        --input_dir "$stack_dir" \
        --output_dir "${d}/single_cell" \
        --label_image_path "$cellmask" \
        --output_file "$outfile" \
        --n_neighbours $N_neighbours
    fi

    outfile="${sample_name}_hot_pixel_removal.cells.csv"
    if [ ! -f "${d}/single_cell/${outfile}" ]; then
      echo "Measuring single cells (hotpixel removed)..."
      python3 ${PY_function_path}/simple_seg_measurement.py \
        --input_dir "$hotpixel_remove_path" \
        --output_dir "${d}/single_cell" \
        --label_image_path "$cellmask" \
        --output_file "$outfile" \
        --n_neighbours $N_neighbours
    fi



    
  done
    
done



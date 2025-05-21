#!/bin/bash
# finding config.sh file in /mnt foloder
CONFIG_FILE=$(find /mnt -name "config.sh" 2>/dev/null)

if [[ -f "$CONFIG_FILE" ]]; then
    source "$CONFIG_FILE"
else
    echo "Error: Config file '$CONFIG_FILE' not found!"
    exit 1
fi

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

  echo $raw_file_path
  echo $metafile_path
  echo $output_path
   # Check if the file exists
  if [ -f "$raw_file_path" ]; then
        echo "File $raw_file_path exists."
      
  else
       echo "File $raw_file_path does not exist."
       exit
  fi
  # Check if the metafile exists
  if [ -f "$metafile_path" ]; then
        echo "File $metafile_path exists."
        echo "starting MCD to tiffs"
    else
        echo "File $metafile_path does not exist."
        exit 
   fi
 
 python3 ${PY_function_path}/run_imctool_v2.py ${raw_file_path} ${metafile_path} ${output_path} False
 #rm $new_csv
 done

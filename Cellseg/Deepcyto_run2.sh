#!/bin/bash
 
  source /home/yang/anaconda3/bin/activate Deepcyto


# set up working folders
 Input_files=/media/yang/Hirbe_lab_Drive_5/MPNST_IMC/RAW
 Metadata=/media/yang/Hirbe_lab_Drive_5/MPNST_IMC/RAW/metadata_2.csv
 prefix=Test_simple
 Result_path=/media/yang/Hirbe_lab_Drive_5/MPNST_IMC/results/deep-imcyto/${prefix}
################################################################
# Define a deep-imcyto running env:
  Deepcyto_data_path=/media/yang/Hirbe_lab_Drive_5/Deepcyto2
  Deepcyto_NF_path=${Deepcyto_data_path}/deep-imcyto
  Deepcyto_weight_path=${Deepcyto_data_path}/8263899/deep-imcyto_weights
  Deepcyto_work_path=./work
# set singularity
  export NXF_SINGULARITY_CACHEDIR=${Deepcyto_data_path}/container
  export SINGULARITY_TMPDIR=$Deepcyto_data_path/singularity
  #export SINGULARITY_BIND="/opt,/data:/mnt"
 # fix file transfer issue 
 export NXF_ENABLE_VIRTUAL_THREADS=false
#################################################################3
# RUN IMCtools in DEEP-IMCYTO :

 Preprocss_path=$Result_path/nuclear_preprocess
 for d in ${Input_files}/*.mcd; do
  echo $d
  MCD_name=$(basename "$d" .mcd )
 
  echo $MCD_name
  preprocess_file=$(find "${Preprocss_path}" -maxdepth 1 -type f -name "*.png" | grep $MCD_name | wc -l)
 
  echo $preprocess_file
 


  if [ $preprocess_file -eq 0 ]; then
    echo "nextflow"
    nextflow run ${Deepcyto_NF_path}/main.nf  --release $prefix \
     --input ${Input_files}/${MCD_name}.mcd\
     --metadata $Metadata \
     --outdir ./results \
     --scratch  ${Deepcyto_data_path}/tmp \
     --nuclear_weights_directory  ${Deepcyto_weight_path} \
     --segmentation_workflow 'simple'\
     -profile singularity --enable trace.overwrite \
     -w ${Deepcyto_work_path} --max_cpus 8 --max_memory 110.GB -resume
  fi
 done

exit

  #  --singularity_bind_path '$PWD'\
  

    

## LOAD MODULES
 #ml purge
 #ml Nextflow/22.04.0
 #ml Singularity/3.8.6
# edit base.config to solve running time issue

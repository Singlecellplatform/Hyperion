This pipeline processes Imaging Mass Cytometry (IMC) data for single-cell expression analysis using the DeepCyto2 model. It includes  nuclear segmentation, hot pixel removal, and single-cell feature extraction. All will be done in FIVE STEPS

---
## 1. data preparation
 ###  Download or copy all files from the `SC_expression` folder into your project directory so that the folder structure looks like above. 
 ###  Download DeepCyto2 Model Weights,Download model weights from **[Zenodo Record 8263899](https://zenodo.org/records/8263899)**  
 
```
 your_project/
├── Raw/ # Raw MCD files and metafile
├── results/ # Output folder for processed results
│ └── slide_ID/
│     └── ROI/
├── PY_function/ # Python scripts (e.g., predict.py, measurement.py)
│── deep-imcyto_weights/ # Downloaded model weights
├── sh_files/ # Shell scripts (e.g., Docker_run_pipeline.sh)
├── config.sh # Configuration file for pipeline parameters
├── sample_list.csv # Initial sample list (optional)
 

```
## 2: Edit the Configuration File

 Edit the `config.sh` file to specify key parameters for processing

## 3 : Run the Pipeline via Docker 

```
cd your_project/sh_files
bash Docker_run_pipeline.sh

```

 
 



# IMC Pipeline

This pipeline was inspired by [deep-imcyto](https://github.com/FrancisCrickInstitute/deep-imcyto).  
It uses Docker to run all these pipelines

This pipeline was inspired by [deep-imcyto](https://github.com/FrancisCrickInstitute/deep-imcyto).

Let’s finish your project in **FIVE simple steps**:

---

## ✅ Step 1: Check Your Environment

Make sure the following are set up correctly:

- Docker version is **≥ 23.0**
- You have a valid **TensorFlow 2.9** Conda environment

📂 For instructions on setting up TensorFlow 2.9, refer to the folder: TF2.9

```

```

## ✅ Step 2: Download This GitHub Repository

You can get the pipeline in two ways:

### a. Git (recommended)

```bash
git clone https://github.com/Hyperion/Cellseg.git
```
### b. Manual Download
Click the green Code button on this page

Select Download ZIP

Extract it into your project folder
```
```
## ✅ Step 3: Prepare Project Folder Structure 
🔗 Download model weights from Zenodo:
https://zenodo.org/records/8263899
Organize your files/structure like this:

```
your_project/
├── Raw/                         # Raw MCD files
├── results/                     # Output directory
│   └── slide_ID/ROI/
├── PY_function/                # Python scripts
│   └── 8263899/
│       └── deep-imcyto_weights/   # Model weights from Zenodo
├── sh_files/                   # Shell scripts
├── config.sh  
```
```
```
## ✅ Step 4: put your mcd files in the Raw folder and Configure the Pipeline by editing the config.sh file:


```
```
## ✅ Step 5: Run the Pipeline

```
cd /sh_files
bash Docker_MCD_tiff_pipeline.sh
bash Docker_run_sc_pipeline.sh
```
```

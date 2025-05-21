---

## Requirements

Make sure you have [Docker](https://www.docker.com/products/docker-desktop) installed and working on your system.

---

## Step 1: Convert MCD Files to TIFF

### 1.1 Download Test Data in the folder "MCD_to_tiff"

Download all the files and folders from the `test_folder` directory into your local project folder.  
Example: /Volumes/your_name/MAC_1/Docker/IMC_pipeline/test_data

### 1.2 Place Your MCD Files and metafile

Place all your `.mcd` files and metafile.csv into the `Raw` subfolder of your project directory: /Your_Project/Raw

### 1.3 Edit `Sample_list.csv`

Open `Sample_list.csv` in your project folder and **replace all paths with `/mnt`**, since Docker will access files using `/mnt`.

> ✅ Example:
> Replace:
> `/Volumes/lyu.yang/MAC_1/Docker/IMC_pipeline/test_data/Raw/sample1.mcd`  
> With:
> `/mnt/Raw/sample1.mcd`

### 1.4 Configure the Script

Open the script `1_step1_MCD_tiff.sh` and edit the following line:

WORKING_DIR="/path/to/your/local/project"

### 1.5 Run the Pipeline in terminal

bash 1_step1_MCD_tiff.sh 


## Example Directory Structure

```
IMC_pipeline/
├── 1_step1_MCD_tiff.sh
├── Sample_list.csv       # Edited with /mnt paths
├── Raw/                  # Contains your .mcd files
├── Results/                 # Output TIFFs go here

```
---

## 🧩 Next Steps

Coming soon:  
- TIFF to cell segmentation  
- Single-cell analysis  
- Marker quantification

---

## 🧠 Notes

- Use `--rm` in Docker to auto-remove containers
- You can customize the mounted directory by changing the `WORKING_DIR` variable which is your current working directory

---

For any issues, please open an [issue on GitHub](https://github.com/your-repo/issues).

2. cell segmetation and single cell expression (is updating)
2.1 Download both the deep-imcyto trained nucleus model weights and the example test dataset from our Zenodo repository (https://doi.org/10.5281/zenodo.7573269)
2.2 set up conda environment for Deepcyto by running conda env create -f $(filepath)/Deepcyto_install.yml.
2.3 set up conda environment for Tensorflow 2.9 by running conda env create -f $(filepath)/Tensorflow_envs_setup.sh
2.4 Process preprocess step by running $(filepath)/Deepcyto_run2.sh (correct the path for the py and other files based on your setting)
2.55 Process nuclei prediction by running $(filepath)/tf_predict.sh (correct the path for the py and other files based on your setting)


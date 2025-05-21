---

## Requirements

Make sure you have [Docker](https://www.docker.com/products/docker-desktop) installed and working on your system.

---

## Step 1: Convert MCD Files to TIFF

### 1.1 Download sh_files and PY_function folder in your project

Download all the files and folders from the `test_folder` directory into your local project folder.  
Example: /Volumes/your_name/MAC_1/Docker/IMC_pipeline/test_data

### 1.2 Place Your MCD Files and metafile (metadata*.csv) in the Raw folder of your project (/your_project/Raw)

### 1.3  configure your config.sh

### 1.4 Run the Pipeline in terminal

```
bash /your_project_folder/sh_files/Docker_MCD_tiff_pipeline.sh
```

## Example Directory Structure

```
Your project/
├──sh_files
├──Raw/                  # Contains your .mcd files
├── results/              # Output TIFFs go here
├── PY_function

```
 



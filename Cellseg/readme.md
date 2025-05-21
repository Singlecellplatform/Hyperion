# IMC Pipeline

This pipeline was inspired by [deep-imcyto](https://github.com/FrancisCrickInstitute/deep-imcyto).  
It uses Docker to run all these pipelines

---

## Step 1: Convert MCD Files to TIFF. see the pipeline in the sub folder mcd_to_tiff
 



---

For any issues, please open an [issue on GitHub](https://github.com/your-repo/issues).

2. cell segmetation and single cell expression (is updating)
2.1 Download both the deep-imcyto trained nucleus model weights and the example test dataset from our Zenodo repository (https://doi.org/10.5281/zenodo.7573269)
2.2 set up conda environment for Deepcyto by running conda env create -f $(filepath)/Deepcyto_install.yml.
2.3 set up conda environment for Tensorflow 2.9 by running conda env create -f $(filepath)/Tensorflow_envs_setup.sh
2.4 Process preprocess step by running $(filepath)/Deepcyto_run2.sh (correct the path for the py and other files based on your setting)
2.55 Process nuclei prediction by running $(filepath)/tf_predict.sh (correct the path for the py and other files based on your setting)

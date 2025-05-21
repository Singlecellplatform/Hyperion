
#docker image prune -f
#docker system df
#docker builder prune -f
# delete all images: docker rmi $(docker images -q) --force
# docker builder prune -a -f
cd /Volumes/lyu.yang/MAC_1/Docker/IMC_pipeline/Singlecell_express


docker build -t imc_sc:v1 -f Cuda_tf.Dockerfile . # works
docker run -it --rm -v /Volumes/lyu.yang/MAC_1/Docker/IMC_pipeline/Singlecell_express:/mnt imc_sc:v1  /bin/bash -c "python /mnt/PY_function/python_Version_check.py"

docker run -it  --entrypoint /bin/bash --rm -v /Volumes/lyu.yang/MAC_1/Docker/IMC_pipeline/Singlecell_express:/mnt imc_sc:v1  /bin/bash -c " source /opt/conda/etc/profile.d/conda.shpython /mnt/PY_function/python_Version_check.py"

#docker images | grep gs_pipeline:latest

#docker run -it imc_sc:v1
#docker run -it -v /Volumes/lyu.yang/MAC_1/Docker/IMC_pipeline:/mntimc_sc:v1

docker tag imc_sc:v1  aibiologist/imc_sc:v1
docker push aibiologist/imc_sc:v1




docker run -it --name tf2.9-container tf2.9

docker run -it --rm gatk-python:latest /bin/bash

#docker tag gatk-python:latest <your-dockerhub-username>/gatk-python:latest

#docker push <your-dockerhub-username>/gatk-python:latest
#docker build -t imc_sc:v1 -f Tensor2.9.Dockerfile .
#docker bulit -t imc_sc:v1 -f Tf2.9.Dockerfile . #

# docker build -t imc_sc:v1 -f Tf2.9.Dockerfile . (cuda 11.2,not compatative with local SMI)

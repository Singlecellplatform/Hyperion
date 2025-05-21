#FROM rapidsai/rapidsai:cuda11.2-runtime-ubuntu20.04-py3.8
# Use a base image that already has conda installed
FROM  condaforge/miniforge3:latest AS mamba 
ARG TINI_VERSION=0.19.0
RUN mamba install -c conda-forge tini=$TINI_VERSION

FROM nvidia/cuda:11.4.3-cudnn8-runtime-ubuntu20.04
ARG CONDA_PREFIX="tf29"
RUN apt-get update && apt-get install -y python3-pip
#RUN pip install cupy-cuda114
RUN apt-get update && apt-get install -y libstdc++6 libgl1-mesa-glx


COPY  --from=mamba /opt/conda /opt/conda
COPY ./docker/entrypoint.sh /opt/docker/bin/entrypoint
RUN chmod +x /opt/docker/bin/entrypoint

COPY ./environment.yml /tmp/environment.yml

ENV PATH=/opt/conda/bin:$PATH

RUN mamba --version
COPY ./environment.yml /tmp/environment.yml
RUN /bin/bash -c "mamba env create -f /tmp/environment.yml"

#RUN /bin/bash -c "mamba env create -f /tmp/environment.yml"

#RUN mamba env update -n base -f /tmp/environment.yml && \
#    conda clean --all --yes && \
#    rm -f /tmp/environment.yml

# install pip
COPY ./pip_requirements.txt /tmp/pip_requirements.txt
RUN /bin/bash -c "conda run -n ${CONDA_PREFIX} pip install --upgrade pip && \
                 conda run -n ${CONDA_PREFIX} pip install -r /tmp/pip_requirements.txt"


# Activate the Conda environment and run multiple commands
RUN /bin/bash -c "conda run -n ${CONDA_PREFIX}  env && \
                 conda run -n ${CONDA_PREFIX}  conda info && \
                 conda run -n ${CONDA_PREFIX}  conda config --show-sources && \
                 conda run -n ${CONDA_PREFIX}  conda list --show-channel-urls"


# add lib to the path
ENV LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${CONDA_PREFIX}/lib:/opt/conda/envs/${CONDA_PREFIX}/lib"
ENV LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/opt/conda/envs/${CONDA_PREFIX}/lib"
 
# Dump the details of the installed packages to a file for posterity
#RUN conda env export --name rapids > rapids_container.yml

ENV PATH="/usr/local/cuda-11.4/bin:${PATH}"

ENV LD_LIBRARY_PATH="/usr/local/cuda-11.4/lib64:/usr/local/cuda-11.4/compat:/opt/conda/envs/${CONDA_PREFIX}/lib:${LD_LIBRARY_PATH}"

ENTRYPOINT [ "/opt/conda/bin/tini", "--", "/opt/docker/bin/entrypoint" ]
ENV PATH="/opt/conda/conda/bin:/opt/conda/envs/${CONDA_PREFIX}/bin:/opt/conda/bin:/usr/local/nvidia/bin:/usr/local/cuda/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

#CMD ["jupyter", "lab", "--allow-root", "--ip", "127.0.0.1", "--port", "8888"]
CMD [ "/bin/bash" ]




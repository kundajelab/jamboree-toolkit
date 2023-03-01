ARG PARENT_DOCKER
ARG NB_USER="jovyan"
ARG NB_UID=1000
ARG NB_GID=100


FROM "$PARENT_DOCKER"

USER root

RUN apt-get update && \
    apt-get install --yes --no-install-recommends \
    libopenblas-base \
    libopenblas-dev \
    libzmq3-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    libatlas-base-dev \
    libhdf5-dev \
    libsuitesparse-dev \
    libxml2-dev \
    libopenmpi-dev \
    libnss3 \
    xvfb \
    libglpk-dev \
    libproj-dev && \
    apt-get autoremove -y && \
	apt-get autoclean -y && \
    chmod -R 777 /usr/local/share && \
    chmod -R 777 /data && \
    chmod -R 777 /usr/local/lib/R

COPY files/* /tmp/
USER $NB_UID

# #install R packages
RUN Rscript /tmp/install_R_packages.R

#install python packages
RUN conda env create -f /tmp/conda_assignment_1.yml
SHELL ["conda","run","-n","assignment_1","/bin/bash","-c"]
RUN pip install bash_kernel && \
    python -m ipykernel install --name assignment_1 --display-name "Assignment 1" && \
    pip install -U -r /tmp/pip_assignment_1.txt

RUN conda env create -f /tmp/conda_tutorial_2_dragonn.yml
SHELL ["conda","run","-n","tutorial_2_dragonn","/bin/bash","-c"]

RUN pip install bash_kernel && \
    python -m ipykernel install --name tutorial_2_dragonn --display-name "Tutorial 2" && \
    pip uninstall -y \
    'albumentations' \
    'folium' \
    'datascience' && \
    pip install --no-cache-dir \
    'dragonn==0.4.1' && \
    pip uninstall -y \
    'tensorflow-gpu' && \
    pip install --no-cache-dir \
    'tensorflow==1.15' \
    'keras==2.3' \
    'matplotlib==2.2.3'

# RUN conda env create -f /tmp/conda_assignment_3.yml
# SHELL ["conda","run","-n","assignment_3","/bin/bash","-c"]
# RUN pip install bash_kernel && \
#     python -m ipykernel install --name assignment_3 --display-name "Assignment 3" && \
#     pip install -U -r /tmp/pip_assignment_3.txt

SHELL ["conda","run","-n","base","/bin/bash","-c"]
RUN conda init && \
    echo 'conda activate base' >> ~/.bashrc &&\
    jupyter labextension install jupyterlab-plotly

USER root
RUN rm -rf /tmp/*
USER $NB_UID

EXPOSE 8888
ENTRYPOINT ["tini", "-g", "--"]
CMD ["start-notebook.sh"]
